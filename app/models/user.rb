class User < ActiveRecord::Base
  authenticated_by_shibboleth
  
  attr_accessible :login, :network_id, :emplid, :name_n
  
  belongs_to :network
  
end
