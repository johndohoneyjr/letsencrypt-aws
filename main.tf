provider "acme" {
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}


# The Let's Encrypt registration process has been included to help demo
# a single end-to-end process, however this would normally be split into
# two. See demos/acme-part-1-registration and demos/acme-part-2-core
# for an example of how this might be split
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

  lifecycle {
    create_before_destroy = true
  }
}

# Set up a registration using a private key from tls_private_key
resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "jdohoney@gmail.com"
}

# Create a certificate
resource "acme_certificate" "certificate" {
  account_key_pem           = "${tls_private_key.private_key.private_key_pem}"
  common_name               = "${var.demo_domain_name}"
  subject_alternative_names = ["dohoney-ptfe.this-demo.rocks"]

  dns_challenge {
    provider = "route53"
  }

  lifecycle {
    create_before_destroy = true
  }
}
output "certificate_pem" {
 value = "${acme_certificate.certificate.certificate_pem}"
}
output "issuer_pem" {
 value = "${acme_certificate.certificate.issuer_pem}"
}
output "private_key_pem" {
 value = "${acme_certificate.certificate.private_key_pem}"
}




module "dns" {
    source = "./modules/dns/direct"
    dns_domain_name               = "${var.demo_domain_name}" 
    dns_domain_subdomain          = "${var.demo_domain_subdomain}" 
    dns_cname_value               = "${module.aws-demo-env.demo_env_elb_dnsname}"
}


module "aws-demo-env" {    
  source = "./modules/aws-demo-environment"
    demo_env_nginx_count            = "2"
    demo_env_cert_body              = "${acme_certificate.certificate.certificate_pem}"      
    demo_env_cert_chain             = "${acme_certificate.certificate.issuer_pem}" 
    demo_env_cert_privkey           = "${acme_certificate.certificate.private_key_pem}" 
}
