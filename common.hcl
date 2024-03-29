terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["echo", "===========================\nYOU ARE USING THE FOLLOWING WORKSPACE:\n\n${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}\n\nENSURE THIS IS CORRECT!\n===========================\n\n"]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = get_env("DEVOPS_TOOLKIT", "false") == "false" ? ["read", "-p \"Press enter to continue...\""] : ["echo", "Continuing, because devops-toolkit"]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = split("/", get_parent_terragrunt_dir())[length(split("/", get_parent_terragrunt_dir())) - 2] == "ops-tf-gitlab" ? (get_env("TF_VAR_GITLAB_TOKEN", "false") == "false" ? ["echo", "TF_VAR_GITLAB_TOKEN env var required! Exiting..."] : ["echo", "TF_VAR_GITLAB_TOKEN found!"]) : ["echo", ""]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = split("/", get_parent_terragrunt_dir())[length(split("/", get_parent_terragrunt_dir())) - 2] == "ops-tf-gitlab" ? (get_env("TF_VAR_GITLAB_TOKEN", "false") == "false" ? ["exit", "1"] : ["echo", ""]) : ["echo", ""]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["aws-mfa", "--profile", lookup(lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "aws", jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json"))), "profile")]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["bash", "-c", "export VAULT_ADDR=\"${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}\"; vault token lookup || { vault login --method=github; echo \"EXITING.... YOU MUST RE-RUN THE COMMAND\"; exit 1; }"]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = split("/", get_parent_terragrunt_dir())[length(split("/", get_parent_terragrunt_dir())) - 2] == "ops-tf-gitlab" ? ["sh", "./.terragrunt/getKubeConfig.sh", "${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}", "${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "kubernetes_cluster")}"] : ["echo", ""]
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["rm", "./.terragrunt/common.hcl"]
    run_on_error = true
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["rm", "./.terragrunt/getRancherAPIAdminToken.sh"]
    run_on_error = true
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["rm", "./.terragrunt/getRancherAPIUrl.sh"]
    run_on_error = true
  }

  after_hook "after_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["rm", "./.terragrunt/getKubeConfig.sh"]
    run_on_error = true
  }
}

inputs = {
  RANCHER_API_URL = "${run_cmd("--terragrunt-quiet", "sh", "./.terragrunt/getRancherAPIUrl.sh", "${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}", "${lookup(lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "aws", jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json"))), "account_name")}")}"
  RANCHER_TOKEN_KEY = "${run_cmd("--terragrunt-quiet", "sh", "./.terragrunt/getRancherAPIAdminToken.sh", "${lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}", "${lookup(lookup(jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "aws", jsondecode(file("../variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json"))), "account_name")}")}"
}
