# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSLoginPage < Calabash::IBase
  BTN_LOGIN = "button marked:'#{IOS_STRINGS["WAMLMLoginButton"]}'"
  BTN_X = "button marked:'close button'"
  BTN_SKIP = "button marked:'#{IOS_STRINGS["WBUpsellSkipButton"]}'"
  BTN_LETS_GO = "button index:0"
  BTN_CONTINUE =  "button marked:'#{IOS_STRINGS["WAMFoundationContinueKey"]}'"

  TXF_USER_NAME = "textField index:0"
  TXF_PASSWORD = "textField index:1"
  TXF_FORGOT_INSERT_EMAIL = "textField index:0"

  LBL_CANCEL = "label marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'"
  LBL_SEND = "label marked:'#{IOS_STRINGS["WAMFoundationSendKey"]}'"
  LBL_OK = "label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'"
  LBL_FORGOTTEN_PASSWORD = "label marked:'#{IOS_STRINGS["WAMLMLoginRecoverPassword"]}'"
  LBL_RESET_PASSWORD_SUCCSES = "label marked:'#{IOS_STRINGS["WAMLMLoginRecoverPasswordCompletedAlertMsg"]}'"
  LBL_INVALID_EMAIL = "label marked:'#{IOS_STRINGS["WAMLMLoginRecoverPasswordFailAlertTitle"]}'"

  def trait
    TXF_USER_NAME
  end

  # insert email address during login
  # @param email
  def insert_email_for_login (email)
    wait_for_element_exists(TXF_USER_NAME, {:timeout => 30})
    wait_for_none_animating
    touch(TXF_USER_NAME)
    wait_for_none_animating
    clear_text(TXF_USER_NAME)
    wait_for_keyboard
    keyboard_enter_text(email)
  end

  # insert user password during login
  # @param password
  def insert_password_for_login (password)
    wait_for_element_exists(TXF_PASSWORD, {:timeout => 30})
    wait_for_none_animating
    touch(TXF_PASSWORD)
    wait_for_none_animating
    clear_text(TXF_PASSWORD)
    wait_for_keyboard
    keyboard_enter_text(password)
  end

  # login to LifeWorks
  # @param email
  # @param password
  def login_to_wam (email, password)
    if email != nil
      insert_email_for_login(email)
    end

    if element_exists(BTN_CONTINUE)
      click_button('Continue')
    end

    if password != nil
     insert_password_for_login(password)
    end

    click_button('Log in')
    sleep(1)
    if element_exists("label marked:'#{IOS_STRINGS["WAMLMLoginIncorrectPassword"]}'")
      return
    elsif element_exists("view marked:'Incorrect details'")
      click_button('OK')
      return
    elsif element_exists("view marked:'#{IOS_STRINGS["WAMLoginSingUpErrorViewControllerNetworkUnavailableTitleText"]}'")
      click_button('OK')
      click_button('X')
      return
    elsif element_exists("view marked:'#{IOS_STRINGS["WAMLoginSingUpErrorViewControllerAccountDeactivatedTitleText"]}'")
      click_button('OK')
      click_button('X')
      return
    else
      puts "SKIP"
      click_button('Skip')
    end
  end

  def click_button (button)
    case button
    when 'Cancel'
      wait_for(30){element_exists(LBL_CANCEL)}
      sleep(0.2)
      touch(LBL_CANCEL)
      wait_for(30){element_does_not_exist(LBL_CANCEL)}
    when 'Send'
      wait_for(30){element_exists(LBL_SEND)}
      touch(LBL_SEND)
      wait_for(30){element_does_not_exist(LBL_SEND)}
    when 'Log in'
      wait_for(30){element_exists(BTN_LOGIN)}
      touch(BTN_LOGIN)
      sleep(2)
    when 'Forgotten your password'
      wait_for(30){element_exists(LBL_FORGOTTEN_PASSWORD)}
      touch(LBL_FORGOTTEN_PASSWORD)
      wait_for(30){element_exists(LBL_SEND)}
    when 'OK'
      wait_for(30){element_exists(LBL_OK)}
      touch(LBL_OK)
      wait_for(30){element_does_not_exist(LBL_OK)}
    when 'Skip'
      wait_for(30){element_exists(BTN_SKIP)}
      touch(BTN_SKIP)
      wait_for(30){element_does_not_exist(BTN_SKIP)}
    when "Let's go"
      wait_for(30){element_exists(BTN_LETS_GO)}
      touch(BTN_LETS_GO)
    when 'X'
      wait_for(30){element_exists(BTN_X)}
      touch(BTN_X)
      wait_for(30) {element_does_not_exist(BTN_X)}
    when 'Continue'
      wait_for(30){element_exists(BTN_CONTINUE)}
      touch(BTN_CONTINUE)
      wait_for(30){element_does_not_exist(BTN_CONTINUE)}
    else
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end

    sleep(0.8)
  end

  # Reset password
  # @param is_valid_email - 'valid' or 'unvalid'
  def insert_email_for_reset_password (is_valid_email)

    if is_valid_email == 'valid'
      wait_for(30){element_exists(TXF_FORGOT_INSERT_EMAIL)}
      clear_text(TXF_FORGOT_INSERT_EMAIL)
      sleep(0.5)
      touch(TXF_FORGOT_INSERT_EMAIL)
      sleep(0.8)

      keyboard_enter_text ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email]
      click_button('Send')

      wait_for(30){element_exists(LBL_RESET_PASSWORD_SUCCSES)}
      click_button('OK')
      wait_for_elements_do_not_exist(LBL_RESET_PASSWORD_SUCCSES)

    elsif is_valid_email == 'invalid'
      wait_for(30){element_exists(TXF_FORGOT_INSERT_EMAIL)}
      clear_text(TXF_FORGOT_INSERT_EMAIL)
      sleep(0.5)
      touch(TXF_FORGOT_INSERT_EMAIL)
      sleep(0.8)

      keyboard_enter_text 'invalidaccount@lifeworks.com'
      wait_for(30){element_exists(LBL_SEND)}
      touch(LBL_SEND)

      wait_for(30) {element_exists(LBL_INVALID_EMAIL)}

      click_button('Cancel')

      wait_for_elements_do_not_exist(LBL_INVALID_EMAIL)
    end
  end
end
