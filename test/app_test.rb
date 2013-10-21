require './test/test_helper.rb'
require 'sinatra/base'
require 'rack/test'
require './lib/app'

class IdeaBoxAppHelper < MiniTest::Test
  include Rack::Test::Methods

  def teardown
    IdeaStore.delete_all
  end

  def app
    IdeaboxApp
  end

  def test_ideas
    IdeaStore.save Idea.new("dinner", "spaghetti and meatballs")
    IdeaStore.save Idea.new("drinks", "imported beers")
    IdeaStore.save Idea.new("movie", "the matrix")

    get '/'
    [/dinner/, /spaghetti/,
     /drinks/, /beers/,
     /movie/, /the matrix/
    ].each do |content|
      assert_match content, last_response.body
    end
  end
end
