#!/bin/bash 

# create a pair of veth devices and set them "up"
ip link add dev veth_br1 type veth peer name veth_br2
ip link set veth_br1 up
ip link set veth_br2 up

# connect the veth if into the bridges
ip link set veth_br1 master br1
ip link set veth_br2 master br2
