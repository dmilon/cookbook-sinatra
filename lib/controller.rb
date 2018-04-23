require_relative 'view'
require_relative 'recipe'
require_relative 'scrape_marmiton'


class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def list
    display_recipes
  end

  def create
    name = @view.ask_user_for("name")
    description = @view.ask_user_for("description")
    prep_time = @view.ask_user_for("preparation time")
    recipe = Recipe.new(name, description, prep_time, false)
    @cookbook.add(recipe)
    display_recipes
  end

  def destroy
    display_recipes
    index = @view.ask_user_for_index
    @cookbook.remove_at(index)
    display_recipes
  end

  def import
    keyword = @view.ask_user_for("keyword")
    @view.display("Looking for \"#{keyword}\" on Marmiton... ")
    first_five = ScrapeMarmiton.call(keyword)
    @view.display_first_five(first_five)
    index = @view.ask_user_for_index
    @view.display("Importing \"#{first_five[index][:name]}\"...")
    imported_recipe = Recipe.new(first_five[index][:name], first_five[index][:description], first_five[index][:prep_time], false, first_five[index][:difficulty])
    @cookbook.add(imported_recipe)
    display_recipes
  end

  def mark
    display_recipes
    index = @view.ask_user_for_index
    @cookbook.mark_at(index)
    display_recipes
  end

  private

  def display_recipes
    recipes = @cookbook.all
    @view.display_recipes(recipes)
  end
end
