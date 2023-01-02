class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.text :type
      t.integer :client_of
      t.text :name

      t.timestamps
    end
  end
end
