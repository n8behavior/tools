#!/bin/bash

DOCKER_MACHINE=docker-machine
DOCKER_ENGINE=docker
NODES=9
MGRS=3
NODE=docker-host-$$-

case $FLAGS_driver in
*)
  MACHINE_ARGS="--driver amazonec2"
  ;;
esac

echo "Create nodes"
for n in $(seq 1 $NODES)
do
  $DOCKER_MACHINE create \
      $MACHINE_ARGS \
      $NODE$n  &
  sleep 10
done
wait $(jobs -p)

echo "Initialize the cluster"
eval "$($DOCKER_MACHINE env --shell bash ${NODE}1)"
$DOCKER_ENGINE swarm init --secret=foo --auto-accept manager

echo "Add managers"
for m in $(seq 2 $MGRS)
do
  eval "$($DOCKER_MACHINE env --shell bash $NODE$m)"
  echo "Adding node: $m of $NODES"
  $DOCKER_ENGINE swarm join --secret=foo --manager $($DOCKER_MACHINE ip ${NODE}1):2377 
  sleep 10
done
wait $(jobs -p)

echo "Add workers"
eval "$($DOCKER_MACHINE env --shell bash ${NODE}1)"
$DOCKER_ENGINE swarm update --auto-accept worker
for w in $(seq $(($MGRS+1)) $NODES)
do
  eval "$($DOCKER_MACHINE env --shell bash $NODE$w)"
  echo "Adding node: $w of $NODES"
  $DOCKER_ENGINE swarm join --secret=foo $($DOCKER_MACHINE ip "${NODE}1"):2377 
  sleep 10
done
wait $(jobs -p)

eval "$($DOCKER_MACHINE env --shell bash ${NODE}1)"
$DOCKER_ENGINE node ls
echo "All done!!!"
