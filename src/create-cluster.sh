#!/bin/bash

DOCKER_MACHINE="$(which docker-machine)"
DOCKER_ENGINE="$(which docker)"
NODES=6
MGRS=3
NODE=aws-dockerhost-

echo "Create nodes"
for n in $(seq 1 $NODES)
do
  $DOCKER_MACHINE create \
      --driver 'amazonec2' \
      --engine-install-url https://test.docker.com \
      $NODE$n &
done
wait $(jobs -p)

echo "Initialize the cluster"
eval "$($DOCKER_MACHINE env --shell bash ${NODE}1)"
$DOCKER_ENGINE swarm init --auto-accept manager

echo "Add managers"
for m in $(seq 2 $MGRS)
do
  eval "$($DOCKER_MACHINE env --shell bash $NODE$m)"
  echo "Adding manager: $m of $MGRS"
  $DOCKER_ENGINE swarm join --manager $($DOCKER_MACHINE ip ${NODE}1):2377 
done
wait $(jobs -p)

echo "Add workers"
eval "$($DOCKER_MACHINE env --shell bash ${NODE}1)"
$DOCKER_ENGINE swarm update --auto-accept worker
for w in $(seq $(($MGRS+1)) $NODES)
do
  eval "$($DOCKER_MACHINE env --shell bash $NODE$w)"
  echo "Adding worker: $w of $(($NODES - $MGRS))"
  $DOCKER_ENGINE swarm join $($DOCKER_MACHINE ip "${NODE}1"):2377 
done
wait $(jobs -p)

eval "$($DOCKER_MACHINE env --shell bash ${NODE}1)"
$DOCKER_ENGINE node ls
echo "All done!!!"
