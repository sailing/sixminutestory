module LoginSpecHelpers
  def login_admin(admin = nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    admin ||= FactoryBot.create(:user, :admin)

    sign_in admin
  end

  def login_user(user = nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user ||= FactoryBot.create(:user)
    sign_in user
  end
end