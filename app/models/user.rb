class User < ApplicationRecord

  enum role: [:admin, :user]

  has_one_attached :avatar

  validates :name, presence: true, on: :update
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :posts, dependent: :destroy
    has_many :reacts, dependent: :destroy
    has_many :comments, dependent: :destroy


end

