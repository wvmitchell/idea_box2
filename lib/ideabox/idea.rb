class Idea
  include Comparable
  attr_reader :rank, :user_id
  attr_accessor :title, :description, :id

  def initialize(title, description, user_id=nil)
    @title = title
    @description = description
    @rank = 0
    @user_id = user_id
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> @rank
  end
end
