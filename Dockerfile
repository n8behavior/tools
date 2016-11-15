FROM ubuntu

ADD linode-puterstructions_*_all.tar.gz .

ENTRYPOINT ["/usr/local/bin/linode-puterstructions"]
