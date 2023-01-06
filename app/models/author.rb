class Author < ApplicationRecord
  has_many :posts
  has_many :essays
  has_many :essays_2, class_name: "Essay", foreign_key: :writer_id, as: :writer
  has_many :popular_grouped_posts, -> { group("type").having("SUM(legacy_comments_count) > 1").select("type") }, class_name: :Post

end
