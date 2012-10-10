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
  
  def description
    super.nil? ? "" : super
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
    iprange = IPAddr.new(self.cidr_full).to_range
    iprange.each do |ip|
      # create all but the first and last ips in the range
      if (ip != iprange.first && ip != iprange.last)
        self.devices.find_or_create_by_ip(:ip => ip.to_i)
      end
    end
  end
  
  def updatehostnames
    #we need two different strings
    #one being the reverse zone name, down to class-b-specificity
    #the second being a class-c list of ip's for grep
    
    #reverse zones exist on a class b level, but we only want to get info for
    #devices on a class c level, so we need to build a string to grep for those only
    #we need to loop through which class c's we need.
    #for example, 140.254.248.0/23 is axfr'd with 254.140.in-addr.arpa
    #and needs to be grepped with 248.254.140 and 249.254.140
    n = IPAddr.new(self.network+"/"+self.mask)
    reverse = n.reverse.split(/\./)
    #remove the first 2 octets
    reverse_zone = reverse.clone
    reverse_zone.shift(2)
    reverse_zone = reverse_zone.join '.'
    
    reverse_class_b = reverse.clone
    reverse_class_b.shift(2)
    reverse_class_b.pop(2)
    reverse_class_b = reverse_class_b.join '\.'
    first_third_octet = n.to_range.first.to_s.split(/\./)[2].to_i
    last_third_octet = n.to_range.last.to_s.split(/\./)[2].to_i
    
    reverse_grep = Array.new
    
    for i in first_third_octet..last_third_octet do
      reverse_grep.push(i.to_s + '\.' + reverse_class_b)
    end
    
    #example dig|grep command: dig axfr 254.140.in-addr.arpa | grep -e "248\.254\.140\|249\.254\.140"
    dig = `dig axfr #{reverse_zone} | grep -e \"#{reverse_grep.join '\\|'}\"`
    unless dig.empty?
      dig.split(/\n/).each do |line|
        
        #parse out ip address and hostname
        matchdata = /(?<reverseip>[\d\.]+)\.in\-addr\.arpa\.\s+\d+\s+IN\s+PTR\s+(?<fqdn>[\w\-\.]+)\./.match(line)
        
        #convert parsed out ip address to integer form
        ip = IPAddr.new(matchdata[:reverseip].split(/\./).reverse.join('.'),Socket::AF_INET).to_i
        
        device = devices.find_by_ip(ip)
        unless device.nil?
          device[:hostname] = matchdata[:fqdn]
          device.save
        end
      end
    else
      puts "Zone transfer failed"
    end
  
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
