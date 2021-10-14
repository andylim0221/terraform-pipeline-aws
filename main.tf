# Main infrastructure layout.
# Create modules for your projects and call them here.

# Security demonstrator API.
module "security_demo" {
  source = "./modules/security_demo"
}
output "api_endpoint" {
  value     = module.security_demo.api_endpoint
  sensitive = false
}
