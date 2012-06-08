actions :install, :remove

attribute :url,      :default => nil, :regex => /^http:\/\/.*(tar.gz|zip)$/
attribute :checksum, :default => nil, :regex => /^[a-zA-Z0-9]{64}$/

attribute :dir,   :default => nil,    :required => true, :name_attribute => true
attribute :user,  :default => "root", :required => true
attribute :group, :default => "root", :required => true

def initialize(name, run_context=nil)
  super
  @action = :install
  @dir    = name
end
