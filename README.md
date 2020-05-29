# void-stack


***Install Docker***
- sudo apt-get update
- sudo apt-get upgrade
- sudo reboot
- sudo apt install apt-transport-https ca-certificates curl software-properties-common
- curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
- sudo add-apt-repository &quot;deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable&quot;
- sudo apt update
- apt-cache policy docker-ce
- sudo apt install docker-ce
- sudo usermod -aG docker ${USER}
- exit

***Install Docker-compose***
- sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
- sudo chmod +x /usr/local/bin/docker-compose
