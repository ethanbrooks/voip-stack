### Create Key
ssh-keygen -t rsa -C "ethan.brooks@gmail.com"
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-east-1

aws --region us-east-1 ec2 import-key-pair \
    --key-name "terraform-voip" \
    --public-key-material file:///opt/voip/voip.key.pub
    
    
    
AWS

- wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
- wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_arm.zip

- sudo apt-get install unzip
- unzip terraform_0.12.26_linux_amd64.zip
- sudo mv terraform /usr/local/bin/terraform
- terraform init
- terraform plan
- terraform apply






