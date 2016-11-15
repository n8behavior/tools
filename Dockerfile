FROM ubuntu

RUN apt-get update && apt-get install -y jq bash

ADD puterstructions-tools_*_all.tar.gz .

