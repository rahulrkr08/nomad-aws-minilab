data_dir = "/tmp/consul/server"

server           = true
bootstrap_expect = 3
advertise_addr   = "{{ GetInterfaceIP `eth0` }}"
client_addr      = "0.0.0.0"
ui               = true
datacenter       = "dc-aws-1"
retry_join       = ["provider=aws tag_key=Nomad tag_value=true addr_type=private_v4"]
retry_max        = 10
retry_interval   = "15s"

acl = {
  enabled = false
  default_policy = "allow"
  enable_token_persistence = true
}

auto_advertise = true

server_auto_join = true
client_auto_join = true
