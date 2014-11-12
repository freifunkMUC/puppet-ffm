#!/bin/bash
puppet apply --debug --show_diff --noop --modulepath=./modules --hiera_config=hiera.yaml site.pp
