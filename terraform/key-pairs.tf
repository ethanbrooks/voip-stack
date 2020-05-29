resource "aws_key_pair" "deployer" {
  key_name = "voip"
  public_key = "file(/opt/voip/voip.pem)"
}
