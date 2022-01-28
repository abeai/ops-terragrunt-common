terraform {
  before_hook "before_hook" {
    commands     = ["apply", "plan", "import"]
    execute      = ["echo", "===========================\nYOU ARE USING THE FOLLOWING WORKSPACE:\n\n${run_cmd("--terragrunt-quiet", "terraform", "workspace", "show")}\n\nENSURE THIS IS CORRECT!\n===========================\n\nPress Any Key To Continue..."]
  }
}
