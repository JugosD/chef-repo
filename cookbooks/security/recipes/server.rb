workspace    = node["training"]["workspace"]
registry_crt = data_bag_item("docker_registry", "keys")["certificate"]
registry_key = data_bag_item("docker_registry", "keys")["private_key"]

# upload certificates
directory "#{workspace}/certs" do
	mode "755"
end

file "#{workspace}/certs/ca.crt" do
	content registry_crt
	mode    "644"
end

file "#{workspace}/certs/ca.key" do
	content registry_key
	mode    "644"
end

# configure firewall
node["training"]["allow_ports"].each do |port|
	execute "firewall-cmd --zone=public --permanent --add-port=#{port}" do
		not_if "firewall-cmd --list-ports | grep #{port}"
	end
end

execute "firewall-cmd --reload"
