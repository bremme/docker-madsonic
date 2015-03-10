#!/bin/bash
# default home /var/madsonic
	# config
	# transcode
# default media /var/media
	# artists				(default music dir)
	# incoming				(default upload folder)
	# podcast				(default podcast folder)
	# playlists/import 		(default playlist import folder)
	# playlists/export		(default playlist export folder)
	# playlists/backup		(default playlist backup folder)

MAD_HOME=/var/madsonic

# if uid and or gid are not set, make 1000 (default first user on machine)
MAD_UID=${MAD_UID:-1000}
MAD_GID=${MAD_GID:-1000}

# change uid gid
usermod -u $MAD_UID madsonic
groupmod -g $MAD_GID madsonic
usermod -g $MAD_GID madsonic

# copy transcoders into volume (if mounted)
cp /root/transcode/* "$MAD_HOME"/transcode
# make sure transcode is executable
chmod -v +x "$MAD_HOME"/transcode/*

# chown permissions (exept music dir)
chown -R $MAD_UID:$MAD_GID "$MAD_HOME"
chown -R $MAD_UID:$MAD_GID /var/media/{incoming,podcast,playlist}

# wait 2 seconds for supervisord to get a succesfull run
sleep 2