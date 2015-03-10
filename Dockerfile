###############################################################################
#
# Madsonic
#
###############################################################################

FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# install base debian
RUN apt-get update && \
	apt-get install -y \
		supervisor \
		nano

# fix language
RUN apt-get update && \
	apt-get install locales && \
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen

ENV LC_ALL=en_US.UTF-8 \
	LANG=en_US:en \
	LANGUAGE=en_US.UTF-8

# install java ################################################################
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/jre

RUN apt-get update && \
	apt-get install -y \
	openjdk-7-jre-headless \
	default-jre-headless

# install dependencies ########################################################
RUN apt-get update && \
	apt-get install -y \
	wget \
	unzip

# install madsonic ############################################################
ENV MAD_VERSION=5.2 \
	MAD_VERSION_SUB=5420 \
	MAD_VERSION_DATE=20141214

RUN wget -P /tmp/ http://madsonic.org/download/"$MAD_VERSION"/"$MAD_VERSION_DATE"_madsonic-"$MAD_VERSION"."$MAD_VERSION_SUB".deb 
RUN dpkg -i /tmp/"$MAD_VERSION_DATE"_madsonic-"$MAD_VERSION"."$MAD_VERSION_SUB".deb && \
	rm /tmp/"$MAD_VERSION_DATE"_madsonic-"$MAD_VERSION"."$MAD_VERSION_SUB".deb

RUN wget -P /root/ http://www.madsonic.org/download/transcode/"$MAD_VERSION_DATE"_madsonic-transcode_latest_x64.zip
RUN unzip -j -o /root/"$MAD_VERSION_DATE"_madsonic-transcode_latest_x64.zip linux/* -d /root/transcode && \
	rm "/root/$MAD_VERSION_DATE"_madsonic-transcode_latest_x64.zip && \
	rm /root/transcode/*.txt

COPY ./COPY/supervisord.conf  	/etc/supervisor/supervisord.conf
COPY ./COPY/madsonic.conf 		/etc/supervisor/conf.d/madsonic.conf
COPY ./COPY/bootstrap.conf 		/etc/supervisor/conf.d/bootstrap.conf
COPY ./COPY/madsonic.sh			/usr/local/bin/madsonic.sh
COPY ./COPY/bootstrap.sh		/usr/local/bin/bootstrap.sh
RUN chmod +x /usr/local/bin/*.sh

# madsonic host name / ip address (0.0.0.0)
# madsonic http port (4050)
# madsonic https port (0), 0 is disabled
# madsonic context path, i.e. the last part of the Madsonic URL (/)
# madsonic initial memory (192)
# madsonic memory limit, java heap size (384)
ENV MAD_HOST=0.0.0.0 \
	MAD_PORT=4040 \
	MAD_HTTPS_PORT=0 \
	MAD_CONTEXT_PATH=/ \
	MAD_INIT_MEM=192 \
	MAD_MAX_MEM=384 \
	MAD_TIME_ZONE=Europe/Amsterdam \
	MAD_UID=1000 \
	MAD_GID=1000

# create user and group for madsonic
RUN addgroup --gid $MAD_GID madsonic && \
	adduser --system --gid $MAD_GID --uid $MAD_UID --gecos "Madsonic" --disabled-login madsonic && \
	adduser madsonic audio

# music directory
# VOLUME /var/media/artists

#EXPOSE 4040
#EXPOSE 4050

# run supervisord
CMD ["/usr/bin/supervisord"]