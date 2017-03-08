registry_crt = data_bag_item("docker_registry", "keys")["certificate"]
container    = node["training"]["container"]

# upload certificates
directory "/etc/docker/certs.d/#{container[:repo]}" do
	recursive true
end

file "/etc/docker/certs.d/#{container[:repo]}/ca.crt" do
	content registry_crt
	mode    "644"
end
