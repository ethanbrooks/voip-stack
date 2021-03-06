module "docker-swarm" {
  source  = "trajano/swarm-aws/docker"

  name               = "My VPC Swarm"
  vpc_id             = aws_vpc.main.id
  workers            = 5
  managers           = 3
  cloud_config_extra = file("users.cloud-config")

  exposed_security_group_ids = [
    aws_security_group.exposed.id,
  ]
}