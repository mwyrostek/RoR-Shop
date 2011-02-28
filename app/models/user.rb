# == Schema Information
# Schema version: 20110226190243
#
# Table name: users
#
#  id              :integer         not null, primary key
#  login           :string(255)
#  hashed_password :string(255)
#  email           :string(255)
#  salt            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  admin           :boolean
#

require 'digest'

class User < ActiveRecord::Base
  validates :login, :length => { :within => 3..40 },
                    :presence => true,
                    :uniqueness => true
  validates :email, :presence => true,
                    :uniqueness => true,
                    :format => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, :length => { :within => 4..40 },
                       :presence => true,
                       :confirmation => true,
                       :if => :password_required?
  
  attr_protected :id, :salt
  attr_accessor :password
  attr_accessible :login, :email, :password
  
  before_save :encrypt_password
  
  def authenticate?(pass)
    self.hashed_password == encrypt(pass, self.salt)
  end
  
  def self.authenticate(login, pass)
    user = find_by_login(login)
    (user && user.authenticate?(pass)) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  protected
  
  def encrypt_password
    return if password.blank?
    salt_length = 10
    self.salt = random_string(salt_length) if new_record?
    self.hashed_password = encrypt(@password, self.salt)
  end
  
  def encrypt(pass, salt)
    Digest::SHA2.hexdigest(pass + salt)
  end
  
  def random_string(length)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(length) { |i| str << chars[rand(chars.size-1)] }
    return str
  end
  
  def password_required? 
    hashed_password.blank? || password.present? 
  end 
end
