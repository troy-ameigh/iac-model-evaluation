# Create AWS Amplify domain with basic subdomains via the 'awscc' provider

# Create AWS Amplify App
resource "awscc_amplify_app" "example" {
  name = "app"

  # Setup redirect from https://example.com to https://www.example.com
  custom_rules = [
    {
      source = "https://example.com"
      status = "302"
      target = "https://www.example.com"
    },
  ]
}

# Create AWS Amplify Branch within the above AWS Amplify App
resource "awscc_amplify_branch" "main" {
  app_id      = awscc_amplify_app.example.app_id
  branch_name = "main"
}

# Create AWS Amplify Domain
resource "awscc_amplify_domain" "example" {
  app_id      = awscc_amplify_app.example.app_id
  domain_name = "example.com"

  sub_domain_settings = [
    {
      # https://example.com
      branch_name = aws_amplify_branch.main.branch_name
      prefix      = ""
    },
    {
      # https://www.example.com
      branch_name = aws_amplify_branch.main.branch_name
      prefix      = "www"
    },
  ]
}
