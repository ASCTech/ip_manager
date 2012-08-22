class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :network
      t.integer :ip, :limit => 8
      t.text :description
      t.timestamps
    end
  end
end
