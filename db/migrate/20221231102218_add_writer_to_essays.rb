class AddWriterToEssays < ActiveRecord::Migration[7.0]
  def change
    add_column :essays, :writer_id, :integer
    add_index :essays, :writer_id
    add_column :essays, :writer_type, :text
  end
end
