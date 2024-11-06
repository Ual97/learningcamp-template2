# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = current_user.recipes
    @pagy, @records = pagy(@recipes)
  end

  def new
    @recipe = Recipe.new
  end

  def create
    recipe_service = RecipeGeneratorService.new(recipe_params[:ingredients], current_user.id)

    begin
      generated_recipe = recipe_service.call

      redirect_to recipes_path, notice: 'Recipe was successfully created.'
    rescue RecipeGeneratorServiceError => e
      flash[:alert] = "Error generating recipe: #{e.message}"
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :ingredients)
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
