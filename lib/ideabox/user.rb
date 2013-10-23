class User
  attr_reader :username, :email, :password
  attr_accessor :id

  def initialize(username, email, password)
    @username = username
    @email = email
    @password = password
  end
end
