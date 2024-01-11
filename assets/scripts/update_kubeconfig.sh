#!/bin/bash

set -e

CLUSTER=$1
ACCOUNT_NAME=$2

if [ -z "$CLUSTER" ]; then
    echo 'No EKS cluster defined'
    exit 1
fi

if [ -z "$ACCOUNT_NAME" ]; then
    echo 'No AWS account defined'
    exit 1
fi

if [ -z "${KUBECONFIG}" ]; then
  echo 'No Kubeconfig defined'
fi


echo "EKS is activating configuration for $CLUSTER in $ACCOUNT_NAME environment..."

aws eks update-kubeconfig --name=$CLUSTER --kubeconfig=$KUBECONFIG --alias="$CLUSTER-$ACCOUNT_NAME" 2>/dev/null
chmod 700 $KUBECONFIG