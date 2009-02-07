class AccountController < ApplicationController
  before_filter :invoke_monkey_patches
  unloadable 
  protected
  def invoke_monkey_patches
    RedmineSslAuth::MonkeyPatches
  end
end
