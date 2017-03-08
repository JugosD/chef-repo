# install influxdb and grafana
["influxdb", "grafana"].each do |service_name|
	cookbook_file "/etc/yum.repos.d/#{service_name}.repo" do
		source "server/#{service_name}.repo"
	end
	package service_name
end

# start services
service "grafana-server" do
	action [:start, :enable]
end

service "influxdb" do
	action [:start, :enable]
end

# configure influxdb
execute "influx -execute 'CREATE DATABASE collectd'" do
	not_if "influx -execute 'SHOW DATABASES' | grep collectd"
end

directory "usr/share/collectd" do
	recursive true
end

cookbook_file "/usr/share/collectd/types.db" do
	source "server/types.db"
	notifies :restart, "service[influxdb]" 
end

cookbook_file "/etc/influxdb/influxdb.conf" do
	source "server/influxdb.conf"
	notifies :restart, "service[influxdb]"
end
