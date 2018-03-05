#!/bin/bash

# rename the if
ip netns exec ns0 ip link set veth2 down 
ip netns exec ns0 ip link set veth2 name eth0
ip netns exec ns0 ip link set eth0 up 

# attach the other end to a bridge 
ip link set  veth1  master br1
