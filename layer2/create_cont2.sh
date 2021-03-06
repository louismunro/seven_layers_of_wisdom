#!/bin/bash

ip netns add ns1
ip link add dev veth3 type veth peer name veth4
ip link set veth3 up 
ip link set veth4 up 
ip link set veth4 netns ns1

ip netns exec ns1 ip link set veth4 down 
ip netns exec ns1 ip link set veth4 name eth0
ip netns exec ns1 ip link set eth0 up 

ip link set  veth3  master br1
