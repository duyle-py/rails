class Bulb < ApplicationRecord
  default_scope { where(name: "defaulty") }
  scope :awesome, -> { where(frickinawesome: true) }

  belongs_to :car
end
