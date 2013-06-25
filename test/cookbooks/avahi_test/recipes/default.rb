#
# Cookbook Name:: avahi_test
# Recipe:: default
#
# Copyright (C) 2013 Needle, Inc.
#
# All rights reserved - Do Not Redistribute
#

node.override[:avahi][:hostname] = 'avahi'
node.override[:avahi][:domain] = 'test-kitchen.local'

include_recipe 'avahi::default'

avahi_alias 'alias.test-kitchen.local'

