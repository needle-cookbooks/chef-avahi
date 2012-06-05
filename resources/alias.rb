def initialize(*args)
  super
  @action = :add
end

actions :add, :remove

attribute :name, :kind_of => String, :required => true, :name_attribute => true
