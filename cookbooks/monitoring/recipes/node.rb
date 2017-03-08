package "epel-release"
package "collectd"

cookbook_file "/etc/collectd.conf" do
	source "node/collectd.conf"
end

service "collectd" do
	action [:start, :enable]
end
