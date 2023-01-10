#!/usr/bin/env bash

aws ec2 describe-instances | jq -f "$(dirname "$0")"/running-instances.jq
