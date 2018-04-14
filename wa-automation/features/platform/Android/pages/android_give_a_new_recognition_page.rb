# -*- encoding : utf-8 -*-
require 'calabash-android/abase'
$scl = "down"

class AndroidGiveANewRecognitionPage < Calabash::ABase
  BTN_POST = "android.widget.TextView marked:'New Post'"
  BTN_NEXT = "* id:'action_selection_done' marked:'Next'"
  BTN_DONE = "* id:'action_selection_done' marked:'Done'"
  BTN_SELECT_BADGE = "AppCompatImageButton id:'fragment_compose_message_action_edit_badge'"
  BTN_BACK = "android.widget.ImageButton"
  BTN_DISCARD = "* id:'button2' text:'Discard'"

  TXV_SELECT_A_BADGE = "AppCompatTextView marked:'Select a Badge'"
  TXV_NEW_POSTS = "* id:'view_new_data_available_text' text:'New posts'"
  TXF_COMMENT = "UserSuggestionsEditText index:0"
  TXV_GIVE_RECOGNITION = "* id:'fragment_give_recognition_usersuggestion'"
  TXV_FIRST_BADGE_IN_LIST = "AppCompatTextView id:'view_badge_list_item_title' marked:'Organised'"
  TXV_SELECT_COLLEAGUES = "* id:'fragment_pick_users_search_text'"
  TXV_ALERT = "android.support.v7.widget.DialogTitle id:'alertTitle'"



  def trait
    "AppCompatTextView marked:'Select colleague(s)'"
  end
  
  def click_button (button)
    case button
    when 'DONE'
      wait_for(:timeout => 30){element_exists(BTN_DONE)}
      touch(BTN_DONE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_DONE)}
    when 'POST'
      wait_for(:timeout => 30){element_exists(BTN_POST)}
      touch(BTN_POST)
      wait_for(:timeout => 30){element_does_not_exist(BTN_POST)}
    when 'NEXT'
      wait_for(:timeout => 30){element_exists(BTN_NEXT)}
      touch(BTN_NEXT)
      wait_for(:timeout => 30){element_does_not_exist(BTN_NEXT)}
    when 'Select Badge'
      wait_for(:timeout => 30){element_exists(BTN_SELECT_BADGE)}
      touch(BTN_SELECT_BADGE)
      wait_for(:timeout => 30){element_exists(TXV_GIVE_RECOGNITION)}
    when 'BACK'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_BACK)}      
    else 
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Mimic scroll view by perform drag action
  # @param up_down - scroll up or down
  def scroll (up_down)
    up_down == 'down' ? perform_action('drag', 50, 50, 60, 40, 5) : perform_action('drag', 50, 50, 40, 60, 5)
  end

  # Select user by the given index
  # @param user_index
  def select_user (user_index)
    wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'Select colleague(s)'")}
    wait_for(:timeout => 30){element_exists("android.widget.CheckBox index:#{user_index}")}
    touch("android.widget.CheckBox index:#{user_index}")
    sleep(2)
    user_name = query("android.widget.CheckBox index:0 parent * index:1 descendant * id:'view_pick_user_name'")[0]['text'].split(' ')[0]
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_pick_user_summary_name' marked:'#{user_name}'")}
  end

  # Select the given badge
  # @param badge
  # def choose_badge (badge)
  #   wait_for(:timeout => 30){element_exists(TXV_SELECT_A_BADGE)}
  #   puts "Search for: '#{badge}' badge"
  #   wait_poll(:until_exists => "AppCompatTextView id:'view_badge_list_item_title' marked:'#{badge}'", :timeout => 30) do 
  #     scroll('down')
  #     sleep(0.5)
  #   end

    #touch("AppCompatTextView id:'view_badge_list_item_title' marked:'#{badge}'")
   #sleep(0.5)
  # end

  # Write the given recognition 
  # @recognition_text
  def write_recognition (recognition_text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_GIVE_RECOGNITION)}
    flash(TXV_GIVE_RECOGNITION)
    touch(TXV_GIVE_RECOGNITION)
    enter_text(TXV_GIVE_RECOGNITION, recognition_text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Post'")}
    touch("* marked:'Post'")
    wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist("* marked:'Post'")}
  end

  # Give recognition to user
  # @param recognition_text
  # @param user_index
  # @param to_validate_badges or not
  def give_recognition (recognition_text, badge, to_validate_badges = false)
    if to_validate_badges
      validate_badges
    else
      choose_badge (badge)
    end

    #write_recognition (recognition_text)
  end 

  # Validate badges
  def validate_badges
    i = 0
    BADGES.each {|key, value|
      puts "i:#{i}"
      if i % 2 == 1
        i += 1
        puts "IN"
        next
      end
      puts "key:#{key} value:#{value}"
      puts "scroll:#{$scl}"
      choose_badge(key)
      puts "key:#{key} value:#{value}"
      i += 1
      # if i != 0
      #   click_button('DONE')
      # end

      #wait_for(:timeout => 30){element_exists("ChipTextView id:'fragment_give_recognition_badge_hash' marked:'#{value}'") || element_exists("ChipTextView id:'fragment_give_recognition_badge_hash' marked:'#{value.capitalize}'")}
      #i += 1
      # click_button('Select Badge')
    }
    touch(BTN_BACK)
    wait_for(:timeout => 30){element_exists(TXV_SELECT_COLLEAGUES)}
    if element_exists("android.widget.TextView id:'tooltip_title'")
      touch("android.widget.TextView id:'tooltip_title'")
      touch(BTN_BACK)
    else
      touch(BTN_BACK)
    end
    wait_for(:timeout => 30){element_exists(TXV_ALERT)}
    touch(BTN_DISCARD)
  end

  def choose_badge(badge)
    wait_for(:timeout => 30){element_exists(TXV_SELECT_A_BADGE)}
    puts "Search for: '#{badge}' badge"
    wait_poll(:until_exists => "AppCompatTextView id:'view_badge_list_item_title' marked:'#{badge}'", :timeout => 60) do 
      scroll($scl)
      
      if element_exists("AppCompatTextView id:'view_badge_list_item_title' marked:'Recognition'")
        $scl = "up"
        elsif element_exists("AppCompatTextView id:'view_badge_list_item_title' marked:'Organised'")
          if element_does_not_exist("AppCompatTextView id:'view_badge_list_item_title' marked:'Innovation'")
          $scl = "down"
          end
      end
      
      sleep(0.5)
    end
  end

end
