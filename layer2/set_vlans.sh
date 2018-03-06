#!/bin/bash


bridge vlan add vid  99 dev veth1 pvid egress untagged
bridge vlan del vid 1 dev veth1

bridge vlan add vid  99 dev veth3 pvid egress untagged
bridge vlan del vid 1 dev veth3

bridge vlan add vid  99 dev veth5 pvid egress untagged
bridge vlan del vid 1 dev veth5

bridge vlan add vid  101 dev veth7 pvid egress untagged
bridge vlan del vid 1 dev veth7

bridge vlan add vid  101 dev veth9 pvid egress untagged
bridge vlan del vid 1 dev veth9
