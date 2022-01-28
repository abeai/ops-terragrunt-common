terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["echo", "===========================\nYOU ARE USING THE FOLLOWING WORKSPACE:\n\n${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}\n\nENSURE THIS IS CORRECT!\n===========================\n\n"]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["read", "-p \"Press enter to continue...\""]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["aws-mfa", "--profile", lookup(lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "aws", {}), "profile")]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["bash", "-c", "export VAULT_ADDR=\"${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}\"; vault token lookup || vault login --method=github"]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["rm", "./.terragrunt/common.hcl"]
    run_on_error = true
  }
}

inputs = {
  RANCHER_API_URL = "${run_cmd("--terragrunt-quiet", "sh", "./.terragrunt/getRancherAPIUrl.sh", "${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}")}"
  RANCHER_TOKEN_KEY = "${run_cmd("--terragrunt-quiet", "sh", "./.terragrunt/getRancherAPIAdminToken.sh", "${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}")}"
}
