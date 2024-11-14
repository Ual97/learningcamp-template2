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
# frozen_string_literal: true

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

describe Preference do
  describe 'validations' do
    subject { build(:preference) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    context 'with maximum number of preferences' do
      let(:user) { create(:user) }

      before do
        create_list(:preference, Preference::MAX_PREFERENCES, user: user)
      end
      it 'does not allow more than MAX_PREFERENCES preferences for a user' do
        new_preference = build(:preference, user: user)
        expect(new_preference.save).to be_falsey
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe '.for_user' do
    let(:user) { create(:user) }
    let!(:preference) { create(:preference, user: user) }

    it 'returns preferences belonging to the user' do
      expect(Preference.where(user_id: user.id)).to include(preference)
    end
  end
end

