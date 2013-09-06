# Configure the filesystem
include_recipe "cassandra-opsworks::ephemeral_xfs"

# Install Java 7 First
package "openjdk-7-jre" do
  action :install
end

include_recipe "cassandra-opsworks::datastax"

# Force Java 7 as the default
execute "update-java-alternatives" do
  command "update-java-alternatives --set openjdk-7-jre"
end

%w(cassandra.yaml cassandra-env.sh).each do |f|
  template File.join(node["cassandra"]["conf_dir"], f) do
    source "#{f}.erb"
    owner node["cassandra"]["user"]
    group node["cassandra"]["user"]
    mode  0644
    notifies :restart, resources(:service => "cassandra")
  end
end
