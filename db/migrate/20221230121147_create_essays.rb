class CreateEssays < ActiveRecord::Migration[7.0]
  def change
    create_table :essays do |t|
      t.references :author, null: true, foreign_key: true
      t.text :name

      t.timestamps
    end


  end
end
