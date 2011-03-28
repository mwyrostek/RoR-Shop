# == Schema Information
# Schema version: 20110321172743
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  parent_id  :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  acts_as_tree
  has_many :items
end
