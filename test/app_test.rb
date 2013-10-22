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

  def test_create_idea
    post '/', title: 'costume', description: 'scary vampire'
    assert_equal 1, IdeaStore.count

    idea = IdeaStore.all.first
    assert_equal 'costume', idea.title
    assert_equal 'scary vampire', idea.description
  end

  def test_edit_idea
    id = IdeaStore.save Idea.new("Pizza", "Slam it down")

    put "/#{id}", {title: "Pizza", description: "So round"}

    assert 302, last_response.status
    idea = IdeaStore.find(id.to_i)
    assert_equal "So round", idea.description
  end

  def test_edit_idea
    id = IdeaStore.save Idea.new("Pizza", "Slam it down")

    delete "/#{id}"
    assert 302, last_response.status

    refute IdeaStore.find(id)
  end
end
