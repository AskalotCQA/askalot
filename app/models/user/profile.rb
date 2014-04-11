class User
  class Profile
    belongs_to :user
    belongs_to :targetable, polymorphic: true
  end
end
