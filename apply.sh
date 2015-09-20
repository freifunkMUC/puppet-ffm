#!/bin/bash

puppet apply                          \
  --modulepath=$PWD/site:$PWD/modules:$PWD/legacy \
  --hiera_config=$PWD/hiera.yaml      \
  $PWD/site.pp
