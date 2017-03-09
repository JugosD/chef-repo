workspace    = node.default["training"]["workspace"]

# directory containing the registry volume
directory "#{workspace}/registry_data" do
	mode "777"
end

# install docker engine if needed
include_recipe "docker-deploy"

# pull images
execute "docker pull registry"

# clean containers
execute "clean" do
	command "echo containers with 'exited' status removed"
	only_if "docker rm $(docker ps --all --quiet --filter status=exited)"
end

# configure network
execute "docker network create my_network" do
	not_if "docker network inspect my_network"
end

# run continers
execute "registry" do
	command <<~EOF.gsub("\n"," ")
		docker run
		--detach
		--name registry
		--network my_network
		--publish 5000:5000
		--volume #{workspace}/registry_data:/var/lib/registry:z
		--volume #{workspace}/certs:/certs:z
		--env REGISTRY_HTTP_TLS_CERTIFICATE=/certs/ca.crt
		--env REGISTRY_HTTP_TLS_KEY=/certs/ca.key
		registry 
		EOF
	not_if "docker ps --all --format {{.Names}} | grep registry"
end
