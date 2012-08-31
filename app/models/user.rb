class User < ActiveRecord::Base
  attr_accessible :login
  attr_accessible :network_id
  
  belongs_to :network
end
