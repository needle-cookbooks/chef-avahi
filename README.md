Description
===========

Installs [avahi](http://avahi.org/) and provides a simple LWRP for managing avahi hostname aliases.

This is mostly useful for establishing DNS names for local VMs without having to manually manage one's /etc/hosts file.

Requirements
============

Only works on Ubuntu for now.

Attributes
==========

* hostname: optional hostname, defaults to `nil`
* domain: domain suffix, defaults to 'local'
* browse_domains: additional search domains, defaults to []
* use_ipv4: defaults to true
* use_ipv6: defaults to true
* allow_interfaces: list of interfaces to listen on defaults to [] (all interfaces)
* deny_interfaces: list of interfaces to explicitly ignore defaults to [] (no interfaces)


Usage
=====

```
include_recipe 'avahi'

avahi_alias 'foo.bar.local'
```
