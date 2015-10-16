class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
  end

  def build_resource(hash = nil)
    # アクセストークン作成
    hash[:access_token] = User.generate_access_token
    super
  end
end
