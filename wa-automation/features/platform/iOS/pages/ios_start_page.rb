# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSStartPage < Calabash::IBase
  BTN_JOIN = "button marked:'#{IOS_STRINGS["WAMValidationJoinButtonTitle"]}'"
  BTN_X = "button marked:'close button'"
  BTN_OK = "button marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'"
  BTN_SKIP = "button marked:'#{IOS_STRINGS["WBUpsellSkipButton"]}'"
  BTN_SKIP_FOR_NOW = "UIButtonLabel marked: '#{IOS_STRINGS["WAMAppIntroSkipButtonTitle"]}'"
  BTN_LETS_BEGIN = "WAMMainFlatButton"

  LBL_ENTER_INVITATION_CODE = "label marked:'#{IOS_STRINGS["WAMValidationTextFieldPlaceholder"]}'"
  LBL_LOG_IN = "button marked:'#{IOS_STRINGS["WAMLMLandingLogin"]}'"
  LBL_SIGN_UP = "button marked:'#{IOS_STRINGS["WALMLLandingSignUp"]}'"
  LBL_INVITATION_CODE = "label marked:'#{IOS_STRINGS["WAMValidationTextFieldPlaceholder"]}'"
  LBL_GOT_IT = "label marked:'#{IOS_STRINGS["WAMRWHelpViewButtonTitle2"]}'"

  TXF_INVITATION_CODE = "label marked:'#{IOS_STRINGS["WAMValidationTextFieldPlaceholder"]}' * parent textField"
  
  def trait
    if element_exists("button marked:'close button'")
      touch("button marked:'close button'")
      sleep(0.5)
    end
    
    LBL_LOG_IN
  end
  
  def click_button (button)
    case button
    when 'Log in'
      wait_for(:timeout => 30){element_exists(LBL_LOG_IN)}
      touch(LBL_LOG_IN)
      wait_for(:timeout => 30){element_exists("label { text CONTAINS '#{IOS_STRINGS["WAMLMLoginRecoverPassword"]}'")}
    when 'Join'
      wait_for(:timeout => 30){element_exists(BTN_JOIN)}
      touch(BTN_JOIN)
    when 'Enter invitation code'
      click_button ('Sign up')
      wait_for(:timeout => 30){element_exists(LBL_ENTER_INVITATION_CODE)}
      touch(LBL_ENTER_INVITATION_CODE)
      wait_for(:timeout => 30){element_exists(BTN_JOIN)}
    when 'OK'
      wait_for(:timeout => 30){element_exists(BTN_OK)}
      touch(BTN_OK)
      wait_for(:timeout => 30){element_does_not_exist(BTN_OK)}
    when 'X'
      wait_for(5){element_exists(BTN_X)}
      touch(BTN_X)
      wait_for(5) {element_does_not_exist(BTN_X)}
    when 'Sign up'
      wait_for(5){element_exists(LBL_SIGN_UP)}
      touch(LBL_SIGN_UP)
      wait_for(5) {element_does_not_exist(LBL_SIGN_UP)}
    when 'Got it!'
      wait_for(5){element_exists(LBL_GOT_IT)}
      touch(LBL_GOT_IT)
      wait_for(5) {element_does_not_exist(LBL_GOT_IT)}
    when 'Skip'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SKIP)}
      touch(BTN_SKIP)
      wait_for(:timeout => 30){element_does_not_exist(BTN_SKIP)}
    when 'Lets Begin'
      wait_for(30){element_exists(BTN_LETS_BEGIN)}
      flash(BTN_LETS_BEGIN)
      touch(BTN_LETS_BEGIN)
      wait_for(:timeout => 30, :post_timeout => 2){element_does_not_exist(BTN_LETS_BEGIN)}
    when 'Skip for now'
      wait_for(30){element_exists(BTN_SKIP_FOR_NOW)}
      flash(BTN_SKIP_FOR_NOW)
      touch(BTN_SKIP_FOR_NOW)
      wait_for(:timeout => 30, :post_timeout => 2){element_does_not_exist(BTN_SKIP_FOR_NOW)}
    else
      fail(msg = 'Error. click_button. The button is not defined.')
    end
  end

  # Insert invitation code
  # @param code 
  def insert_code (code)
    wait_for(:timeout => 30){element_exists(TXF_INVITATION_CODE)}
    sleep(2)
    touch(TXF_INVITATION_CODE)
    wait_for_keyboard
    clear_text(TXF_INVITATION_CODE)
    keyboard_enter_text(code)
    sleep(1)
    wait_for_none_animating
  end
end
