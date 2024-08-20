class Contact < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :user
  has_many :todos, as: :todoable
  has_many :notes, as: :noteable
  has_many :events, through: :event_contacts
end
