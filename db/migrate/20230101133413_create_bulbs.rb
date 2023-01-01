class CreateBulbs < ActiveRecord::Migration[7.0]
  def change
    create_table :bulbs do |t|
      t.references :car, null: true, foreign_key: true
      t.text :name
      t.timestamps
    end
  end
end
