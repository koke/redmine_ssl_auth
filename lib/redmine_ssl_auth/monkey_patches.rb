module RedmineSslAuth
  module MonkeyPatches
    module AccountPatch
      def login_with_ssl_auth
        if params[:force_ssl]
          if try_ssl_auth
            redirect_back_or_default :controller => 'my', :action => 'page'
            return
          else
            render_403
            return
          end
        end
        if !User.current.logged? and not params[:skip_ssl]
          if try_ssl_auth
            redirect_back_or_default :controller => 'my', :action => 'page'
            return
          end
        end
                
        login_without_ssl_auth
      end
      
      module InstanceMethods
        def try_ssl_auth
          session[:email] = request.env["SSL_CLIENT_S_DN_CN"]
          if session[:email]
            user = User.find_by_mail(session[:email])
            # TODO: try to register on the fly
            unless user.nil?
              # Valid user
              return false if !user.active?
              user.update_attribute(:last_login_on, Time.now) if user && !user.new_record?
              self.logged_user = user
              return true
            end
          end
          false
        end
      end
      
      def self.included(base)
        base.class_eval do
          alias_method_chain :login, :ssl_auth
          include RedmineSslAuth::MonkeyPatches::AccountPatch::InstanceMethods
        end
      end      
    end
    AccountController.send(:include, AccountPatch)
  end
end