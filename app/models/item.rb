# == Schema Information
# Schema version: 20110323183145
#
# Table name: items
#
#  id          :integer         not null, primary key
#  category_id :integer
#  name        :string(255)
#  description :string(255)
#  cost        :decimal(, )
#  created_at  :datetime
#  updated_at  :datetime
#

class Item < ActiveRecord::Base
end
