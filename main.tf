resource "aws_instance" "nomad-node" {
    count = var.nomad_node_count
    ami = var.nomad_node_ami_id
    instance_type = var.nomad_node_instance_size
    key_name = var.aws_key_name
    subnet_id = aws_subnet.nomad-lab-pub[count.index].id
    vpc_security_group_ids = [aws_security_group.nomad-sg.id]
    associate_public_ip_address = true
    user_data = file("conf/install-nomad.sh")
    private_ip = "10.0.${count.index}.100"

    instance_market_options {
        market_type = "spot"
        spot_options {
            max_price  = var.nomad_node_spot_price
            instance_interruption_behavior = "stop"
        }
    }

    tags = {
        Terraform = "true"
        ProvisionedBy = "Project Avaazz"
        Avaazz = "true"
        Name = "nomad-node-${count.index}"
    }
}

