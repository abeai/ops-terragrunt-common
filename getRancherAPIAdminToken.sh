export VAULT_ADDR=$1

vault kv get -field=rancher_admin_token shared-data/abe-stage 
