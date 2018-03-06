#!/bin/bash
# This script recreates the environment as set up after the first set of exercises,
# i.e. one bridge (br1) and three namespaces with ips 

ip link add name br1 type bridge
ip link set br1 up

# add container 1
ip netns add ns0
ip link add dev veth1 type veth peer name veth2
ip link set veth1 up 
ip link set veth2 up 
ip link set veth2 netns ns0
ip netns exec ns0 ip link set veth2 down 
ip netns exec ns0 ip link set veth2 name eth0
ip netns exec ns0 ip link set eth0 up 
ip netns exec ns0 ip addr add 10.99.0.2/24 dev eth0
ip link set  veth1  master br1

# add container 2
ip netns add ns1
ip link add dev veth3 type veth peer name veth4
ip link set veth3 up 
ip link set veth4 up 
ip link set veth4 netns ns1
ip netns exec ns1 ip link set veth4 down 
ip netns exec ns1 ip link set veth4 name eth0
ip netns exec ns1 ip link set eth0 up 
ip netns exec ns1 ip addr add 10.99.0.3/24 dev eth0
ip link set  veth3  master br1

# add container 3
ip netns add ns2
ip link add dev veth5 type veth peer name veth6
ip link set veth5 up 
ip link set veth6 up 
ip link set veth6 netns ns2
ip netns exec ns2 ip link set veth6 down 
ip netns exec ns2 ip link set veth6 name eth0
ip netns exec ns2 ip link set eth0 up 
ip netns exec ns2 ip addr add 10.99.0.4/24 dev eth0
ip link set  veth5  master br1
