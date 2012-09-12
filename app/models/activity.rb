class Activity < ActiveRecord::Base
  default_scope :order => 'updated_at DESC'
  attr_accessible :activity, :user_id
end
