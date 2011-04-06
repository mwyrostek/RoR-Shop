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
  belongs_to :category
  has_attached_file :image,
                    :default_url => "/images/missing.png",
                    :styles => { :small => "150x150>", :medium => "400x400" },
                    :url => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
                    
  before_validation :clear_image
  
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']
  
  def delete_image=(value)
    @delete_image = !value.to_i.zero?
  end
  
  def delete_image
    @delete_image
  end
  alias_method :delete_image?, :delete_image
  
private
  def clear_image
    self.image = nil if delete_image? && !image.dirty?
  end
end
