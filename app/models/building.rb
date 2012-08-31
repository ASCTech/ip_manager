class Building < ActiveRecord::Base
  
  has_and_belongs_to_many :networks
  
  attr_accessible :name, :osuid, :code
end
