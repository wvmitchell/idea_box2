require './test/test_helper.rb'
require 'bundler'
Bundler.require
require 'rack/test'
require 'capybara'
require 'capybara/dsl'

require './lib/app'

Capybara.app = IdeaboxApp

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers => {'User-Agent' => 'Capybara'})
end

class IdeaManagementTest < Minitest::Test
  include Capybara::DSL

  def teardown
    IdeaStore.delete_all
  end

  def test_manage_ideas
    # Create decoy ideas
    # So we know we're editing the right idea later
    IdeaStore.save Idea.new("Toast", "It's really just bread")
    IdeaStore.save Idea.new("Tacos", "Original mexico")
    # Make sure decoys are present
    visit '/'
    assert page.has_content?('Toast'), "Idea is not on page"
    assert page.has_content?("Tacos"), "Idea is not on page"

    # Create an Idea
    visit '/'
    fill_in 'title', :with => 'eat'
    fill_in 'description', :with => 'chocolate chip cookies'
    click_button 'Save'
    assert page.has_content?('chocolate chip cookies'), "Idea is not on page"


    # Edit the Idea
    idea = IdeaStore.find_by_title('eat')
    within("#idea_#{idea.id}") do
      click_link 'Edit'
    end

    # Edit page has fields already filled
    assert_equal 'eat', find_field('title').value
    assert_equal 'chocolate chip cookies', find_field('description').value

    fill_in 'description', :with => 'macadamian nut cookies'
    click_button 'Save'

    # Idea has been updated
    assert page.has_content?('macadamian nut cookies'), "Idea not updated"

    # Dummy ideas have not changed
    assert page.has_content?('Toast'), "Dummy idea is not on page"
    assert page.has_content?("Tacos"), "Dummy idea is not on page"

    # Old idea is not present
    refute page.has_content?('chocolate chip cookies'), "Old idea still present"

    # Delete the Idea
    within("#idea_#{idea.id}") do
      click_button 'Delete'
    end

    # Idea deleted and dummies still present
    refute page.has_content?('macadamian nut cookies'), "Idea not deleted"
    assert page.has_content?('Toast'), "Dummy idea is not on page"
    assert page.has_content?("Tacos"), "Dummy idea is not on page"
  end

  def test_ranking_ideas
    id1 = IdeaStore.save Idea.new("Bread", "Need yeast")
    id2 = IdeaStore.save Idea.new("Tacos", "Need meat")
    id3 = IdeaStore.save Idea.new("Table", "Need wood")

    visit '/'

    idea = IdeaStore.find(id2)
    idea.like!
    idea.like!
    idea.like!
    idea.like!
    idea.like!
    IdeaStore.save(idea)

    within("#idea_#{id2}") do
      3.times do
        click_button '+'
      end
    end

    within("#idea_#{id3}") do
      click_button '+'
    end

    ideas = page.all('li')
    assert_match /Need meat/, ideas[0].text
    assert_match /Need wood/, ideas[1].text
    assert_match /Need yeast/, ideas[2].text
  end
end
