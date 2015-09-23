#!/bin/bash
puppet apply --debug --show_diff --noop --modulepath=./modules:./site --hiera_config=hiera.yaml ./manifests/site.pp
