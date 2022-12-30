class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.text :subscriber_id, null: false

      t.timestamps
    end

    add_foreign_key :subscriptions, :subscribers, column: :subscriber_id, primary_key: :nick
  end
end
