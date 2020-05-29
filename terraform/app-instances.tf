/* Setup our aws provider */
provider "aws" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  region      = var.region
}
resource "aws_instance" "master" {
  ami           = "ami-06bc4b335fb17ee3f"
  instance_type = "a1.medium"
  security_groups = [aws_security_group.swarm.name]
  key_name = aws_key_pair.deployer.key_name
  connection {
    host = "ec2-52-3-82-134.compute-1.amazonaws.com"
    user = "ubuntu"
    private_key = file("/opt/voip/voip.key")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https ca-certificates",
      "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "sudo sh -c 'echo \"deb https://apt.dockerproject.org/repo ubuntu-trusty main\" > /etc/apt/sources.list.d/docker.list'",
      "sudo apt-get update",
      "sudo apt-get install -y docker-engine=1.12.0-0~trusty",
      "sudo docker swarm init",
      "sudo docker swarm join-token --quiet worker > /home/ubuntu/token"
    ]
  }
  provisioner "file" {
    source = "proj"
    destination = "/home/ubuntu/"
  }
  tags = { 
    Name = "swarm-master"
  }
}

resource "aws_instance" "slave" {
  count         = 2
  ami           = "ami-06bc4b335fb17ee3f"
  instance_type = "a1.medium"
  security_groups =  [aws_security_group.swarm.name]
  key_name = "aws_key_pair.deployer.key_name"
  connection {
    host = "ec2-52-3-82-134.compute-1.amazonaws.com"
    user = "ubuntu"
    private_key = file("/opt/voip/voip.key")
  }
  provisioner "file" {
    source = "/opt/voip/voip.key"
    destination = "/home/ubuntu/key.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install apt-transport-https ca-certificates",
      "sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D",
      "sudo sh -c 'echo \"deb https://apt.dockerproject.org/repo ubuntu-trusty main\" > /etc/apt/sources.list.d/docker.list'",
      "sudo apt-get update",
      "sudo apt-get install -y docker-engine=1.12.0-0~trusty",
      "sudo chmod 400 /home/ubuntu/test.pem",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i test.pem ubuntu@${aws_instance.master.private_ip}:/home/ubuntu/token .",
      "sudo docker swarm join --token $(cat /home/ubuntu/token) ${aws_instance.master.private_ip}:2377"
    ]
  }
  tags = { 
    Name = "swarm-${count.index}"
  }
}
