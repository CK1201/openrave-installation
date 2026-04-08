# openrave-installation

Bash scripts to install OpenRAVE from source. 

Supported distros:
* Ubuntu 14.04
* Ubuntu 16.04
* Ubuntu 18.04
* Ubuntu 20.04
* Ubuntu 24.04

## Travis - Continuous Integration

[![Build Status](https://travis-ci.org/crigroup/openrave-installation.svg?branch=master)](https://travis-ci.org/crigroup/openrave-installation)


## Installation
Run the scripts in the following order:
```bash
./install-dependencies.sh
./install-osg.sh
./install-fcl.sh
./install-openrave.sh
```

For Ubuntu 24.04, the scripts install OpenRAVE with Python 3 bindings and use the
system OpenSceneGraph package instead of building the older pinned OSG release
from source.
