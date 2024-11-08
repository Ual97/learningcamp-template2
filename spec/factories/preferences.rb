# == Schema Information
#
# Table name: preferences
#
#  id              :bigint           not null, primary key
#  name            :string
#  description     :text
#  restriction     :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#  new_restriction :boolean          default(FALSE)
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
FactoryBot.define do
  factory :preference do
    name { "MyString" }
    description { "MyText" }
    restriction { false }
  end
end
