class UserStore

  def self.delete_all
    @all = []
  end

  def self.delete(id)
    all.delete_if {|user| user.id == id.to_i}
  end

  def self.save(user)
    id = next_id
    user.id = id
    all << user
    @created_users += 1
    id
  end

  def self.next_id
    @created_users ||= 0
  end

  def self.all
    @all ||= []
  end

  def self.find(id)
    all.find {|user| user.id == id.to_i}
  end
end
