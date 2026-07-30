#!/bin/bash

OldURL="example.xyz"
NewURL="example.xyz"

sed -i.bak "s/$OldURL/$NewURL/g" /etc/tacticalagent
sed -i.bak "s/$OldURL/$NewURL/" /opt/tacticalmesh/meshagent.msh

systemctl restart meshagent
systemctl restart tacticalagent
