include_recipe "docker-deploy"

workspace  = node["training"]["workspace"]      # /home/vagrant
container  = node["training"]["container"]
version    = node["training"]["deploy_version"] # 0.0.73
ports      = node["training"]["ports"]

execute "docker pull #{container[:repo]}/#{container[:name]}:#{version}"

# rename container depending on occupied port
#
# we can use only predefined container names
# however we need find available port at according to task

ports.each do |name, port|
	execute "docker rename #{container[:name]} #{name}" do
		only_if "docker port #{container[:name]} #{container[:port]} | grep #{port[:from]}"
	end
end

ports.each do |name, port|
	execute "remove-#{name}" do
		command "docker stop #{name} && docker rm #{name}"
		action	:nothing
	end

	execute "start-#{name}-#{container[:name]}" do
		command <<~EOF.gsub("\n"," ")
			docker run
			--detach
			--name #{container[:name]}
			--publish #{port[:to]}:#{container[:port]}
			#{container[:repo]}/#{container[:name]}:#{version}
			EOF
		notifies :run, "execute[remove-#{name}]", :immediately
		only_if  "docker ps --all --format {{.Names}} | grep #{name}"
	end
end

# run the container if not found
execute "start-default-#{container[:name]}" do
	command <<~EOF.gsub("\n"," ")
		docker run
		--detach
		--name #{container[:name]}
		--publish #{ports[:blue][:from]}:#{container[:port]}
		#{container[:repo]}/#{container[:name]}:#{version}
		EOF
	not_if  "docker ps --all --format {{.Names}} | grep #{container[:name]}"
end
