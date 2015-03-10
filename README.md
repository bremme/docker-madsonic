<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
#Table of Contents

- [Docker [Madsonic](http://www.madsonic.org/) 5.2](#docker-[Madsonic](http://www.madsonic.org/)-52)
- [Building image](#building-image)
- [Running container](#running-container)
  - [Just run](#just-run)
  - [Configuration](#configuration)
  - [Recommended use](#recommended-use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Docker [Madsonic](http://www.madsonic.org/) 5.2

Docker image of [Madsonic](http://www.madsonic.org/) 5.2.5420 build on Debian Jessie using supervisor to bootstrap and run [Madsonic](http://www.madsonic.org/).

## Features

* Lightweight Debian based
* [Supervisor](http://supervisord.org/) process management
* UTF-8 support
* Exposes most of the [Madsonic](http://www.madsonic.org/) configuration options through environmental variables

# Building image

```shell
$ git clone
$ sudo docker build -t bremme/madsonic
```

# Running container

## Just run

```shell
$ sudo docker run \
    --volume=/my_music_dir:/var/media/artists \
    --publish=4040:4040 \
    --name madsonic \
    --detach \
    bremme/madsonic
```

## Configuration

[Madsonic](http://www.madsonic.org/) can be configured through environmental variables. These variables can be pased to the Docker `run` command using the `--env=VARIABLE=value` switch or loaded from a file using the `--env-file=my_env_file.env` switch. Avaliable variables are:


| Variables         | Default           |   Description                     |
|-------------------|------------------:|-----------------------------------|
| MAD_HOST          | 0.0.0.0           | Hostname/ip address               |
| MAD_PORT          | 4040              | HTTP port                         |
| MAD_HTTPS_PORT    | 0                 | HTTPS port (0 = disabled)         |
| MAD_CONTEXT_PATH  | /                 | The last part of the madsonic URL |
| MAD_INIT_MEM      | 192               | Init Java heap size in megabytes  |
| MAD_MAX_MEM       | 384               | Max Java heap size in megabytes   |
| MAD_TIME_ZONE     | Europe/Amsterdam  | Timezone                          |
| MAD_UID           | 1000              | madsonic UID                      |
| MAD_GID           | 1000              | madsonic GID                      |
 
If you are mounting a music directory from your host machine and you want [Madsonic](http://www.madsonic.org/) to be able to change album art and tags, MAD_UID and MAD_GID should match the UID and GID of the music directory on the host machine.

So if you music collection is store at `/home/foo/music` and the uid of foo is `1020` and the gid `1035` you should start [Madsonic](http://www.madsonic.org/) with:

```shell
$ sudo docker run \
    --env=MAD_UID=1020 \
    --env=MAD_GID=1035 \
    --volume=/home/foo/music:/var/media/artists \
    --publish=4040:4040 \
    --name madsonic \
    --detach \
    bremme/madsonic
```


## Recommended use

```shell
docker run \
    --env=MAD_UID=1000 \
    --env=MAD_GID=1000 \
    --volumes-from=data-[Madsonic](http://www.madsonic.org/) \
    --volume=/my_music_dir:/var/media/artists \
    --volume=/etc/timezone:/etc/timezone:ro \
    --publish=49155:4040 \
    --name madsonic \
    --restart=always \
    --detach=true \
    bremme/madsonic
```

## Logs

[Madsonic](http://www.madsonic.org/) will log to three places:

* stdout goes to: `/var/log/supervisor/madsonic.stdout.log`
* stderr goed to: `/var/log/supervisor/madsonic.stderr.log`
* madsonic's own log goes to: `/var/madsonic/madsonic.log`

You can follow the logs for debuggin by:

```shell
$ sudo docker exec -it madsonic \
    tail -f \
        /var/log/supervisor/madsonic.stdout.log \
        /var/log/supervisor/madsonic.stderr.log  \
        /var/madsonic/madsonic.log
```

# Troubleshooting 

During building the [Madsonic](http://www.madsonic.org/) image I ran into several problems. All of them should be fixed in this image. But perhaps you run into similair problem for whatever reason. Here are some of the things I did to solve the problems I encountered.

## No UTF-8 support

Some of the tracks in my music collection contain characters not in the default C.UTF-8 locale. I search for how to properly fix this, and found numerous solutions, this is what I eventually applied and works.

```
# fix language
RUN apt-get update && \
    apt-get install locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US:en \
    LANGUAGE=en_US.UTF-8
```

Adding or uncommenting `en_US.UTF-8 UTF-8` to/from `/etc/locale.gen` incombination with `locale-gen` generates the new locale. You can check if it properly installed by `locale -a`. Setting the locale environmental variables afterward does not result in any error and your new locale is properly configured.

## Properly starting and stopping [Madsonic](http://www.madsonic.org/)

First, if you are familiar with supervisor this is all familiar. But if not, this is how it works.

1. The [Supervisor](http://supervisord.org/) deamon reads all config files in `/etc/supervisor/conf.d/*`
2. These config files launch a script or binairy (mine are at `/usr/local/bin/`)
3. In case of [Madsonic](http://www.madsonic.org/) this `bash` script launches [Madsonic](http://www.madsonic.org/) which is a Java application.

I need the `bash` script for bootstrapping [Madsonic](http://www.madsonic.org/), but I don't want it to spawn another process. The key is using [`exec`](http://wiki.bash-hackers.org/commands/builtin/exec). `exec` replace the shell with a given program (executing it, not as new process) and that's what I needed.

For now I use the default `SIGTERM` signal to stop Madsonic. I'm not totally sure if this is real gracefull shutdown, but works for now.

# Thanks to

Building this image I used to following repro's for inspiration:

https://github.com/sdhibit/docker-madsonic
https://github.com/binhex/arch-madsonic
https://github.com/plytro/docker-madsonic
https://github.com/botez/docker-madsonic