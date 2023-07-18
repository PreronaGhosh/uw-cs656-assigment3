
# CS 656 - A3 Part-A




## Description of add-flow commands in ovs_connect_h0h1.sh

The first add-flow command is as follows:

```bash
  in_port=1,ip,nw_src=10.0.0.2,nw_dst=10.0.1.2,actions=mod_dl_src:0A:00:0A:01:00:02,mod_dl_dst:0A:00:0A:FE:00:02,output=2
```

The above command adds flow to switch `s0` and the breakdown is as follows:

- `in_port` : packet arrived at ingress port 1 
- `ip` : matches the IP protocol
- `nw_src` : matches the source IP address of the packet. For s0, 10.0.0.2 refers that packet has been sent by h0
- `nw_dst` : matches the source IP address of the packet. For s0, 10.0.1.2 indicates that packet has to be sent to h1

The following `actions` are applied when a packet's header values match with the above entry:
- `mod_dl_src`: Modifies the MAC address of source to `0A:00:0A:01:00:02`, which in the given network refers to `port 2`
- `mod_dl_dst` : Modifies the MAC address of the destination to `0A:00:0A:FE:00:02`, which in the given network refers to `s1 port 2`, so that the current packet goes there
- `output` : This refers to s0's output port number, which is 2 in the current network.


To summarize the add-flow command, if a packet arrives at `port 1` from source IP address `10.0.0.2` and is headed for destination IP address `10.0.1.2`, apply the actions of modifying source MAC address in the packet to s0's input port MAC address (`0A:00:0A:01:00:02`) and also modifying the destination MAC address to the next router's port MAC address (`0A:00:0A:FE:00:02`). The send the packet out on s0's output `port 2`.  

