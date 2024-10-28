FROM debian:bookworm
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -qq -y hylafax-client
# Hack hylafax post inst runs fax modem if we don't do this
RUN mkdir -p /etc/hylafax
ADD hylafax-config.tar /
RUN apt-get install -qq -y hylafax-server
COPY pamd_hylafax /etc/pam.d/hylafax
# RUN apt-get install -qq -y hylafax-server
RUN apt-get install -y sudo gnupg2 wget lsb-release
