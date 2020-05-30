/* Setup our aws provider */
provider "aws" {
  access_key  = var.access_key
  secret_key  = var.secret_key
  region      = var.region
}
resource "aws_instance" "master" {
  ami           = "ami-05d7ab19b28efa213"
  instance_type = "a1.medium"
  security_groups = [aws_security_group.swarm.name]
  key_name = aws_key_pair.deployer.key_name
  connection {
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/opt/voip/voip.key")
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y i apt-transport-https ca-certificates curl software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add", 
      "sudo sudo add-apt-repository 'deb [arch=arm64] https://download.docker.com/linux/ubuntu bionic stable';",
      "sudo apt-get -y update",
      "sudo apt-cache policy docker-ce",
      "sudo apt-get -y install docker-ce", 
      "sudo usermod -aG docker ubuntu",
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
  ami           = "ami-05d7ab19b28efa213"
  instance_type = "a1.medium"
  security_groups =  [aws_security_group.swarm.name]
  key_name = aws_key_pair.deployer.key_name
  connection {
    host = self.public_ip
    user = "ubuntu"
    private_key = file("/opt/voip/voip.key")
  }
  provisioner "file" {
    source = "/opt/voip/voip.key"
    destination = "/home/ubuntu/key.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y i apt-transport-https ca-certificates curl software-properties-common",
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add",
      "sudo sudo add-apt-repository 'deb [arch=arm64] https://download.docker.com/linux/ubuntu bionic stable';",
      "sudo apt-get -y update",
      "sudo apt-cache policy docker-ce",
      "sudo apt-get -y install docker-ce",      
      "sudo usermod -aG docker ubuntu",
      "sudo chmod 400 /home/ubuntu/key.pem",
      "sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i key.pem ubuntu@${aws_instance.master.private_ip}:/home/ubuntu/token .",
      "sudo docker swarm join --token $(cat /home/ubuntu/token) ${aws_instance.master.private_ip}:2377"
    ]
  }
  tags = { 
    Name = "swarm-${count.index}"
  }
}
