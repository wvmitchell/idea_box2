gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/ideabox/idea'
require './lib/ideabox/idea_store'

class IdeaStoreTest < MiniTest::Test

  def teardown
    IdeaStore.delete_all
  end

  def test_save_and_retrieve_idea
    idea = Idea.new("Boat", "It's a money pit")
    id = IdeaStore.save(idea)

    assert_equal 1, IdeaStore.count

    idea = IdeaStore.find(id)
    assert_equal "Boat", idea.title
    assert_equal "It's a money pit", idea.description
  end

  def test_save_multiple_ideas
    band = Idea.new("Band", "Let's start a band")
    wagon = Idea.new("Covered", "Better than not")
    shoes = Idea.new("Feet", "Hurt without them")

    id1 = IdeaStore.save(band)
    id2 = IdeaStore.save(wagon)
    id3 = IdeaStore.save(shoes)

    idea = IdeaStore.find(id2)
    assert_equal "Covered", idea.title
    assert_equal "Better than not", idea.description
  end

  def test_update_an_idea
    band = Idea.new("Band", "Let's start a band")
    id = IdeaStore.save(band)

    idea = IdeaStore.find(id)
    idea.title = "Spam"
    idea.description = "Great with eggs"
    IdeaStore.save(idea)

    assert_equal 1, IdeaStore.count
    idea = IdeaStore.find(id)
    assert_equal "Spam", idea.title
    assert_equal "Great with eggs", idea.description
  end
end
