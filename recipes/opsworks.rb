include_recipe "cassandra::datastax"

seed_array = []
node[:opsworks][:layers][:cassandra][:instances].each{|instance| seed_array << instance.private_ip}

if seed_array.empty?
  seed_array << node[:ipaddress]
end
  
default[:cassandra][:seeds] = seed_array

%w(cassandra.yaml cassandra-env.sh).each do |f|
  template File.join(node["cassandra"]["conf_dir"], f) do
    source "#{f}.erb"
    owner node["cassandra"]["user"]
    group node["cassandra"]["user"]
    mode  0644
    notifies :restart, resources(:service => "cassandra")
  end
end
