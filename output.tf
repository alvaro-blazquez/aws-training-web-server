output "ec2_dns" {
    value = module.ec2_instance.public_dns
}

output "ec2_public_ip" {
    value = module.ec2_instance.public_ip
}

output "ec2_security_groups" {
    value = module.ec2_instance.security_groups
}