class Idea
  include Comparable
  attr_reader :rank, :user_id, :tags
  attr_accessor :title, :description, :id

  def initialize(title, description, tags=nil, user_id=nil)
    @title = title
    @description = description
    @rank = 0
    @user_id = user_id
    @tags = tags ? format_tags(tags) : nil
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> @rank
  end

  def format_tags(tags)
    tags.split.map {|tag| '#'+tag}
  end
end
