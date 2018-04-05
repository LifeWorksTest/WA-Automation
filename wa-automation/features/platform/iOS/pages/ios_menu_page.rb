# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSMenuPage < Calabash::IBase
  BTN_MENU = "button marked:'Main menu'"
  BTN_PROFILE = "WAMLeftMenuIconsView child WAMMenuRoundedImageView index:0"
  BTN_NOTIFICATION = "WAMMenuNotificationsView child WAMMenuRoundedImageView"
  BTN_SKIP = "UIButtonLabel marked:'#{IOS_STRINGS["WBUpsellSkipButton"]}'"
  BTN_SKIP_NOW = "button marked:'#{IOS_STRINGS["WAMAppIntroSkipButtonTitle"]}'"

  LBL_D_AND_D = "label marked:'#{IOS_STRINGS["WAMMenuSectionPerksTitle"]}'"
  LBL_COLLEAGUES_DIRECTORY = "label marked:'#{IOS_STRINGS["WAMMenuItemColleagueDirectoryTitle"]}'"
  LBL_EXPLORE = "label marked:'Explore'"
  LBL_SHOPE_ONLINE = "label marked:'#{IOS_STRINGS["WAMShopOnlineViewControllerTitle"]}'"
  LBL_LEADERBOARD = "label marked:'#{IOS_STRINGS["WAMMenuItemLeaderboardTitle"]}'"
  LBL_NEWS_FEED = "label marked:'#{IOS_STRINGS["WAMRecognitionFeedTitle"]}'"
  LBL_GIVE_A_NEW_RECOGNITION = "label marked:'#{IOS_STRINGS["WAMMenuItemGiveNewRecognitionTitle"]}'"
  LBL_RESTAURANT_DISCOUNTS = "label marked:'#{IOS_STRINGS["WAMMenuItemRestaurantDiscountsTitle"]}'"
  LBL_INSTORE_OFFERS = "label marked:'#{IOS_STRINGS["WAMMenuItemInstoreOffersTitle"]}'"
  LBL_LOCAL = "label marked:'#{IOS_STRINGS["WAMMenuItemLocalTitle"]}'"
  LBL_WALLET = "label marked:'#{IOS_STRINGS["WAMMenuItemWalletTitle"]}'"
  LBL_EXCLUSIVE_OFFERS = "label marked:'#{IOS_STRINGS["WAMMenuItemColleagueOffersTitle"]}'"
  LBL_GIFT_CARDS = "label marked:'#{IOS_STRINGS["WAMMenuItemGiftCardsTitle"]}'"
  LBL_CINEMAS = "label marked:'#{IOS_STRINGS["WAMMenuItemCinemasTitle"]}'"
  LBL_EAP = "label marked:'#{IOS_STRINGS["WAMEmployeeAsstanceTitleLabel"]}'"

  IMG_SPINNER = "imageView id:'spin'"
  
  def trait

    if element_exists(BTN_SKIP)
      touch(BTN_SKIP)
      sleep(0.5)
      touch(BTN_SKIP_NOW)
      sleep(0.5)
    end 
  end

  # Open one of the screens from the menu option
  # @param option_from_menu - which option to open
  def open_from_menu (option_from_menu)
    if option_from_menu == 'My Profile'
      wait_for(:timeout => 30){element_exists(BTN_PROFILE)}
      touch(BTN_PROFILE)
      wait_for(:timeout => 30){element_exists("button marked:'#{IOS_STRINGS["WAMUserProfileEditProfileTitle"]}'")}
    elsif option_from_menu == 'Notification'
      wait_for(:timeout => 30){element_exists(BTN_NOTIFICATION)}
      touch(BTN_NOTIFICATION)
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMSettingsTypeNotifications"]}'")}
    else
      wait_poll(:retry_frequency => 0.5, :until_exists => "* marked:'#{option_from_menu}'", :timeout => 30) do
        scroll('scrollView', :down)
    end

    case option_from_menu
      when 'Shop Online'
        wait_for(:timeout => 30){element_exists(LBL_SHOPE_ONLINE)}
        touch(LBL_SHOPE_ONLINE)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemShopOnlineTitle"]}'")}
      when 'Restaurants'
        wait_for(:timeout => 30){element_exists(LBL_RESTAURANT_DISCOUNTS)}
        touch(LBL_RESTAURANT_DISCOUNTS)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemRestaurantDiscountsTitle"]}'")}
      when 'Local'
        wait_for(:timeout => 30){element_exists(LBL_LOCAL)}
        touch(LBL_LOCAL)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemLocalTitle"]}'")}
      when 'In-Store'
        wait_for(:timeout => 30){element_exists(LBL_INSTORE_OFFERS)}
        touch(LBL_INSTORE_OFFERS)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemInstoreOffersTitle"]}'")}
      when 'Wallet'
        wait_for(:timeout => 30){element_exists(LBL_WALLET)}
        touch(LBL_WALLET)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemWalletTitle"]}'")}
      when 'Colleague Directory'
        wait_for(:timeout => 30){element_exists(LBL_COLLEAGUES_DIRECTORY)}
        touch(LBL_COLLEAGUES_DIRECTORY)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemColleagueDirectoryTitle"]}'")}
      when 'News Feed'
        wait_for(:timeout => 30){element_exists(LBL_NEWS_FEED)}
        touch(LBL_NEWS_FEED)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemRecognitionFeedTitle"]}'")}
      when 'Leaderboard'
        wait_for(:timeout => 30){element_exists(LBL_LEADERBOARD)}
        touch(LBL_LEADERBOARD)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemLeaderboardTitle"]}'")}
      when 'Give Recognition!'
        wait_for(:timeout => 30){element_exists(LBL_GIVE_A_NEW_RECOGNITION)}
        touch(LBL_GIVE_A_NEW_RECOGNITION)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMRecognizeColleaguesViewControllerTitle"]}'")}
      when 'Exclusive Offers'
        wait_for(:timeout => 30){element_exists(LBL_EXCLUSIVE_OFFERS)}
        touch(LBL_EXCLUSIVE_OFFERS)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemColleagueOffersTitle"]}'")}
      when 'Gift Cards'
        wait_for(:timeout => 30){element_exists(LBL_GIFT_CARDS)}
        touch(LBL_GIFT_CARDS)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemGiftCardsTitle"]}'")}  
      when 'Cinemas'
        wait_for(:timeout => 30){element_exists(LBL_CINEMAS)}
        touch(LBL_CINEMAS)
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemCinemasTitle"]}'")}
      when 'Employee Assistance'
        scroll('scrollView', :down)
        wait_for_none_animating
        wait_for(:timeout => 30){element_exists(LBL_EAP)}
        touch(LBL_EAP)
        wait_for_none_animating
        wait_for(:timeout => 30){element_exists("UILabel label marked:'#{IOS_STRINGS["WAMEmployeeAsstanceTitleLabel"]}'")}
      else
        fail(msg = "Error. click_button. Button '#{option_from_menu}' is not defined.")
      end
    end
  end

  # Check for notification
  # @param notification
  def check_for_notification (notification)
    sleep(5)
    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 descendant * label")}
    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 descendant * label")}
    puts "Notification to search:#{notification}"
    
    # while notification is not existing in the first place in the notification's box
    for i in 0..10
      if element_exists("UITableViewCellContentView index:0 descendant * label index:0 marked:'#{notification}'")
        return
      end

      puts "First notification in the list:#{query("UITableViewCellContentView index:0 descendant * label index:0")[0]['text']}"  

      sleep(5)
      
      steps %Q{
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Wallet"
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Notification"
      }
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMNotificationViewControllerTitle"]}'")}
      sleep(3)
    end
    
    fail(msg = "Error. check_for_notification. The next notification '#{notification}' was not found")
  end
end