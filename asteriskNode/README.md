- cd /opt/
- sudo git clone https://github.com/ethanbrooks/voip-stack.git
- sudo chown -R ubuntu voip-stack
- sudo docker login registry.gitlab.com
### on the ARM64 box
- sudo docker build -t registry.gitlab.com/ebr00ks/voip-stack:asterisk-node-amd64-latest
- sudo docker push registry.gitlab.com/ebr00ks/voip-stack:asterisk-node-amd64-latest
 
 ### on the ARM64 box
- sudo docker build -t registry.gitlab.com/ebr00ks/voip-stack:asterisk-node-arm64-latest
- sudo docker push registry.gitlab.com/ebr00ks/voip-stack:asterisk-node-arm64-latest
