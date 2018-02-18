#!/bin/bash 

ip link add dev veth1 type veth peer name veth2
ip link set veth1 up 
ip link set veth2 up 
