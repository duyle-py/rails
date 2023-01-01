class Person < ApplicationRecord
  has_many :essays, foreign_key: "writer_id"
end
