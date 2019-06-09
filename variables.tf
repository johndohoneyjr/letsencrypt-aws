# ----------------------------------------------------------------
# Variables required for ACME provider demo
# ----------------------------------------------------------------

# Let's Encrypt Account Registration Config
variable "demo_acme_registration_email"  { default = "jdohoney@hashicorp.com" }

# Domain against which certificate will be created
# i.e. letsencrypt-terraform.joestack.xyz
variable "demo_domain_name"              { default = "this-demo.rocks"}
variable "demo_domain_subdomain"         { default = "dohoney-ptfe"}

variable "demo_acme_challenge_aws_access_key_id"     { default="" }
variable "demo_acme_challenge_aws_secret_access_key" { default="" }
variable "demo_acme_challenge_aws_region"            { default="" }
