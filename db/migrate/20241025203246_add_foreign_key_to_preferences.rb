class AddForeignKeyToPreferences < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :preferences, :users, validate: false
  end
end
