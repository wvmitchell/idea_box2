require './lib/ideabox'

class IdeaboxApp < Sinatra::Base

  set :root, './lib/app'
  set :method_override, true
  set :session_secret, ENV["SESSION_KEY"] || 'too secret'

  use OmniAuth::Strategies::Twitter, 'yOzawkZFc3guCESz9Vmpig', 'kn3vHM3YKTdLjdfujki1xaLoE8fqSVDT5VR58iFYVFU'

  enable :sessions

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end

  get '/' do
    #erb :index, locals: {ideas: (IdeaStore.all|| []).sort, session: session}
    if current_user
      erb :index, locals: {ideas: (IdeaStore.all || []).sort, current_user: current_user}
    else
      '<a href="/sign_up">create an account</a> or <a href="/sign_in">sign in with Twitter</a>'
      erb :index, locals: {ideas: (IdeaStore.all || []).sort}
    end
  end

  get '/auth/:name/callback' do
    auth = request.env["omniauth.auth"]
    user = User.first_or_create({ :uid => auth["uid"]}, {
      :uid => auth["uid"],
      :nickname => auth["info"]["nickname"],
      :name => auth["info"]["name"],
      :created_at => Time.now})
    session[:user_id] = user.id
    redirect '/'
  end

  ["/sign_in/?", "/signin/?", "/log_in/?", "/login/?", "/sign_up/?", "/signup/?"].each do |path|
    get path do
      redirect '/auth/twitter'
    end
  end

  ["/sign_out/?", "/signout/?", "/log_out/?", "/logout/?"].each do |path|
    get path do
      session[:user_id] = nil
      redirect '/'
    end
  end

  post '/' do
    IdeaStore.save Idea.new(params[:title], params[:description], params[:tags])
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

 end
