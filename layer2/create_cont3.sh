#!/bin/bash

ip netns add ns3
ip link add dev veth5 type veth peer name veth6
ip link set veth5 up 
ip link set veth6 up 
ip link set veth6 netns ns3

ip netns exec ns3 ip link set veth6 down 
ip netns exec ns3 ip link set veth6 name eth0
ip netns exec ns3 ip link set eth0 up 

ip link set  veth5  master br1
