#!/bin/bash
enode=`bash /root/exec_cmd.sh 'admin.nodeInfo.enode'`
ip=`hostname -i`
enode=${enode/\[::\]/${ip}}
enode=`echo $enode | sed -e "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${ip}/g"`
echo $enode > /root/my_enode.enode
