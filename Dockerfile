##
# NOTE: Current Dockerfile is only used to generate the hook docker image and assumes that the hook archive is already inside the "out" directory
###
FROM ubuntu:22.04

WORKDIR home

COPY out .

RUN mkdir /data-new

RUN find ./ -name "*.tar.gz" -exec bash -c 'mv $1 /data-new' _ {} \;

RUN apt-get update && apt-get install -y rsync

CMD if [ -d /data-new ]; then echo 'Updating the hook'; rm -Rf /data/*; rsync -rtv /data-new/ /data/ ;tar -xvf /data/*.tar.gz -C /data; rm -Rf /data-new; fi