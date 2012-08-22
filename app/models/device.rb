class Device < ActiveRecord::Base
    require 'ipaddr'
    belongs_to :network
    belongs_to :type
    attr_accessible :ip, :description, :type
    
    def ip
        IPAddr.new(super,Socket::AF_INET).to_s
    end
    
end
