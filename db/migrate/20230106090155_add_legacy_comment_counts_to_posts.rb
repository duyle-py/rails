class AddLegacyCommentCountsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :legacy_comments_count, :integer
  end
end
