class CreateSubscribers < ActiveRecord::Migration[7.0]
  def change
    create_table :subscribers, id: false do |t|
      t.primary_key :nick, :text
      t.text :name
      t.timestamps
    end
  end
end
