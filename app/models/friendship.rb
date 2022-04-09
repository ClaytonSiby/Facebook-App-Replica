class Friendship < ApplicationRecord
  belongs_to :sent_to
  belongs_to :sent_by

  scope :friends, -> { where('status =?', true) }
  scope :not_friends, -> { where('status =?', true) }
end
