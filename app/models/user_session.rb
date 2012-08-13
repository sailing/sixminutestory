class UserSession < Authlogic::Session::Base
  
  find_by_login_method :find_by_login_or_email
  
  # rpx_key RPX_API_KEY
  # rpx_extended_info
  
end