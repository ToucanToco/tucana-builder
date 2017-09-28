FROM ubuntu:16.04


USER root


SHELL ["/bin/bash", "-c"]


###############################################################################
#			Pre Dependencies Installlation
###############################################################################


ENV UBUNTU_KEYSERVER        keyserver.ubuntu.com

ENV NODE_KEY                68576280
ENV NODE_MAIN_VERSION       6

ENV YARN_VERSION            0.27.5
ENV YARN_MAIN_DIR           /opt/yarn
ENV YARN_BIN                ${YARN_MAIN_DIR}/node_modules/yarn/bin/yarn

ENV PANDOC_VERSION          1.19.2.1
ENV PANDOC_URL              https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-amd64.deb

ENV TOUCAN_BUILD_ENV        /etc/toucan_build_env

###############################################################################
#			Pre Dependencies Installlation
###############################################################################


RUN	apt-key adv \
		--recv-keys \
		--keyserver ${UBUNTU_KEYSERVER} \
		${NODE_KEY}

RUN	apt-get update \
	&& apt-get -y upgrade \
	&& apt-get install -y \
		apt-transport-https \
		wget

RUN	echo "deb https://deb.nodesource.com/node_${NODE_MAIN_VERSION}.x xenial main" >> /etc/apt/sources.list.d/nodesource.list \
	&& echo "deb-src https://deb.nodesource.com/node_${NODE_MAIN_VERSION}.x xenial main" >> /etc/apt/sources.list.d/nodesource.list


###############################################################################
#			Dependencies Installlation
###############################################################################


RUN 	apt-get update \
	&& apt-get -y upgrade \
	&& apt-get install -y \
		git \
		build-essential \
		python \
		python-dev \
		python-setuptools \
		nodejs=${NODE_MAIN_VERSION}.*

RUN	easy_install pip \
	&& pip install virtualenv

RUN	npm install \
		--prefix=/opt/yarn \
		yarn@${YARN_VERSION}

RUN	wget 	${PANDOC_URL} \
		-O /tmp/pandoc.deb \
	&& dpkg -i /tmp/pandoc.deb \
	&& rm /tmp/pandoc.deb


###############################################################################
#                       Post Installlation
###############################################################################


RUN	echo "YARN_BIN=${YARN_BIN}" >> ${TOUCAN_BUILD_ENV}
