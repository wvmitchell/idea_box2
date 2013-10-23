require './test/test_helper'
require './lib/ideabox/idea'

class IdeaTest < MiniTest::Test

  def test_basic_idea
    idea = Idea.new("title", "description")
    assert_equal "title", idea.title
    assert_equal "description", idea.description
  end

  def test_ideas_can_be_liked
    idea = Idea.new("Carrots", "Make great cake!")
    assert_equal 0, idea.rank
    idea.like!
    assert_equal 1, idea.rank
  end

  def test_ideas_can_be_sorted_by_rank
    banana = Idea.new("Bananas", "Make great bread")
    orange = Idea.new("Oranges", "Make great juice")
    dog = Idea.new("Dogs", "Make great pets")

    banana.like!
    banana.like!
    orange.like!

    ideas = [orange, banana, dog]
    assert_equal [banana, orange, dog], ideas.sort
  end

  def test_ideas_have_ids
    idea = Idea.new("Boat", "Better than swimming")
    idea.id = 1
    assert_equal 1, idea.id
  end

  def test_ideas_have_user_ids
    idea = Idea.new("Boat", "Better than swimming","love", 1)
    assert_equal 1, idea.user_id
  end

  def test_ideas_have_tags
    idea = Idea.new("Boat", "Better than swimming", 'water michigan yacht')
    assert_equal ['#water','#michigan','#yacht'], idea.tags
  end
end
