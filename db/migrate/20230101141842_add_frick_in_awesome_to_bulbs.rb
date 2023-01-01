class AddFrickInAwesomeToBulbs < ActiveRecord::Migration[7.0]
  def change
    add_column :bulbs, :frickinawesome, :boolean, default: false
  end
end
