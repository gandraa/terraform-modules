#!/bin/bash -vxe
set -o xtrace

echo "Installing utils"
yum -y install wget

echo "Downloading Active Gate"
wget -O /tmp/Dynatrace-ActiveGate-Linux-x86.sh "https://${dynatrace_url}/api/v1/deployment/installer/gateway/unix/latest?arch=x86&flavor=default" --header="Authorization: Api-Token ${api_token}"

echo "Verifying Signature"
wget -O /tmp/dt-root.cert.pem https://ca.dynatrace.com/dt-root.cert.pem ; ( echo 'Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha-256"; boundary="--SIGNED-INSTALLER"'; echo ; echo ; echo '----SIGNED-INSTALLER' ; cat /tmp/Dynatrace-ActiveGate-Linux-x86.sh ) | openssl cms -verify -CAfile /tmp/dt-root.cert.pem > /dev/null

echo "Running the installer with root rights"
/bin/bash /tmp/Dynatrace-ActiveGate-Linux-x86.sh --set-network-zone=${dynatrace_network_zone} --set-group=${dynatrace_active_gate_group}

echo "Removing tmp Directory"
rm -r /tmp

echo "Restarting Dynatracegateway Service"
systemctl restart dynatracegateway