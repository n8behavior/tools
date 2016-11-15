#!/bin/bash

NODES=6
MGRS=3

echo "Create nodes"
for n in $(seq 1 $NODES)
do
  docker-machine create -d hyperv --hyperv-virtual-switch=DockerExt node$n &
done
wait $(jobs -p)

echo "Initialize the cluster"
eval "$(docker-machine.exe env --shell bash node1)"
docker swarm init --auto-accept manager

echo "Add managers"
for m in $(seq 2 $MGRS)
do
  eval "$(docker-machine.exe env --shell bash node$m)"
  docker swarm join --manager $(docker-machine.exe ip node1):2377 &
done
wait $(jobs -p)

echo "Add workers"
eval "$(docker-machine.exe env --shell bash node1)"
docker swarm update --auto-accept worker
for w in $(seq $(($MGRS+1)) $NODES)
do
  eval "$(docker-machine.exe env --shell bash node$w)"
  docker swarm join $(docker-machine.exe ip node1):2377 &
done
wait $(jobs -p)

eval "$(docker-machine.exe env --shell bash node1)"
docker node ls
echo "All done!!!"
