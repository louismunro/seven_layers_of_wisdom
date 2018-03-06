#!/bin/bash

ip link add name br2 type bridge
ip link set br2 up
ip link set dev br2 type bridge vlan_filtering 1
