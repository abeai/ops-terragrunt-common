export VAULT_ADDR=$1

vault kv get -field=rancher_url shared-data/$2 || echo "" 
