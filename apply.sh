#!/bin/bash
puppet apply --modulepath=./modules:./site --hiera_config=hiera.yaml ./manifests/site.pp
