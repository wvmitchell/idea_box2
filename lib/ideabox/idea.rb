class Idea
  include Comparable
  attr_reader :rank
  attr_accessor :title, :description, :id

  def initialize(title, description)
    @title = title
    @description = description
    @rank = 0
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> @rank
  end
end
