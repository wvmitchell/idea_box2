require './lib/ideabox'

class IdeaboxApp < Sinatra::Base

  set :root, './lib/app'
  set :method_override, true

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all || []}
  end

  post '/' do
    IdeaStore.save Idea.new(params[:title], params[:description])
    redirect '/'
  end

  get '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.title = params[:title]
    idea.description = params[:description]
    IdeaStore.save(idea)
    redirect '/'
  end

  delete "/:id" do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end
end
