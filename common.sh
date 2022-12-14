curl -s https://raw.githubusercontent.com/abeai/ops-terragrunt-common/main/common.hcl > .terragrunt/common.hcl
curl -s https://raw.githubusercontent.com/abeai/ops-terragrunt-common/main/getRancherAPIAdminToken.sh > .terragrunt/getRancherAPIAdminToken.sh
curl -s https://raw.githubusercontent.com/abeai/ops-terragrunt-common/main/getRancherAPIUrl.sh > .terragrunt/getRancherAPIUrl.sh
curl -s https://raw.githubusercontent.com/abeai/ops-terragrunt-common/main/getKubeConfig.sh > .terragrunt/getKubeConfig.sh
curl -s https://raw.githubusercontent.com/abeai/ops-terragrunt-common/main/.gitignore > .gitignore

echo ".terragrunt/common.hcl"
