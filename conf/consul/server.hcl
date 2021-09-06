data_dir = "/tmp/consul/server"

server           = true
bootstrap_expect = 1
advertise_addr   = "{{ GetInterfaceIP `eth0` }}"
client_addr      = "0.0.0.0"
ui               = true
datacenter       = "dc-aws-1"
"retry_join"     = ["provider=aws tag_key=Nomad tag_value=true"]
retry_max        = 10
retry_interval   = "15s"

acl = {
  enabled = false
  default_policy = "allow"
  enable_token_persistence = true
}