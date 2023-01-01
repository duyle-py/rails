class Car < ApplicationRecord
  has_many :bulbs
  has_many :awesome_bulbs, -> { awesome }, class_name: "Bulb"

end
