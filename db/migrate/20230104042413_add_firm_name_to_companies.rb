class AddFirmNameToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :firm_name, :text
  end
end
