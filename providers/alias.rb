action :add do

  bash "avahi-publish-alias-#{new_resource.name}" do
    code <<-EOH
      /usr/bin/avahi-publish-aliases
    EOH
    action :nothing
  end

  file ::File.join('/etc/avahi/aliases.d',new_resource.name) do
    content new_resource.name
    action :create
    notifies :run, resources(:bash => "avahi-publish-alias-#{new_resource.name}"), :immediately
  end

end

action :remove do

  bash "avahi-remove-alias-#{new_resource.name}" do
    code <<-EOH
      /usr/bin/avahi-remove-alias #{new_resource.name}
    EOH
  end

end
