module UserConcern
  module Utils
    def generate_user_access_token
      SecureRandom.urlsafe_base64(20)
    end

    def new_guest_user
      new do |u|
        u.name = "Guest"
        u.email    = "guest_#{Time.now.to_i}#{rand(100)}@example.com"
        u.encrypted_password = [*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
        u.guest    = true
        u.access_token = generate_user_access_token
      end
    end

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create(
            access_token: generate_user_access_token,
            name:     auth.extra.raw_info.name,
            user_auth_id: 2,
            provider: auth.provider,
            uid:      auth.uid,
            email:    dummy_email(auth),
            provider_token:    auth.credentials.token,
            password: Devise.friendly_token[0,20],
            encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
        )
      end
      return user
    end

    def find_for_twitter_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create(
            access_token: generate_user_access_token,
            name:     auth.info.nickname,
            user_auth_id: 2,
            provider: auth.provider,
            uid:      auth.uid,
            email:    dummy_email(auth),
            provider_token:    auth.credentials.token,
            password: Devise.friendly_token[0,20],
            encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
        )
      end
      return user
    end

    def find_for_google_oauth2(auth)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create(
            access_token: generate_user_access_token,
            name:     auth.info.name,
            user_auth_id: 2,
            provider: auth.provider,
            uid:      auth.uid,
            email:    dummy_email(auth),
            provider_token:    auth.credentials.token,
            password: Devise.friendly_token[0, 20],
            encrypted_password:[*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
        )
      end
      return user
    end

    private
    def dummy_email(auth)
      #email = auth.info.email
      email = "#{auth.provider}-#{auth.uid}@example.com"
      return email
    end

  end
end