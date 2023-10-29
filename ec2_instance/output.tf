output "public_ip" {

  value = resource.aws_instance.ec2_instances.public_ip

}