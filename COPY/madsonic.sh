#!/bin/bash

###################################################################################
# Shell script for starting Madsonic.  See http://madsonic.org.
###################################################################################

# only part of the original shell script is user (see /usr/bin/madsonic for the full script)

LANG=en_US.UTF-8

# default madsonic settings
MADSONIC_HOME=/var/madsonic/
MADSONIC_HOST=0.0.0.0
MADSONIC_PORT=4040
MADSONIC_HTTPS_PORT=0
MADSONIC_CONTEXT_PATH=/
MADSONIC_INIT_MEMORY=192
MADSONIC_MAX_MEMORY=384
MADSONIC_PIDFILE=
MADSONIC_DEFAULT_MUSIC_FOLDER=/var/media/artists
MADSONIC_DEFAULT_UPLOAD_FOLDER=/var/media/incoming
MADSONIC_DEFAULT_PODCAST_FOLDER=/var/media/podcast
MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER=/var/media/playlists/import
MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER=/var/media/playlists/export
MADSONIC_DEFAULT_PLAYLIST_BACKUP_FOLDER=/var/media/playlists/backup
MADSONIC_DEFAULT_TIMEZONE=Europe/Amsterdam
MADSONIC_GZIP=true

# import docker settings
MADSONIC_HOME=${MAD_HOME:-$MADSONIC_HOME}
MADSONIC_HOST=${MAD_HOST:-$MADSONIC_HOST}
MADSONIC_PORT=${MAD_PORT:-$MADSONIC_PORT}
MADSONIC_HTTPS_PORT=${MAD_HTTPS_PORT:-$MADSONIC_HTTPS_PORT}
MADSONIC_CONTEXT_PATH=${MAD_CONTEXT_PATH:-$MADSONIC_CONTEXT_PATH}
MADSONIC_INIT_MEMORY=${MAD_INIT_MEM:-$MADSONIC_INIT_MEMORY}
MADSONIC_MAX_MEMORY=${MAD_MAX_MEM:-$MADSONIC_MAX_MEMORY}
MADSONIC_DEFAULT_TIMEZONE=${MAD_TIME_ZONE:-$MADSONIC_DEFAULT_TIMEZONE}

# go to madsonic jar directory
cd /usr/share/madsonic

# execute madsonic (exec: replace the shell with a given program (executing it, not as new process))
exec /usr/bin/java -Xms${MADSONIC_INIT_MEMORY}m -Xmx${MADSONIC_MAX_MEMORY}m \
  -Dmadsonic.home=${MADSONIC_HOME} \
  -Dmadsonic.host=${MADSONIC_HOST} \
  -Dmadsonic.port=${MADSONIC_PORT} \
  -Dmadsonic.httpsPort=${MADSONIC_HTTPS_PORT} \
  -Dmadsonic.contextPath=${MADSONIC_CONTEXT_PATH} \
  -Dmadsonic.defaultMusicFolder=${MADSONIC_DEFAULT_MUSIC_FOLDER} \
  -Dmadsonic.defaultUploadFolder=${MADSONIC_DEFAULT_UPLOAD_FOLDER} \
  -Dmadsonic.defaultPodcastFolder=${MADSONIC_DEFAULT_PODCAST_FOLDER} \
  -Dmadsonic.defaultPlaylistImportFolder=${MADSONIC_DEFAULT_PLAYLIST_IMPORT_FOLDER} \
  -Dmadsonic.defaultPlaylistExportFolder=${MADSONIC_DEFAULT_PLAYLIST_EXPORT_FOLDER} \
  -Dmadsonic.defaultPlaylistBackupFolder=${MADSONIC_DEFAULT_PLAYLIST_BACKUP_FOLDER} \
  -Duser.timezone=${MADSONIC_DEFAULT_TIMEZONE} \
  -Dmadsonic.gzip=${MADSONIC_GZIP} \
  -Djava.awt.headless=true \
  -verbose:gc \
  -jar madsonic-booter.jar