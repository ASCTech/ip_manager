class Network < ActiveRecord::Base
    require 'ipaddr'
    
    has_many :devices
    attr_accessible :mask, :network
    
    def mask
        IPAddr.new(super,Socket::AF_INET).to_s
    end
    
    def network
        IPAddr.new(super,Socket::AF_INET).to_s
    end
    
    def cidr_mask
        32-Integer(Math.log2((IPAddr.new(mask,Socket::AF_INET).to_i^0xffffffff)+1))
    end
end
