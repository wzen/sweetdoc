class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = nil)
    if hash.present?
      if hash[:access_token].blank?
        # アクセストークン作成
        hash[:access_token] = User.generate_access_token
      end
      if hash[:user_auth_id].blank?
        # 一般会員として作成
        hash[:user_auth_id] = 2
      end
    end
    super
  end
end
