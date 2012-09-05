# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Type.find_or_create_by_name('Router')
Type.find_or_create_by_name('Server')

hh = Building.find_or_create_by_name( :name => 'Hagerty Hall', :code => 'HH', :osuid => 37 )
sm = Building.find_or_create_by_name( :name => 'Smith Labs', :code => 'SM', :osuid => 65 )

ociodhcp = DhcpServer.find_or_create_by_name(name:'OCIO DHCP')

#192.168.0.0/24
network = Network.find_or_create_by_network_and_mask(network: 3232235520, mask: 4294967040)
network.description = 'Test network'
network.gateway = 3232235521;
network.save
network.init_ips

#140.254.248.0/23
network = Network.find_or_create_by_network_and_mask(network: 2365519872, mask: 4294966784)
network.description = 'HH Servers'
network.gateway = 2365519873
network.save
network.init_ips

if network.buildings.empty?
    network.buildings << hh
    network.buildings << sm
end

Network.all.each do |n|
    if n.dhcp_server.nil?
        n.dhcp_server_id = ociodhcp.id
        n.save
    end
end


User.find_or_create_by_emplid(:name_n => 'wisniewski.58', :emplid => '200131317')
