class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
  end

  def build_resource(hash = nil)
    if hash.present? && hash[:access_token].blank?
      # アクセストークン作成
      hash[:access_token] = User.generate_access_token
    end
    super
  end
end
