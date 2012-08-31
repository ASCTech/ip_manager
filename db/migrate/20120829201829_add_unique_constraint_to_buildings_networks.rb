class AddUniqueConstraintToBuildingsNetworks < ActiveRecord::Migration
  def change
    add_index :buildings_networks, [:building_id, :network_id], :unique => true
  end
end
