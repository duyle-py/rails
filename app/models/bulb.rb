class Bulb < ApplicationRecord
  default_scope { where(name: "defaulty") }

  belongs_to :car
end
