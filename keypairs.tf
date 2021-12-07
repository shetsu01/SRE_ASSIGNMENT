
resource "aws_key_pair" "ec2key" {
  key_name   = var.public_key_name
  public_key = file(var.public_key_path)
}
