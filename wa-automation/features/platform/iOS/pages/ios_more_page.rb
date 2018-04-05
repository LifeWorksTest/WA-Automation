# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSMorePage < Calabash::IBase
  BTN_VIEW_MY_PROFILE = "UIButtonLabel marked:'View My Profile'"
  BTN_EDIT_PROFILE = "button marked:'#{IOS_STRINGS["WAMEditUserProfileTitle"]}'"
  BTN_SETTINGS = "button marked:'icnSettingsActive'"
  BTN_LOGOUT = "label marked:'#{IOS_STRINGS["WAMSettingsTypeLogOut"]}'"

  LBL_SNACKABLE_TOPICS = "label marked:'#{IOS_STRINGS["WAMSettingsTypeWellbeingInterests"]}'"
  LBL_CHOOSE_TOPICS = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingCategoriesPleaseSelect"]}'"
  LBL_SELECT_TOPICS = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingSubcategoriesPleaseSelect"]}'"

  def trait
    BTN_VIEW_MY_PROFILE
  end

  def click_button (button)
    case button
  	when 'View My Profile'
      wait_for(:timout => 30, :post_timeout => 1){element_exists(BTN_VIEW_MY_PROFILE)}
      flash(BTN_VIEW_MY_PROFILE)
      touch(BTN_VIEW_MY_PROFILE)
      wait_for(:timout => 30, :post_timeout => 1){element_exists(BTN_EDIT_PROFILE)}
    when 'Settings'
      sleep(0.5)
      wait_for(:timout => 10,:post_timeout => 1){element_exists(BTN_SETTINGS)}
      touch(BTN_SETTINGS)
      wait_for(:timout => 10, :post_timeout => 1){element_does_not_exist(BTN_SETTINGS)}
    when 'Snackable'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(LBL_SNACKABLE_TOPICS)}
      touch(LBL_SNACKABLE_TOPICS)
      wait_for(:timeout => 30){element_exists(LBL_CHOOSE_TOPICS)}
    when 'Log out'
      sleep(1)
      scroll("scrollView", :down)
      wait_for_none_animating
      wait_for(:timout => 30, :post_timeout => 1){element_exists(BTN_LOGOUT)}
      touch(BTN_LOGOUT)
      wait_for(:timout => 30, :post_timeout => 1){element_exists("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")}
      sleep(0.5)
      touch("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")
      wait_for(:timout => 30, :post_timeout => 2){element_exists("button marked:'#{IOS_STRINGS["WAMLMLandingLogin"]}'")}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end  
  end

  def naviagte_to_snackable
    click_button('Snackable')
  end

  # Logout from the iOS appliction
  def logout
    click_button('Settings')
    click_button('Log out')
  end

end 