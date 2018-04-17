# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidLoginPage < Calabash::ABase
  BTN_CONTINUE = "* id:'activity_login_button_continue''"
  BTN_FORGOT_PASSWORD = "* marked:'Forgotten Password?'"
  BTN_SKIP = "AppCompatTextView id:'view_walkthrough_cancel_text_view'"
  BTN_CANCEL = "MDButton id:'buttonDefaultNegative'"
  BTN_OK = "MDButton marked:'buttonDefaultPositive'"
  BTN_LATER = "android.widget.Button id:'fragment_carousel_wellbeing_skip_button'"

  TXF_USER_NAME = "android.widget.EditText index:0"
  TXF_PASSWORD = "android.widget.EditText index:1"
  TXV_SHOP_SAVE = "TextView marked:'Shop & Save'"
  TXV_TO_RESET_PASSWORD = "TextView marked:'To reset your password, please enter your registered email address.'"
  TXV_RESET_PASSWORD_CONFIRMATION = "* marked:'An email has been sent with a reset link. Please check your email to continue with the reset.'"
  
  def trait
    BTN_CONTINUE
  end

  def login_to_wam (email, password)
    if email != nil
      touch(TXF_USER_NAME)
      enter_text(TXF_USER_NAME, email)
    end

    touch(BTN_CONTINUE)
    sleep(1)

    if password != nil
      touch(TXF_PASSWORD)
      enter_text(TXF_PASSWORD, password)
    end
    
    touch(BTN_CONTINUE)
    sleep(2)

    if element_exists("TextView marked:'Please check if your work email address is completed correctly'")
      return

    elsif element_exists("TextView marked:'Verify email address or password'")
      return

    elsif element_exists("TextView marked:'Your network is unavailable'")
      return

    elsif element_exists("TextView marked:'Your account has been deactivated.'")
      return
    else
      click_button ('Skip')
      # To skip the wellbing content for the first user login in the app
      if element_exists(BTN_LATER)
        click_button('Do Later')
      end
      
    end
  end

  def swipe (direction) 
    if (direction == 'left')
      performAction('drag', 50, 0, 50, 50, 20)
    else
      performAction('drag', 0, 50, 50, 50, 20)
    end

    sleep(0.8)
  end
      
  def click_button (button)
    case button
    when 'Cancel'
      wait_for(10){element_exists(BTN_CANCEL)}
      touch(BTN_CANCEL)
      wait_for(10){element_does_not_exist(BTN_CANCEL)}
    when 'Forgot Password'
      wait_for(10){element_exists(BTN_FORGOT_PASSWORD)}
      touch(BTN_FORGOT_PASSWORD)
      wait_for(10){element_exists(BTN_CANCEL)}
    when 'OK'
      wait_for(10){element_exists(BTN_OK)}
      touch(BTN_OK)
      sleep(0.5)
    when 'Skip'
      wait_for(10){element_exists(BTN_SKIP)}
      touch(BTN_SKIP)
      # wait_for(10){element_does_not_exist(BTN_SKIP)}
      sleep(0.5)
    when "Let's go"
      wait_for(10){element_exists(BTN_LETS_GO)}
      touch(BTN_LETS_GO)      
      wait_for(10){element_does_not_exist(BTN_LETS_GO)}
    when 'Back'
      press_back_button
      sleep(0.5)
    when 'Continue'
      wait_for(10){element_exists(BTN_CONTINUE)}
      touch(BTN_CONTINUE)
      sleep(0.5)
    when 'Do Later'
      wait_for(10){element_exists(BTN_LATER)}
      touch(BTN_LATER)
      sleep(0.5)
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Reset password
  # @param is_valid_email - user valid email or invalid email 
  def reset_password (is_valid_email)
    wait_for(10) {element_exists(TXF_USER_NAME)}
    clear_text_in(TXF_USER_NAME)

    if is_valid_email == 'invalid'
      query(TXF_USER_NAME, {:setText => 'invalidaccount@lifeworks.com'})
      touch(BTN_OK)
      wait_for(10){element_does_not_exist(BTN_OK)}
    else
      wait_for(10) {element_exists(TXF_USER_NAME)}
      query(TXF_USER_NAME, {:setText => ACCOUNT[:"#{$account_index}"][:valid_account][:email]})
      touch(BTN_OK)
      wait_for(30){element_exists(TXV_RESET_PASSWORD_CONFIRMATION)}
      wait_for(30){element_exists("* marked:'OK'")}
      touch("* marked:'OK'")
      wait_for(10){element_does_not_exist("* marked:'OK'")}
    end
  end

  # Insert email
  # @param is_valid_email - user valid email or invalid email 
  def insert_email (is_valid_email)
    wait_for(10) {element_exists(TXF_USER_NAME)}
    clear_text_in(TXF_USER_NAME)

    if is_valid_email == 'invalid'
      query(TXF_USER_NAME, {:setText => 'invalidaccount@lifeworks.com'})
      touch(BTN_CONTINUE)
      wait_for(10){element_exists(BTN_LOGIN)}
    else
      wait_for(10) {element_exists(TXF_USER_NAME)}
      query(TXF_USER_NAME, {:setText => ACCOUNT[:"#{$account_index}"][:valid_account][:email]})
    end
  end

end
