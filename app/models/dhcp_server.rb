class DhcpServer < ActiveRecord::Base
  has_many :networks
  attr_accessible :name
end
