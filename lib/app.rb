require './lib/ideabox'

class IdeaboxApp < Sinatra::Base

  set :root, './lib/app'
  set :method_override, true
  set :session_secret, ENV["SESSION_KEY"] || 'too secret'

  enable :sessions

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end

  get '/' do
    erb :index, locals: {ideas: (IdeaStore.all|| []).sort}
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

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.save(idea)
    redirect '/'
  end

  get '/new_user/' do
    erb :new_user
  end

  post '/new_user/' do
    UserStore.save User.new(params[:username], params[:email], params[:password])
    redirect '/'
  end

  get '/login/' do
    erb :login
  end

  post '/login/' do
    user = UserStore.find_by_username(params[:username])
    password = Digest::MD5.digest(params[:password])
    if user && user.password == password
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/'
    end
  end
end
