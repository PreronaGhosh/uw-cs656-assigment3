#!/usr/bin/env bash 

# Sets bridge s1 to use OpenFlow 1.3
ovs-vsctl set bridge s1 protocols=OpenFlow13 

# Sets bridge s2 to use OpenFlow 1.3
ovs-vsctl set bridge s2 protocols=OpenFlow13

# Sets bridge s3 to use OpenFlow 1.3
ovs-vsctl set bridge s3 protocols=OpenFlow13

# Sets bridge r1 to use OpenFlow 1.3
ovs-vsctl set bridge r1 protocols=OpenFlow13

# Sets bridge r2 to use OpenFlow 1.3
ovs-vsctl set bridge r2 protocols=OpenFlow13

# Print the protocols that each switch supports
for switch in s1 s2 s3 r1 r2;
do
    protos=$(ovs-vsctl get bridge $switch protocols)
    echo "Switch $switch supports $protos"
done

# Avoid having to write "-O OpenFlow13" before all of your ovs-ofctl commands.
ofctl='ovs-ofctl -O OpenFlow13'


# ----------------------- Alice to Bob -------------------- #

# OVS rules for S1
$ofctl add-flow s1 \
    ip,nw_dst=10.4.4.48,actions=mod_dl_src:0A:00:0A:01:00:02,mod_dl_dst:0A:00:04:01:00:01,output:2

# OVS rules for R1
$ofctl add-flow r1 \
    dl_src=0A:00:0A:01:00:02,actions=mod_dl_src:0A:00:0E:FE:00:02,mod_dl_dst:0A:00:0A:FE:00:02,output:2

# OVS rules for S2
$ofctl add-flow s2 \
    ip,nw_src=10.1.1.17,nw_dst=10.4.4.48,actions=mod_dl_src:0A:00:01:01:00:01,mod_dl_dst:0A:00:01:02:00:00,output:1


# ----------------------- Bob to Alice -------------------- #

# OVS rules for S2
$ofctl add-flow s2 \
    ip,nw_src=10.4.4.48,nw_dst=10.1.1.17,actions=mod_dl_src:0A:00:0A:FE:00:02,mod_dl_dst:0A:00:10:FE:00:02,output:2

# OVS rules for R1
$ofctl add-flow r1 \
    dl_src=0A:00:0A:FE:00:02,actions=mod_dl_src:0A:00:04:01:00:01,mod_dl_dst:0A:00:0A:01:00:02,output:1

# OVS rules for S1
$ofctl add-flow s1 \
    ip,nw_dst=10.1.1.17,actions=mod_dl_src:0A:00:00:01:00:01,mod_dl_dst:0A:00:00:02:00:00,output:1


# ----------------------- Bob to Carol -------------------- #

# OVS rules for S2
$ofctl add-flow s2 \
    ip,nw_dst=10.6.6.69,dl_src=0A:00:01:02:00:00,actions=mod_dl_src:0A:00:0C:01:00:03,mod_dl_dst:0A:00:05:01:00:01,output:3

# OVS rules for R2
$ofctl add-flow r2 \
    dl_src=0A:00:0C:01:00:03,actions=mod_dl_src:0A:00:10:FE:00:02,mod_dl_dst:0A:00:0B:FE:00:02,output:2

# OVS rules for S3
$ofctl add-flow s3 \
    ip,nw_dst=10.6.6.69,dl_src=0A:00:10:FE:00:02,actions=mod_dl_src:0A:00:02:01:00:01,mod_dl_dst:0A:00:02:02:00:00,output:1


# ----------------------- Carol to Bob -------------------- #

# OVS rules for S3
$ofctl add-flow s3 \
    ip,nw_dst=10.4.4.48,dl_src=0A:00:02:02:00:00,actions=mod_dl_src:0A:00:0B:FE:00:02,mod_dl_dst:0A:00:10:FE:00:02,output:2

# OVS rules for R2
$ofctl add-flow r2 \
    dl_src=0A:00:0B:FE:00:02,actions=mod_dl_src:0A:00:05:01:00:01,mod_dl_dst:0A:00:0C:01:00:03,output:1

# OVS rules for S2
$ofctl add-flow s2 \
    ip,nw_src=10.6.6.69,dl_src=0A:00:05:01:00:01,actions=mod_dl_src:0A:00:01:01:00:01,mod_dl_dst:0A:00:01:02:00:00,output:1


	
# Print the flows installed in each switch
for switch in s1 s2 s3 r1 r2;
do
    echo "Flows installed in $switch:"
    $ofctl dump-flows $switch
    echo ""
done
