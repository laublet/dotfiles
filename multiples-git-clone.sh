#!/bin/sh

readarray array <<< $( cat "$@" )

mkdir -p ~/dev && cd ~/dev

for element in ${array[@]}
do
  echo "clonning $element"
  git clone $element
done
