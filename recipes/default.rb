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

include_recipe "git"

case node[:platform]
when "ubuntu"

  package 'avahi-daemon' do
    action :install
  end

  service 'avahi-daemon' do
    action :start
    provider Chef::Provider::Service::Upstart
    supports :restart => false
  end

  %w{ python-dbus python-avahi }.each do |pkg|
    package pkg
  end

  bash 'install-avahi-aliases' do
    cwd '/usr/src/avahi-aliases'
    code <<-EOH
      ./install.sh
    EOH
    action :nothing
  end

  git '/usr/src/avahi-aliases' do
    repo 'https://github.com/needle-cookbooks/avahi-aliases.git'
    action :checkout
    notifies :run, "bash[install-avahi-aliases]", :immediately
  end

  bash 'avahi-publish-aliases' do
    code <<-EOH
      /usr/bin/avahi-publish-aliases
    EOH
    action :nothing
  end

  template '/etc/avahi/avahi-daemon.conf' do
    source 'avahi-daemon.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, "bash[avahi-publish-aliases]", :immediately
    notifies :restart, "service[avahi-daemon]", :delayed
  end

  # the purpose of this upstart 'service' is to publish any aliases at boot
  cookbook_file '/etc/init/avahi-publish-aliases.conf' do
    source 'upstart-avahi-publish-aliases'
    mode '0644'
    owner 'root'
    group 'root'
  end

  service 'avahi-publish-aliases' do
    provider Chef::Provider::Service::Upstart
    action [:enable]
  end

else
  Chef::Log.error("Your platform (#{node[:platform]}) is not supported.")
end
