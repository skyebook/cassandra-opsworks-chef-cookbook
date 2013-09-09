#
# Cookbook Name:: cassandra-opsworks
# Recipe:: ephemeral_xfs
#
# Copyright 2013, Skye Book
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# AWS preconfigures instance storage as ext3
# but we want to use XFS for storage.
# TODO: Eventually this should be updated to support
#       multiple instance stores in RAID-0

# Install XFS
package "xfsprogs" do
  action :install
end

target        = "/dev/xvdb"
mountLocation = "/mnt"

# Unmount the ephemeral storage provided by Amazon
execute "umount" do
  command "umount #{target}"
end

# Make the new filesystem (-f option is used to overwrite the existing)
execute "mkfs.xfs" do
  command "mkfs.xfs -f #{target}"
end

# Mount the new filesystem
execute "mount" do
  command "mount #{target} #{mountLocation}"
end

# Make the mount accessible
execute "chmod" do
  command "chmod 777 #{mountLocation}"
end