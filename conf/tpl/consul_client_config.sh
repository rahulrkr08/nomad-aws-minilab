# Consul client config
mkdir -p /etc/consul.d
cat <<EOF > '/etc/consul.d/consul.hcl'
"datacenter" = "tutorialinux"
"data_dir" = "/var/lib/consul"
"retry_join" = ["provider=aws tag_key=Nomad tag_value=true"]
"client_addr" = "0.0.0.0"
"bind_addr" = "{{GetInterfaceIP \"eth0\" }}"
"leave_on_terminate" = true
"enable_syslog" = true
"disable_update_check" = true
"enable_debug" = true
EOF

systemctl restart consul