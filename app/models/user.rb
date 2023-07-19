# frozen_string_literal: true

class User < ApplicationRecord
  # Associations
  # belongs_to :address
  # has_one :customer
  # has_one :event_organizer
  # has_many :events

  # Devise module for user authentication
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  before_validation :convert_birthdate_format
  before_validation :downcase_fields
  before_validation :format_names

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :birthdate, presence: true, date: { before: proc {
                                                          Date.tomorrow
                                                        }, message: "cannot be in the future", format: "%d/%m/%Y" }
  validates :firstname, :lastname, presence: true,
                                   format: { with: /\A[a-zA-Z\s'-]+\z/, message: "should only contain letters, spaces, hyphens, and apostrophes" }
  validates :username, uniqueness: true, presence: true, length: { in: 6..15 },
                       format: { with: /\A[a-zA-Z0-9_.]+\z/, message: "should only contain letters and numbers" }

  validate :above_majority_age
  validate :username_not_all_the_same

  private

  def convert_birthdate_format
    self.birthdate = Date.strptime(birthdate, "%d/%m/%Y") if birthdate.present? && birthdate.is_a?(String)
  rescue ArgumentError
    errors.add(:birthdate, "is invalid")
  end

  def above_majority_age
    return unless birthdate && ((Date.current - birthdate.to_date) / 365.25).to_i < 18

    errors.add(:birthdate, "must be at least 18 years old")
  end

  def username_not_all_the_same
    return unless username.present? && username.chars.uniq.length == 1 && !username.chars.include?(".")

    errors.add(:username, "cannot be all the same character")
  end

  def downcase_fields
    self.email = email.downcase if email.present?
    self.username = username.downcase if username.present?
  end

  def format_names
    self.firstname = firstname.titleize if firstname.present?
    self.lastname = lastname.titleize if lastname.present?
  end
end
