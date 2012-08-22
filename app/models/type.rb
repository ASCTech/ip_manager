class Type < ActiveRecord::Base
  has_many :devices
  attr_accessible :name
end
