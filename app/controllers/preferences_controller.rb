# frozen_string_literal: true

class PreferencesController < ApplicationController
  before_action :set_preference, only: %i[edit update show destroy]

  def index
    @preferences = current_user.preferences
    @pagy, @records = pagy(@preferences)
  end

  def new
    @preference = Preference.new
  end

  def create
    @preference = current_user.preferences.build(preference_params)

    if @preference.save
      redirect_to preferences_path, notice: 'Preference was successfully created.'
    else
      render :new
    end
  end

  def show; end

  private

  def preference_params
    params.require(:preference).permit(:name, :description, :restriction)
  end

  def set_preference
    @preference = Preference.find(params[:id])
  end
end