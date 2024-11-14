# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  ingredients :text
#  user_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    subject { build(:recipe) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:ingredients) }
  end

  describe 'creation' do
    let(:user) { create(:user) }

    context 'with valid attributes' do
      it 'is valid with all attributes' do
        recipe = build(:recipe, user: user)
        expect(recipe).to be_valid
      end
    end

    context 'without a name' do
      it 'is invalid' do
        recipe = build(:recipe, name: nil, user: user)
        expect(recipe).not_to be_valid
        expect(recipe.errors[:name]).to include("can't be blank")
      end
    end

    context 'without a description' do
      it 'is invalid' do
        recipe = build(:recipe, description: nil, user: user)
        expect(recipe).not_to be_valid
        expect(recipe.errors[:description]).to include("can't be blank")
      end
    end

    context 'without ingredients' do
      it 'is invalid' do
        recipe = build(:recipe, ingredients: nil, user: user)
        expect(recipe).not_to be_valid
        expect(recipe.errors[:ingredients]).to include("can't be blank")
      end
    end
  end
end