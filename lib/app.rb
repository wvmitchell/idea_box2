require 'bundler'
Bundler.require
require './lib/ideabox'

class IdeaboxApp < Sinatra::Base

  set :root, './lib/app'

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all || []}
  end

  run! if app_file == $0
end
