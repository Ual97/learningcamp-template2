class AddNewRestrictionToPreferences < ActiveRecord::Migration[6.1]
  def change
    add_column :preferences, :new_restriction, :boolean, default: false, null: true
  end
end
