<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
#Table of Contents

- [Docker Madsonic 5.2](#docker-madsonic-52)
- [Building image](#building-image)
- [Running container](#running-container)
  - [Just run](#just-run)
  - [Configuration](#configuration)
  - [Recommended use](#recommended-use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Docker Madsonic 5.2

Docker image of Madsonic 5.2.5420 build on Debian Jessie using supervisor to bootstrap and run Madsonic.

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

Madsonic can be configured through environmental variables. These variables can be pased to the Docker `run` command using the `--env=VARIABLE=value` switch or loaded from a file using the `--env-file=my_env_file.env` switch. Avaliable variables are:


| Variables         | Default           |   Description                     |
|-------------------|------------------:|-----------------------------------|
| MAD_HOST          | 0.0.0.0           | hostname/ip address               |
| MAD_PORT          | 4040              | HTTP port                         |
| MAD_HTTPS_PORT    | 0                 | HTTPS port (0 = disabled)         |
| MAD_CONTEXT_PATH  | /                 | The last part of the Madsonic URL |
| MAD_INIT_MEM      | 192               | Init Java heap size in megabytes  |
| MAD_MAX_MEM       | 384               | Max Java heap size in megabytes   |
| MAD_TIME_ZONE     | Europe/Amsterdam  | Timezone                          |
| MAD_UID           | 1000              | Madsonic UID                      |
| MAD_GID           | 1000              | Madsonic GID                      |
 
If you are mounting a music directory from your host machine and you want Madsonic to be able to change album art and tags, MAD_UID and MAD_GID should match the UID and GID of the music directory on the host machine.

So if you music collection is store at `/home/foo/music` and the uid of foo is `1020` and the gid `1035` you should start Madsonic with:

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
    --volumes-from=data-madsonic \
    --volume=/my_music_dir:/var/media/artists \
    --volume=/etc/timezone:/etc/timezone:ro \
    --publish=49155:4040 \
    --name madsonic \
    --restart=always \
    --detach=true \
    bremme/madsonic
```