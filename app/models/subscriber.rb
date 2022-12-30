class Subscriber < ApplicationRecord
  self.primary_key = "nick"
  has_many :subscriptions
end
