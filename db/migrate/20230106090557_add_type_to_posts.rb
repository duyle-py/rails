class AddTypeToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :type, :text
  end
end
