class CreateDhcpServers < ActiveRecord::Migration
  def change
    create_table :dhcp_servers do |t|
      t.string :name

      t.timestamps
    end
  end
end
