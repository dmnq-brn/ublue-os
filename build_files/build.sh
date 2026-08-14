#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install required packages
/ctx/build_files/install-packages.sh

### remove 
/ctx/build_files/remove-packages.sh

#### Example for enabling a System Unit File

systemctl enable podman.socket
