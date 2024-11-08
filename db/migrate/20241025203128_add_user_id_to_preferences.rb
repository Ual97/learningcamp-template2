class AddUserIdToPreferences < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_reference :preferences, :user, null: false, index: {algorithm: :concurrently}
  end
end
