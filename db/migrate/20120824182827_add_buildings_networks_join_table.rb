class AddBuildingsNetworksJoinTable < ActiveRecord::Migration
  def change
    create_table :buildings_networks do |t|
      t.references :building
      t.references :network
    end
    add_index :buildings_networks, :network_id
  end
end
