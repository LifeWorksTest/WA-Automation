# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidStartPage < Calabash::ABase
  BTN_SIGN_UP = "AppCompatTextView id:'activity_prelogin_button_invitation_code'" 
  BTN_LOGIN = "AppCompatTextView id:'activity_prelogin_button_login'"
  BTN_CONTINUE = "AppCompatButton id:'dictionary_invitation_code_button_continue'"

  TXF_INVITATION_CODE = "TextInputEditText"

  def trait
    BTN_SIGN_UP
  end

  def click_button (button)
    case button
    when 'Login'  
      wait_for(10){element_exists(BTN_LOGIN)}
      touch(BTN_LOGIN)
      wait_for(10){element_does_not_exist(BTN_LOGIN)}
    when 'SIGN UP'
      wait_for(10){element_exists(BTN_SIGN_UP)}
      touch(BTN_SIGN_UP)
      wait_for(10){element_does_not_exist(BTN_SIGN_UP)}
      wait_for(30){element_exists(TXF_INVITATION_CODE)}
    when 'CONTINUE'
      wait_for(10){element_exists(BTN_SIGN_UP)}
      touch(BTN_SIGN_UP)
      wait_for(10){element_does_not_exist(BTN_SIGN_UP)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end
  
  # Set environment
  def set_env 
    wait_for(30){element_exists("* id:'activity_login_environment_spinner'")}
    touch("* id:'activity_login_environment_spinner'")
    wait_for(30){element_exists("* marked:'#{ENV_LOWCASE}'")}
    touch("* marked:'#{ENV_LOWCASE}'")
    sleep(3)
  end

  # Insert invitation code
  # @param code - invitation code
  def insert_code (code)
    click_button('SIGN UP')
    enter_text(TXF_INVITATION_CODE, code)
    click_button('CONTINUE')
  end

end
