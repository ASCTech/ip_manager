class Network < ActiveRecord::Base
  require 'ipaddr'
  
  has_many :devices
  has_many :users
  has_and_belongs_to_many :buildings
  attr_accessible :mask, :network, :gateway
  
  def mask
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  def network
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  def gateway
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  def cidr_mask
    32-Integer(Math.log2((IPAddr.new(mask,Socket::AF_INET).to_i^0xffffffff)+1))
  end
  
  def cidr_full
    network+"/"+cidr_mask.to_s
  end
  
  def cidr_and_description
    cidr_full+" "+description
  end
  
end
