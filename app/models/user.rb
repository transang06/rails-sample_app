class MyValidator < ActiveModel::Validator
  def validate record
    user = User.find_by email: record.email
    return unless user&.authenticate record.password

    record.errors.add :password, :old_password
  end
end

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  attr_accessor :remember_token
  include ActiveModel::Validations
  validates_with MyValidator
  validates :name, presence: true,
    length: {maximum: Settings.validation.name_max}
  validates :email, presence: true,
    length: {maximum: Settings.validation.email_max},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true, length:
    {minimum: Settings.validation.pass_min}, allow_nil: true
  has_secure_password
  before_save{email.downcase!}

  scope :latest, ->{order(created_at: :desc)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end
end
