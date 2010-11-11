class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def method_missing(provider, *args)
    if !User.omniauth_providers.index(provider).nil?
      auth = env["omniauth.auth"]

      if current_user
        current_user.user_tokens.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
        flash[:notice] = "Authentication successful"
        redirect_to edit_user_registration_path
      else
        authentication = UserToken.find_by_provider_and_uid(auth['provider'], auth['uid'])
        if authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => auth['provider']
          sign_in authentication.user
          redirect_to root_url
        else
          if provider == :facebook
            @user=User.create(:email => auth['extra']['user_hash']['email'], 
                             :password => Devise.friendly_token[0, 20])
            @user.create_account!(auth['extra']['user_hash']['name'], auth['extra']['user_hash']['link'])
          end
          if provider == :google_apps
            @user = User.create(:email => auth['user_info']['email'], :password => Devise.friendly_token[0, 20])
            @user.create_account!(auth['user_info']['name'], 
                                "http://www.google.com/profiles/#{auth["user_info"]["email"].split('@').first}")
          end
          if provider == :tweeter
            ap auth
          end
          @user.user_tokens << UserToken.create(:provider => auth['provider'], :uid => auth['uid'])
          sign_in @user
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to root_url
        end
      end
    end
  end 

end
