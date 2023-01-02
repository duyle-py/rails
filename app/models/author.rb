class Author < ApplicationRecord
  has_many :posts
  has_many :essays
  has_many :essays_2, class_name: "Essay", foreign_key: :writer_id, as: :writer
end
