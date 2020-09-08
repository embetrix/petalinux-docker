# Docker for petalinux Build
Docker Image with Ubuntu 16.04 and all dependencies to perform a petalinux Build

## Generate Docker Image

        sudo docker build --rm=true --tag petalinux-docker .
        
## Run Docker Image

        sudo docker run --rm --privileged -ti -h docker petalinux-docker
