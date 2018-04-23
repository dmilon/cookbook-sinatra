require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "lib/cookbook"
require_relative "lib/recipe"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

# set :bind, '0.0.0.0'

csv_file   = File.join(__dir__, 'lib/recipes.csv')
cookbook   = Cookbook.new(csv_file)

get "/" do
  @cookbook = cookbook
  erb :index
end
get "/new" do
  erb :new
end
post '/recipes' do
  name = params["name"]
  description = params["description"]
  prep_time = params["prep_time"]
  done = params["done"]
  difficulty = params["difficulty"]
  @cookbook = cookbook
  new_recipe = Recipe.new(name, description, prep_time, done, difficulty)
  @cookbook.add(new_recipe)
  erb :index
end
get '/destroy:index' do
  @cookbook = cookbook
  @cookbook.remove_at(params["index"].to_i)
  erb :index
end
get '/import' do
  erb :import
end
post '/import:keyword' do
  first_five = ScrapeMarmiton.call(params["keyword"])
end
