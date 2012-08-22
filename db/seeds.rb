# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Type.find_or_create_by_name('Router')
Type.find_or_create_by_name('Server')

network = Network.find_or_create_by_network_and_mask(network: 3232235520, mask: 4294967040)


@network = 3232235520
@mask = 4294967040
@ip = @network+1
while ( (@ip & @mask) == @network) do
    network.devices.find_or_create_by_ip(ip:@ip, description: 'test', type: Type.find_by_name('Router'))
    @ip+=1
end
