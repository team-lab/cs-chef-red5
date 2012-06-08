red5 node[:red5][:installation_dir] do
  url      node[:red5][:url]
  checksum node[:red5][:checksum]
  user     node[:red5][:user]
  group    node[:red5][:group]
end
