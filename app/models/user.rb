class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  def admin?
    self.admin
end
  has_many :posts  # A user can have many posts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end


