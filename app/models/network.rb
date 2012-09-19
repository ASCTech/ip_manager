class Network < ActiveRecord::Base
  require 'ipaddr'
  
  has_many :devices, :dependent => :restrict
  has_many :users, :dependent => :nullify
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
  
  #will begin when given axfr permissions
  def hostnames
    
  end
  
  #gets array of network addresses that are unique by the first 2 octets
  def self.uniq_class_b
    networks = Array.new
    ActiveRecord::Base.connection.select_all('select DISTINCT (network & 0xffff0000) as network from networks order by network').each do |n|
      networks.push(IPAddr.new(n['network'].to_i,Socket::AF_INET).to_s)
    end
    networks
  end
  
  #gets all networks that match the provided class b address
  def self.find_by_class_b(address)
    #handle empty address
    if address.nil? || address.empty?
      return Network.all
    end
      
    address_i = IPAddr.new(address,Socket::AF_INET).to_i
    network_ids = Array.new
    ActiveRecord::Base.connection.select_all("select id from networks where (#{address_i} & 0xffff0000) = (network & 0xffff0000)").each do |n|
      network_ids.push(n['id'])
    end
    
    begin
      Network.find(:all, :conditions => {:id => network_ids})
    rescue
      Network.all
    end
    
  end
  
end
