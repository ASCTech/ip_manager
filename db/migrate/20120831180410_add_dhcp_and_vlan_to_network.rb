class AddDhcpAndVlanToNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :dhcp_server_id, :integer
    add_column :networks, :vlan, :integer
  end
end
