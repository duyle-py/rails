class AddFirmToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_reference :companies, :firm, type: :integer, null: true, foreign_key: { to_table: :companies }
  end
end
