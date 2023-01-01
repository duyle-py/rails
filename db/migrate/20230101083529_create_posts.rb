class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :author, null: false, foreign_key: true
      t.text :title
      t.text :body

      t.timestamps
    end
  end
end
