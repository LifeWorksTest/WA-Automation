# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidMenuPage < Calabash::ABase
  BTN_HOME = "* id:'view_toolbar_wrapper_toolbar' * contentDescription:'Open navigation'"
  BTN_NO = "android.widget.Button marked:'No'"
  BTN_YES = "android.widget.Button marked:'Yes'"
  BTN_MORE = "* id:'smallLabel' text:'More'"
  BTN_VIEW_MY_PROFILE = "* id:'fragment_more_view_profile_button' marked:'View My Profile'"


  TXV_SETTINGS = "* id:'fragment_more_settings_icon'"
  TXV_MORE = "AppCompatTextView marked:'More'"
  TXV_NEWS_FEED = "AppCompatTextView marked:'News Feed'"
  TXV_WORK = "AppCompatTextView marked:'Work'"
  TXV_PERKS = "AppCompatTextView marked:'Perks'"
  TXV_SHOP_ONLINE = "AppCompatTextView marked:'Shop Online'"
  TXV_WALLET = "* id:'menu_item_perks_home_wallet'"
  TXV_RESTAURANT_DISCOUNT = "AppCompatTextView marked:'Restaurants'"
  TXV_GIFT_CARDS = "AppCompatTextView marked:'Gift Cards'"
  TXV_IN_STORE_OFFERS = "AppCompatTextView marked:'In-Store'"
  TXV_EXCLUSIVE_OFFERS = "AppCompatTextView marked:'Exclusive Offers'"
  TXV_ASSESSMENTS = "AppCompatTextView marked:'Assessments'"

  TXV_LOGOUT = "* marked:'Logout'"


  def trait
    "* id:'activity_lifeworks_bottom_navigation_view_container'"
  end

  def click_button (button)
    case button
    when 'Notification'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_MORE)}
      touch(TXV_MORE)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_more_settings_icon_container'")}
      touch("* id:'fragment_more_notification_icon'")
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Notifications'")}
    when 'My Profile'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_MORE)}
      touch(TXV_MORE)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_VIEW_MY_PROFILE)}
      touch(BTN_VIEW_MY_PROFILE)
    when 'News Feed'
      touch(TXV_NEWS_FEED)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'News Feed'")}
    when 'Colleagues Directory'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_WORK)}
      touch(TXV_WORK)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Directory'")}
      touch("AppCompatTextView marked:'Directory'")
    when 'Leaderboard'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_WORK)}
      touch(TXV_WORK)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'LeaderBoard'")}
      touch("AppCompatTextView marked:'LeaderBoard'")
    when 'Shop Online'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_PERKS)}
      touch(TXV_PERKS)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatButton id:'view_perks_segment_see_all'")}
      touch("AppCompatButton id:'view_perks_segment_see_all'")

      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_SHOP_ONLINE)}
      touch(TXV_SHOP_ONLINE)
    when 'Restaurant Discount'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_PERKS)}
      touch(TXV_PERKS)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatButton id:'view_perks_segment_see_all'")}
      touch("AppCompatButton id:'view_perks_segment_see_all'")

      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_RESTAURANT_DISCOUNT)}
      touch(TXV_RESTAURANT_DISCOUNT)
    when 'Gift Cards'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_PERKS)}
      touch(TXV_PERKS)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatButton id:'view_perks_segment_see_all'")}
      touch("AppCompatButton id:'view_perks_segment_see_all'")

      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_GIFT_CARDS)}
      touch(TXV_GIFT_CARDS)
    when 'In-Store Offers'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_PERKS)}
      touch(TXV_PERKS)

      wait_for(:timeout => 30,:post_timeout => 1){element_exists("AppCompatButton id:'view_perks_segment_see_all'")}
      touch("AppCompatButton id:'view_perks_segment_see_all'")

      wait_for(:timeout => 30,:post_timeout => 1){element_exists(TXV_IN_STORE_OFFERS)}
      touch(TXV_IN_STORE_OFFERS)
     when 'Exclusive Offers'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_PERKS)}
      touch(TXV_PERKS)

      wait_for(:timeout => 30,:post_timeout => 1){element_exists("AppCompatButton id:'view_perks_segment_see_all'")}
      touch("AppCompatButton id:'view_perks_segment_see_all'")

      wait_for(:timeout => 30,:post_timeout => 1){element_exists(TXV_EXCLUSIVE_OFFERS)}
      touch(TXV_EXCLUSIVE_OFFERS)
    when 'Wallet'
     wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_PERKS)}
      touch(TXV_PERKS)

      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_WALLET)}
      touch(TXV_WALLET)
    when 'Settings'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_MORE)}
      touch(TXV_MORE)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_SETTINGS)}
      touch(TXV_SETTINGS)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Settings'")}
    when 'Refresh'
      perform_action('drag', 50, 50, 40, 70, 5)
      sleep(0.5)
    when 'Home Btn'

    when 'Logout'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_LOGOUT)}
      touch(TXV_LOGOUT)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_YES)}
    when 'No'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_NO)}
      touch(BTN_NO)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_LOGOUT)}
    when 'Yes'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_YES)}
      touch(BTN_YES)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_YES)}
    when 'Assessments'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_MORE)}
      touch(TXV_MORE)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_ASSESSMENTS)}
      touch(TXV_ASSESSMENTS)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_ASSESSMENTS)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  def loop_menu
    for i in 2..7
      touch("* index:#{i}")
      sleep(0.8)

      click_button('Home Btn')
    end

    scroll_down

    for i in 9..10
      touch("* index:#{i}")
      sleep(0.8)

      if (i == 9)
        touch("android.widget.ImageView id:'dashboard_fragment_overflow_button' index:1")
        click_button('Home Btn')
      end

      click_button('Home Btn')
    end
  end

  # Logout
  # @param yes_no - to logout or not
  def logout (yes_no)
    click_button('Settings')
    wait_for(:timeout => 30){element_exists("AppCompatTextView text:'Account Settings'")}

    perform_action('drag', 50, 50, 70, 40, 5)
    sleep(0.5)

    perform_action('drag', 50, 50, 70, 40, 5)
    sleep(0.5)

    wait_for(:timeout => 30){element_exists(TXV_LOGOUT)}
    click_button('Logout')

    if yes_no == 'Yes'
      click_button('Yes')
    elsif yes_no == 'No'
      click_button('No')
    end
  end

  # Check if the given App notification is in the user notification's box
  # @param notification text
  def check_for_notification (notification)
    wait_for(:timeout => 30){element_exists("* id:'list'")}
    notification_was_not_found = true
    # while notification is not existing in the first place in the notification's box
    for i in 0..6
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout index:0 * TextView")}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout index:1 * TextView")}
      notification_text_1 = query("* id:'list' child LinearLayout index:0 * TextView")[0]['text']
      notification_text_2 = query("* id:'list' child LinearLayout index:1 * TextView")[0]['text']

      puts "notification_text_1: #{notification_text_1}"
      puts "notification_text_2: #{notification_text_2}"
      puts "notification: #{notification}"

      if (/#{notification}/.match notification_text_1) || (/#{notification}/.match notification_text_2)
        puts "CLICK"
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout index:0 * TextView")}
        touch("* id:'list' child LinearLayout index:0 * TextView")
        notification_was_not_found = false
        break
      end

      sleep(5)
      click_button('Refresh')
    end

    if notification_was_not_found
      fail(msg = "Error. check_for_notification. The next notification '#{notification}' was not found")
    end
  end

  def navigate_back_to_more
    
    q = query(BTN_MORE)
    while q.empty? 
      press_button('KEYCODE_BACK')
      sleep(0.5)
      q = query(BTN_MORE)
    end
    
    touch(BTN_MORE)
  end 
end