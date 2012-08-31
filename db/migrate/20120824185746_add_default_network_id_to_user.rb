class AddDefaultNetworkIdToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :network
    end
  end
end
