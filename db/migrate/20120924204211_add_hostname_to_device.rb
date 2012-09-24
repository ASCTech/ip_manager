class AddHostnameToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :hostname, :string
  end
end
