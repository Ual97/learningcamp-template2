# frozen_string_literal: true

class RecipeGeneratorService
  attr_reader :message, :user

  OPENAI_TEMPERATURE = ENV.fetch('OPENAI_TEMPERATURE', 0).to_f
  OPENAI_MODEL = ENV.fetch('OPENAI_MODEL', 'gpt-3.5-turbo-1106')

  def initialize(message, user_id)
    @message = message
    @user = User.find(user_id)
  end

  def call
    check_valid_message_length
    response = message_to_chat_api
    create_recipe(response)
  end

  private

  def check_valid_message_length
    error_msg = I18n.t('api.errors.invalid_message_length')
    raise RecipeGeneratorServiceError, error_msg unless !!(message =~ /\b\w+\b/)
  end

  def message_to_chat_api
    response = openai_client.chat(parameters: {
                                   model: OPENAI_MODEL,
                                   messages: request_messages,
                                   temperature: OPENAI_TEMPERATURE
                                 })
  end

  def request_messages
    system_message + new_message
  end

  def system_message
    [{ role: 'system', content: prompt }]
  end

  def prompt
    <<~CONTENT
      You are a chef assistant designed to create recipes given a certain list of ingredients people may have in their homes, you are expected to send a JSON in the response with the following format: 
      {
        "name": "Dish Name",
        "content": ""
      }
      Please respond with the recipe details in Spanish.
    CONTENT
  end

  def new_message
    [
      { role: 'user', content: "Ingredients: #{message}" }
    ]
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new
  end

  def create_recipe(response)
  
    # Parseo la response en el formato JSON
    recipe_data_str = response.dig('choices', 0, 'message', 'content')
  
    # Checkeo que la response no este vacia
    if recipe_data_str.blank?
      raise RecipeGeneratorServiceError, 'Recipe content is empty.'
    end
  
    # Parseo el contenido JSON dentro de la cadena
    begin
      recipe_data = JSON.parse(recipe_data_str)
    rescue JSON::ParserError => e
      raise RecipeGeneratorServiceError, "Failed to parse recipe content: #{e.message}"
    end
  
    # Asigno a una variable el nombre y el contenido de la respuesta que obtengo de la API call
    name = recipe_data['name']
    content = recipe_data['content']
  
    # Checkeo que tanto el nombre como el contenido no sean vacíos
    if name.blank? || content.blank?
      raise RecipeGeneratorServiceError, 'Invalid recipe data: Name or content is missing.'
    end
  
    # Creo la receta con los valores obtenidos y el id del usuario actualmente loggeado
    recipe = Recipe.new(
      name: name,
      description: content,
      ingredients: message,
      user_id: user.id
    )
  
    if recipe.save
      return recipe
    else
      raise RecipeGeneratorServiceError, 'Failed to create recipe.'
    end
  end  
end
