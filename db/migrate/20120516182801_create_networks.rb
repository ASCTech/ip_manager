class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.integer :network, :limit=>8
      t.integer :mask, :limit=>8

      t.timestamps
    end
  end
end
