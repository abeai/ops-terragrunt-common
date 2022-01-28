terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["echo", "===========================\nYOU ARE USING THE FOLLOWING WORKSPACE:\n\n${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}\n\nENSURE THIS IS CORRECT!\n===========================\n\nPress Any Key To Continue..."]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["read", "-n 1", "-s"]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["aws-mfa", "--profile", lookup(lookup(jsondecode(file("variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "aws", {}), "profile")]
  }

  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["bash", "-c", "export VAULT_ADDR=\"${lookup(jsondecode(file("variables/${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}.json")), "vault_address")}\"; vault token lookup || vault login --method=github"]
  }
}
