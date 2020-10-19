#!/bin/bash
yum update -y
yum install -y https://repo.saltstack.com/py3/amazon/salt-py3-amzn2-repo-latest.amzn2.noarch.rpm
yum clean expire-cache
yum install -y salt-master