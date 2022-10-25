# etho-flux

## Build
With docker installed you can build an image with:

make build

## Push image to docker
To push to image to docker:

  sudo docker login

Tag the image properly for deploy:

  sudo docker tag etho_ipfs_node ethoprotocol/etho_ipfs_node:latest
  
To push the image:

  sudo docker push ethoprotocol/etho_ipfs_node
