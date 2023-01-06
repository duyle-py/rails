class Post < ApplicationRecord
  belongs_to :author

  has_many :taggings, as: :taggable

  scope :tagged_with, ->(id) { joins(:taggings).where(taggings: { tag_id: id }) }
end

class SpecialPost < Post; end
class StiPost < Post; end