#!/bin/bash

ip netns add ns3
ip link add dev veth7 type veth peer name veth8
ip link set veth7 up 
ip link set veth8 up 
ip link set veth8 netns ns3

ip netns exec ns3 ip link set veth8 down 
ip netns exec ns3 ip link set veth8 name eth0
ip netns exec ns3 ip link set eth0 up 
ip netns exec ns3 ip addr add 10.101.0.2/24 dev eth0

ip link set  veth7  master br2
