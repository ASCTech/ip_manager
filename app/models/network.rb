class Network < ActiveRecord::Base
  require 'ipaddr'
  
  has_many :devices
  has_many :users
  has_and_belongs_to_many :buildings
  belongs_to :dhcp_server
  attr_accessible :mask, :network, :gateway, :dhcp_server_id, :vlan, :building_ids, :description
  
  def mask
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  def network
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  def gateway
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  #displays mask "slash number" e.g. 255.255.255.0 is "24"
  def cidr_mask
    32-Integer(Math.log2((IPAddr.new(mask,Socket::AF_INET).to_i^0xffffffff)+1))
  end
  
  #displays n.n.n.n/n
  def cidr_full
    network+"/"+cidr_mask.to_s
  end
  
  #displays n.n.n.n/n description
  def cidr_and_description
    cidr_full+" "+description
  end
  
  #initializes IPs for a network if they have not been created yet
  def init_ips
    ip = self.attributes['network'] + 1
    while ( (self.attributes['network'] & self.attributes['mask']) == (ip+1 & self.attributes['mask']) )
      self.devices.find_or_create_by_ip(:ip => ip)
      ip += 1
    end
  end
  
  def hostnames
    
  end
  
end
