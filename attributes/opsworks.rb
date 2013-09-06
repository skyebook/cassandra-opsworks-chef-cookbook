default[:cassandra] = {
  :cluster_name => "Test Cluster",
  :initial_token => "",
  :version => '2.0.0',
  :user => "cassandra",
  :jvm  => {
    :xms => 32,
    :xmx => 512
  },
  :limits => {
    :memlock => 'unlimited',
    :nofile  => 48000
  },
  :installation_dir => "/usr/local/cassandra",
  :bin_dir          => "/usr/local/cassandra/bin",
  :lib_dir          => "/usr/local/cassandra/lib",
  :conf_dir         => "/etc/cassandra/",
  # commit log, data directory, saved caches and so on are all stored under the data root. MK.
  :data_root_dir    => "/var/lib/cassandra/",
  :commitlog_dir    => "/var/lib/cassandra/",
  :log_dir          => "/var/log/cassandra/",
  :listen_address   => node[:ipaddress],
  :rpc_address      => node[:ipaddress],
  :max_heap_size    => nil,
  :heap_new_size    => nil,
  :vnodes           => 64,
  :seeds            => [],
  :concurrent_reads => 32,
  :concurrent_writes => 32,
  :snitch           => 'EC2Snitch',
  :authenticator    => 'org.apache.cassandra.auth.PasswordAuthenticator',
  :authorizer       => 'org.apache.cassandra.auth.CassandraAuthorizer'
}

# Set the OpsWorks specifics here

seed_array = []
node["opsworks"]["layers"]["cassandra"]["instances"].each do |instance_name, values|
  # If using the multi-region snitch, we must use the public IP address
  if node[:cassandra][:snitch] == "Ec2MultiRegionSnitch"
    log "Cassandra OpsWorks Seed Configuration" do
      level :info
      message "Using multi-region snitch"
    end
    seed_array << values["ip"]
  else
    log "Cassandra OpsWorks Seed Configuration" do
      level :info
      message "Using single-region snitch"
    end
    seed_array << values["private_ip"]
  end
end

if seed_array.empty?
  seed_array << node[:ipaddress]
end
  
set[:cassandra][:seeds] = seed_array