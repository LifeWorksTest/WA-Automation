# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSMenuTabPage < Calabash::IBase 
  BTN_MORE = "* marked:'More'"
  BTN_NEWS_FEED = "* marked:'News Feed'"
  BTN_WORK = "UITabBarButtonLabel marked: 'Work'"
  BTN_PERKS = "* marked:'Perks'"
  BTN_LIFE = "* marked:'Life'"
  
  LBL_NEWS_FEED = "label marked:'#{IOS_STRINGS["WAMRecognitionFeedTitle"]}'"
  LBL_WORK = "UILabel marked: 'Work'"
  LBL_PERKS = "UILabel marked: 'Perks'"
  LBL_EAP = "UILabel marked: 'Employee Assistance'"

  def trait 
	BTN_MORE
  end

  def click_button(button)
  	case button
  	when 'More'
  	  wait_for(:timeout => 30){element_exists(BTN_MORE)}
      touch(BTN_MORE)
      sleep(1)
       if element_exists("UINavigationBar descendant * index:6")
        touch("UINavigationBar descendant * index:6")
       end

      wait_for(:timeout => 30){element_exists("button marked:'icnSettingsActive'")}
    when 'News Feed'
  	  wait_for(:timeout => 30){element_exists(BTN_NEWS_FEED)}
      touch(BTN_NEWS_FEED)
      wait_for(:timeout => 30){element_exists(LBL_NEWS_FEED)}
    when 'Work'
      wait_for(:timeout => 30){element_exists(BTN_WORK)}
      touch(BTN_WORK)
      wait_for(:timeout => 30){element_exists(LBL_WORK)}  
    when 'Perks'
      wait_for(:timeout => 30){element_exists(BTN_PERKS)}
      touch(BTN_PERKS)
      wait_for(:timeout => 30){element_exists(LBL_PERKS)}
    when 'Life'
      wait_for(:timeout => 30,:post_timeout => 2){element_exists(BTN_LIFE)}
      touch(BTN_LIFE)
      wait_for(:timeout => 30,:post_timeout => 2){element_exists(LBL_EAP)}
    else
        fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end
  end  
end 
