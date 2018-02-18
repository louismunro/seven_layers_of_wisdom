# seven_layers_of_wisdom
A repository for playing with the (seven) layers of the OSI model.


# exercises

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


Learning ARP


