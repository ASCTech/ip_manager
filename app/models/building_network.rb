class BuildingNetwork < ActiveRecord::Base
  belongs_to :network
  belongs_to :building
  attr_accessible :building, :network
  
  self.table_name = 'buildings_networks'
end
