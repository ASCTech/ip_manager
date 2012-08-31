class Device < ActiveRecord::Base
  require 'ipaddr'
  require 'socket'
  
  belongs_to :network
  belongs_to :type
  attr_accessible :ip, :description, :type_id
  
  def ip
    IPAddr.new(super,Socket::AF_INET).to_s
  end
  
  def hostname
    Socket.gethostbyaddr(IPAddr.new(self.attributes['ip'],Socket::AF_INET).hton)
  end
  
end
