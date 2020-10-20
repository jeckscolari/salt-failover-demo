#!/bin/bash
yum update -y
yum install -y https://repo.saltstack.com/py3/amazon/salt-py3-amzn2-repo-latest.amzn2.noarch.rpm
yum clean expire-cache
yum install -y salt-minion
cat << \EOF > /etc/salt/minion
master:
%{ for s in salt_masters ~}
  - ${s}
%{ endfor ~}
EOF
yum install -y httpd
systemctl enable httpd



