# Apache Cassandra Chef Cookbook

This is an OpsCode Chef cookbook for Apache Cassandra ([DataStax Community Edition](http://www.datastax.com/products/community)).

It uses officially released Debian packages, provides Upstart service script but has no
way to tweak Cassandra configuration parameters using Chef node attributes. The reason for
that is it was created for CI and development environments. Attributes will be used in the future,
doing so for single-server installations won't be difficult.


## Apache Cassandra Version

This cookbook currently provides

 * Cassandra 1.2.x via tarballs
 * Cassandra 1.2.x (DataStax Community Edition) via packages.

## Supported OS Distributions

Ubuntu 11.04, 11.10, 12.04, 12.10.


## Recipes

Two provided recipes are `cassandra::tarball` and `cassandra::datastax`. The former uses official tarballs
and thus can be used to provision any specific version.

The latter uses DataStax Debian repository and provisions Cassandra `1.2`.


## Attributes

 * `node[:cassandra][:version]` (default: a recent patch version): version to provision
 * `node[:cassandra][:tarball][:url]` and `node[:cassandra][:tarball][:md5]` specify tarball URL and MD5 chechsum used by the `cassandra::tarball` recipe.
 * `node[:cassandra][:user]`: username Cassandra node process will use
 * `node[:cassandra][:jvm][:xms]` (default: `32`) and `node[:cassandra][:jvm][:xmx]` (default: `512`) control JVM `-Xms` and `-Xms` flag values, in megabytes (no need to add the `m` suffix)
 * `node[:cassandra][:installation_dir]` (default: `/usr/local/cassandra`): installation directory
 * `node[:cassandra][:data_root_dir]` (default: `/var/lib/cassandra`): data directory root
 * `node[:cassandra][:log_dir]` (default: `/var/log/cassandra`): log directory
 * `node[:cassandra][:rpc_address]` (default: `localhost`): address to bind the RPC interface
 
## Helpful Details

* Authentication is enabled by default, you may log in with ```cqlsh ip_address -u cassandra -p cassandra``` - it goes without saying that you should change the username and password before putting anything in production :)
* At the same time you're changing the default password you'll want to change the replication factor for the system_auth keyspace.  From the ```cqlsh``` prompt, run ```ALTER KEYSPACE system_auth WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 3};```
* The seed list is currently generated from the list of private IP addresses within the OpsWorks cassandra layer.  To use any sort of multi-region function you'll need to use public IP addresses in the seed list (and use the multi-region snitch: ```EC2MultiRegionSnitch```)


## Dependencies

OracleJDK 7, OpenJDK 7, OpenJDK 6 or Sun JDK 6.


## Copyright & License

Michael S. Klishin, Travis CI Development Team, 2012.

Released under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
