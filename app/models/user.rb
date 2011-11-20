class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :roles
  has_secure_password   # password accessible, pw validation, authentication fn using the user.password_digest field
  validates_uniqueness_of :email
  validates_presence_of :password, :on => :create

  # only add new roles to the end of the array
  ROLES = %w[admin moderator author]

  # User.with_role("author")
  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0"} }

  # Convenience methods for asking if a user has a given role (i.e. user.admin?, user.moderator?, etc)
  ROLES.each{|r| define_method("#{r}?") { role?(r) } }

  def guest?
    roles.empty?
  end

  # http://railscasts.com/episodes/189-embedded-association
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map{ |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject{|r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end
  
  def role?(role)
    roles.include?(role.to_s)
  end

  def role_symbols
    roles.map(&:to_sym)
  end

end

