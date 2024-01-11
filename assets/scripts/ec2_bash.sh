Content-Type: multipart/mixed; boundary="===============3531250125703775169=="
MIME-Version: 1.0

--===============3531250125703775169==
Content-Type: text/x-shellscript; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="user_data_script.sh"

#!/bin/bash -vxe
set -o xtrace

echo "Calculate the number of MAX_PODS based on cni_version and set it on kubelet"
%{ if cni_version != "" }
MAX_PODS=$(/etc/eks/max-pods-calculator.sh --instance-type-from-imds --cni-version ${cni_version} --cni-custom-networking-enabled)
/etc/eks/bootstrap.sh ${eks_cluster_name} --use-max-pods false --kubelet-extra-args "--max-pods=$MAX_PODS"
%{ endif }
--===============3531250125703775169==--