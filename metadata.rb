maintainer        "Charles Strahan"
maintainer_email  "charles.c.strahan@gmail.com"
license           "MIT"
description       "Installs Red5"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"

recipe "red5", "Installs Red5"


%w{ debian ubuntu centos redhat scientific fedora amazon arch freebsd }.each do |os|
  supports os
end
