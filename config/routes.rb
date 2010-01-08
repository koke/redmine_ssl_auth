ActionController::Routing::Routes.draw do |map|
  map.ssl_login 'login/ssl', :controller => 'account', :action => 'login', :force_ssl => true
end
