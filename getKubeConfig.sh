export VAULT_ADDR=$1

mkdir -p ./kubeconfig
vault kv get -field=kube_config shared-data/kubernetes/$2 > ./kubeconfig/kubeconfig_$2
