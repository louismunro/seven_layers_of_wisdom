# seven_layers_of_wisdom
A repository for playing with the (seven) layers of the OSI model.


# Layer 2 exercises

Prerequisites
Install the following packages (for debian): 
tcpdump vlan bridge-utils net-tools ethtool arping

Run create_br1.sh
This will set up a bridge called br1.

Run ip link show to see it.

Run create_netns.sh
It will create a network namespace called ns1.

Run ip netns list to see it.
Run sudo ip netns exec ns1 bash to enter it.
Once inside, run ip a to see the available interfaces.
Notice how there is only an lo interface.
Exit the namespace (by exiting the shell).

Run create_veth_pair.sh
It will create a pair of veth devices called veth1 and veth2.
Again, run ip link show to display them.
Note how each one is the mirror image of the other.

Now run move_veth_ns1.sh to move one end of the veth pair inside the ns1 namespace. 
Reenter the namespace and run ip a again.

From the main namespace, run rename_veth_inside_ns.sh
It will run a command inside the ns1 namespace and rename veth2 to eth0.
In addition it will attache veth1 to br1. 
Look at `ip a` both inside an out of ns1 to see the renamed interface as well as how veth3 now has a master.

Learning ARP

Enter container one.
Run `arp -an` to see the cache.

Run `arping -c3 $IP_OF_OTHER_CONTAINER`
Check tcpdump on the bridge as it's happening.
Check the arp cache on the source.
Check the arp cache on the destination.
Notice how it's learned on both ends.

Use ip monitor neighbour inside a container to see the arp cache being updated.
 

Demonstrate bridge learning

Disable bridge learning on br1 by running
`brctl setageing br1 0`
or alternatively 
`bridge link set dev vethX learning off` to set if off on a per veth basis.

Then arping containers from one another and snoop with tcpdump in a third.
Container 1: `arping -c3 $IP`

Note how you can see all frames going back and forth.
Remember that arpings are not IP packets.
They have no source nor destination IP.
Compare them with an ICMP ping.

Reenable learning on the bridge with a maximum age of 30 seconds (the default is 300):
`brctl setageing br1 30`

Try the arping again.
See how You can now only see the broadcasts.

Run `bridge monitor fdb` to see learning in real time.
arping a container from another.
Two new entries should appear, one for source and one for destination.
Remember that the bridge only learns the source of the ethernet frame, so what we are seeing is request and reply.
If you keep the monitoring session running long enough you will see the bridge delete the fdb entries as they age: 
`Deleted b2:8b:4e:c7:79:0d dev veth5 vlan 101 master br1 stale`

You can also use `brctl showmacs br1` to see a table that displays the ageing timer for each MAC.

Learning about VLANs
 
Understand collisions.
Understand broadcast domains.

Enable VLAN awareness on the bridge by running 
`ip link set dev br1 type bridge vlan_filtering 1`

Display the VLANs: 
`bridge vlan show `


Set a PVID on a port leading to a container: 
`bridge vlan add vid  99 dev veth1 pvid egress untagged`
`bridge vlan del vid 1 dev veth1`
We remove VLAN 1 so that the port cannot forward more than one untagged VLAN.

Run tcpdump inside it and capture incoming ethernet frames.
Run arping in another container and notice how the broadcast frames are not seen inside the container in a different VLAN.


Create br2 with the `create_br2.sh` script. 
Create two new containers with create_cont4.sh and create_cont5.sh.
This will also give them ips 10.101.0.2/24 and 10.101.0.3/24. 
Note how these are not part of the 10.99.0.0/24 subnet.

Run an `arping -ieth0 -c5 10.99.0.4` from ns0. 
At the same time, run `tcpdump -ieth0 -etnnl arp` from ns4. 
Notice how you see the broadcasts for the 10.99.0.0/24 subnet, even though the ip of ns4 is in the 10.101.0.024 subnet.
Why? 

Run the `set_vlans.sh` script.
It will place the containers in vlans 99 and 101.

Swap the bridges for ns2 and ns4 by running: 

`ip link set dev veth5 master br2`
`ip link set dev veth9 master br1`

Can you still ping either container from another in the same subnet? 
Why?

How would you fix that? 

Additional exercises

fdb poisoning (duplicate MAC)

Copy the MAC of one container to another's eth0 by running the following:
`ip link dev eth0 $COPIED_MAC`

Run `arping -ieth0 $SOME_IP` and let it run.

From another container, try pinging the IP of the container whose MAC was cloned.
What happens? Why? 

Check out `bridge monitor fdb` on br1.
