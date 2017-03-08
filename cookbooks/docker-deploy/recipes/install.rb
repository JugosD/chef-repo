execute "if" do
	command "echo world"
	action :nothing
end

ports = node["training"]["ports"]
ports.each do |name, port|
	execute "some thing" do
		command "echo hello #{port[:from]}"
		notifies :run, "execute[if]", :immediately
	end
end

execute "#{node["training"]["deploy_version"]}"
