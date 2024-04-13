resource "aws_instance" "server1" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [ aws_security_group.sg.id ]
  subnet_id = aws_subnet.publicsubnet[0].id
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1.12 -y
    service nginx start
    echo "<div><h1>PUBLIC-SERVER-1</h1></div>" >> /usr/share/nginx/html/index.html
    echo "<div><h1>DEV-OPS 2023</h1></div>" >> /usr/share/nginx/html/index.html
    EOF
    tags = {
    "Name" = "${var.vpc_name}-server1"
  }
}
resource "aws_instance" "server2" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [ aws_security_group.sg.id ]
  subnet_id = aws_subnet.publicsubnet[1].id
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1.12 -y
    service nginx start
    echo "<div><h1>PUBLIC-SERVER-2</h1></div>" >> /usr/share/nginx/html/index.html
    echo "<div><h1>DEV-OPS 2024</h1></div>" >> /usr/share/nginx/html/index.html
    EOF
    tags = {
    "Name" = "${var.vpc_name}-server2"
  }
}
resource "aws_instance" "server3" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [ aws_security_group.sg.id ]
  subnet_id = aws_subnet.publicsubnet[2].id
  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true
  user_data = <<-EOF
  #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1.12 -y
    service nginx start
    echo "<div><h1>PUBLIC-SERVER-3</h1></div>" >> /usr/share/nginx/html/index.html
    echo "<div><h1>DEV-OPS 2024</h1></div>" >> /usr/share/nginx/html/index.html
    EOF
    tags = {
    "Name" = "${var.vpc_name}-server3"
  }
}