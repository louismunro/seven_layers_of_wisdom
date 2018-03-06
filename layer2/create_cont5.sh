#!/bin/bash

ip netns add ns4
ip link add dev veth9 type veth peer name veth10
ip link set veth9 up 
ip link set veth10 up 
ip link set veth10 netns ns4

ip netns exec ns4 ip link set veth10 down 
ip netns exec ns4 ip link set veth10 name eth0
ip netns exec ns4 ip link set eth0 up 
ip netns exec ns4 ip addr add 10.101.0.3/24 dev eth0

ip link set  veth9  master br2
