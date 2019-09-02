class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,  :confirmable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable
 include DeviseTokenAuth::Concerns::User
 mount_uploader :image, AvatarUploader

 validates :name, presence: true
 validates :email, presence: true, uniqueness: { case_sensitive: false }
end
