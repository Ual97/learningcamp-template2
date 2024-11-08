# frozen_string_literal: true

require 'rails_helper'

describe 'Preferences' do
  describe 'GET index' do
    subject { get preferences_path }

    context 'when logged in' do
      let!(:user) { create(:user) }
      let!(:preference) { create(:preference, user: user) }

      before { sign_in user }

      it 'has http status 200' do
        expect(subject).to eq(200)
      end

      it 'assigns user preferences' do
        subject
        expect(assigns(:preferences)).to eq([preference])
      end
    end
  end

  describe 'GET new' do
    subject { get new_preference_path }

    context 'when logged in' do
      let!(:user) { create(:user) }

      before { sign_in user }

      it 'has http status 200' do
        expect(subject).to eq(200)
      end

      it 'assigns a new preference' do
        subject
        expect(assigns(:preference)).to be_a_new(Preference)
      end
    end
  end

  describe 'POST create' do
    subject { post preferences_path, params: params }

    let(:params) { {} }

    context 'when logged in' do
      let!(:user) { create(:user) }

      before { sign_in user }

      context 'when success' do
        let(:params) do
          {
            preference: {
              name: 'Test Preference',
              description: 'This is a test preference',
              restriction: true
            }
          }
        end

        it 'creates a preference' do
          expect { subject }.to change(Preference, :count).by(1)
        end

        it 'redirects to preferences index' do
          expect(subject).to redirect_to(preferences_path)
        end

        it 'has http status 302' do
          expect(subject).to eq(302)
        end
      end

      context 'when fails' do
        let(:params) do
          {
            preference: {
              name: '',
              description: 'This is a test preference',
              restriction: true
            }
          }
        end

        it 'renders the new template' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a preference' do
          expect { subject }.not_to change(Preference, :count)
        end
      end
    end
  end

  describe 'GET show' do
    subject { get preference_path(preference) }

    let!(:user) { create(:user) }
    let!(:preference) { create(:preference, user: user) }

    context 'when logged in' do
      before { sign_in user }

      it 'has http status 200' do
        expect(subject).to eq(200)
      end

      it 'assigns the requested preference' do
        subject
        expect(assigns(:preference)).to eq(preference)
      end
    end
  end
end
