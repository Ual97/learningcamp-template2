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
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      redirect_to recipes_path, notice: 'Recipe was successfully created.'
    else
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
