class AddDefaultRestriction < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
    change_table :preferences do |t|
      change_column :preferences, :restriction, :boolean, default: false
    end
    end
  end
end
