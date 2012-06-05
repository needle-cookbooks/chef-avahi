#
# Cookbook Name:: avahi
# Recipe:: default
#
# Copyright 2012, Needle, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ark'

case node[:platform]
when "ubuntu"

  package 'avahi-daemon' do
    action :install
  end

  template '/etc/avahi/avahi-daemon.conf' do
    source 'avahi-daemon.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
  end

  %w{ python-dbus python-avahi }.each do |pkg|
    package pkg
  end

  execute 'install-avahi-aliases' do
    command "/tmp/avahi-aliases/install.sh"
    action :nothing
  end

  ark 'avahi-aliases' do
    url 'https://github.com/ahawthorne/avahi-aliases/tarball/master'
    extension 'tar.gz'
    path '/tmp/'
    action :put
    notifies :run, "execute[install-avahi-aliases]", :immediately
  end

else
  Chef::Log.error("Your platform (#{node[:platform]}) is not supported.")
end
