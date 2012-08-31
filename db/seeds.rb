# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Type.find_or_create_by_name('Router')
Type.find_or_create_by_name('Server')

hh = Building.create( :name => 'Hagerty Hall', :code => 'HH', :osuid => 37 )
sm = Building.create( :name => 'Smith Labs', :code => 'SM', :osuid => 65 )

network = Network.find_or_create_by_network_and_mask(network: 3232235520, mask: 4294967040)
network.description = 'test network'
network.gateway = 3232235521;
network.save

#192.168.0.0/24
@network = 3232235520
@mask = 4294967040
@ip = @network+1
while ( (@ip & @mask) == @network) do
    network.devices.find_or_create_by_ip(ip:@ip, description: 'test', type_id: Type.find_by_name('Router'))
    @ip+=1
end

network = Network.find_or_create_by_network_and_mask(network: 2365519872, mask: 4294966784)
network.description = 'HH Servers'
network.gateway = 2365519873
network.save

#140.254.248.0/23
@network = 2365519872
@mask = 4294966784
@ip = @network+1
while ( (@ip & @mask) == @network) do
    network.devices.find_or_create_by_ip(ip:@ip, description: 'test', type_id: Type.find_by_name('Router'))
    @ip+=1
end

if network.buildings.empty?
    network.buildings << hh
    network.buildings << sm
end


