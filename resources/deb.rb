actions :add, :remove
default_action :add

attribute :package, :kind_of => String
attribute :distribution, :kind_of => [String,Array]
