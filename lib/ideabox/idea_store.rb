class IdeaStore
  def self.save(idea)
    @all ||= []
    idea.id = idea.id || next_id
    @all[idea.id] = idea
    idea.id
  end

  def self.count
    @all.count
  end

  def self.find(id)
    @all[id]
  end

  def self.next_id
    @all.size
  end

  def self.delete_all
    @all = []
  end
end
