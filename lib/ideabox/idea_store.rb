class IdeaStore

  def self.save(idea)
    @all ||= []
    idea.id = idea.id || next_id
    all[idea.id] = idea
    idea.id
  end

  def self.count
    all.count
  end

  def self.find(id)
    all[id]
  end

  def self.next_id
    all.size
  end

  def self.delete(id)
    all.delete_if {|idea| idea.id == id}
  end

  def self.delete_all
    @all = []
  end

  def self.all
    @all
  end

  def self.find_by_title(title)
    all.find {|idea| idea.title == title}
  end
end
