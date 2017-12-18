#!/bin/bash

set -e

vagrant up
vagrant ssh --command /vagrant/debian/prereqs.sh debian http://10.1.1.3:3142

