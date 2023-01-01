class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.text :first_name

      t.timestamps
    end
  end
end
