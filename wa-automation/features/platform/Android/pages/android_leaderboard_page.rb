# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidLeaderboardPage < Calabash::ABase
  TXV_LEADERBOARD = "AppCompatTextView marked:'LeaderBoard'"
  TXV_THIS_MONTH = "* marked:'THIS MONTH'"
  TXV_LAST_MONTH = "* marked:'LAST MONTH'"
  TXV_ALL_TIME = "* marked:'ALL TIME'"
  
  BTN_GIVE_RECOGNITION = "AppCompatTextView marked:'Give Recognition'"

  IMG_SPINNER = "android.widget.Spinner id:'action_bar_spinner'"

  def trait
    TXV_LEADERBOARD
  end

  def click_button (button)
    case button
    when 'THIS MONTH'
      wait_for(:timeout => 30){element_exists(TXV_THIS_MONTH)}
      touch(TXV_THIS_MONTH)
      sleep(0.8)
    when 'LAST MONTH'
      wait_for(:timeout => 30){element_exists(TXV_LAST_MONTH)}
      touch(TXV_LAST_MONTH)
      sleep(0.8)
    when 'ALL TIME'
      wait_for(:timeout => 30){element_exists(TXV_ALL_TIME)}
      touch(TXV_ALL_TIME)
      sleep(0.8)
    when 'Give Recognition'
      wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
      touch(BTN_GIVE_RECOGNITION)
      wait_for(:timeout => 30){element_does_not_exist(BTN_GIVE_RECOGNITION)}
    else  
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Mimic scroll view by perform drag action
  # @param up_down - scroll up or down
  def scroll (up_down)
    up_down == 'down' ? perform_action('drag', 50, 50, 50, 40, 5) : perform_action('drag', 50, 50, 40, 50, 5)
  end

  # Open small menu according the user index
  # @param user_index
  def open_3_menu (user_index)
    wait_for(:timeout => 30){element_exists("AppCompatImageView id:'view_leaderboard_list_user_item_overflow_anchor' index:#{user_index}")}
    touch("AppCompatImageView id:'view_leaderboard_list_user_item_overflow_anchor' index:#{user_index}")
    wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
  end

  # Check if table is sorted (only for the first items in the view)
  def check_table_is_sorted 
    wait_for(:timeout => 30){element_exists(TXV_LEADERBOARD)}

    last_index = query("LinearLayout id:'view_leaderboard_list_user_item_container'").size - 1
    puts "last_index:#{last_index}"

    for i in 0..last_index - 1
      number_of_recognition_1 = query("AppCompatTextView id:'view_leaderboard_list_user_item_recognition_count' index:#{i}")[0]['text'].to_i
      number_of_recognition_2 = query("AppCompatTextView id:'view_leaderboard_list_user_item_recognition_count' index:#{i+1}")[0]['text'].to_i

      if number_of_recognition_1 < number_of_recognition_1
        fail(msg = "Error. check_table_is_sorted. Table is not sorted well. number_of_recognition_1=#{number_of_recognition_1} number_of_recognition_2=#{number_of_recognition_2}.")
      end

      puts "number_of_recognition_1=#{number_of_recognition_1} number_of_recognition_2=#{number_of_recognition_2}"
    end
  end
  
  # Go over the first recognition of the given colleague
  # @param colleague_name
  def see_colleague_recognitions (colleague_name)
    counter = 0

    sleep(2)
    
    wait_poll(:until_exists => "AppCompatTextView marked:'#{colleague_name}'", :timeout => 15) do 
      scroll('down')
      sleep(0.5)
    end

    wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'#{colleague_name}' sibling * id:'view_leaderboard_list_user_item_job'")}
    colleague_roll = query("AppCompatTextView marked:'#{colleague_name}' sibling * id:'view_leaderboard_list_user_item_job'")[0]['text']
    colleague_recognition_counter = query("AppCompatTextView marked:'#{colleague_name}' parent * index:2 descendant * id:'view_leaderboard_list_user_item_recognition_count'")[0]['text']
    
    touch("AppCompatTextView marked:'#{colleague_name}'")
    query("AppCompatTextView marked:'#{colleague_name}' sibling * id:'view_leaderboard_list_user_item_recognition_count'")
    
    if colleague_recognition_counter == 0
      wait_for(:timeout => 30){element_exists("AppCompatTextView id:'layout_empty_screen_title' marked:'No recognition yet?'")}
      wait_for(:timeout => 30){element_exists("AppCompatTextView id:'fragment_user_recognition_empty_view_description' marked:'Recognize your colleague for their great work!'")}
    else
      wait_for(:timeout => 30){element_exists("* marked:'Recognitions'")}
      wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'#{colleague_name}'")}
      wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'#{colleague_roll}'")}
    end
  end
  
  # Go over the first recognition of the current user
  def go_over_user_recognitions
    last_index = query("RoundedImageView id:'view_recognition_item_image'").size
    
    wait_for(:timeout => 5){element_exists("AppCompatTextView id:'fragment_user_recognition_list_header_user_name'")}
    user_name = query("AppCompatTextView id:'fragment_user_recognition_list_header_user_name'")[0]['text']

    for i in 0..last_index - 1
      wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_recognition_item_message' index:#{i}")}
      recognition_text = query("AppCompatTextView id:'view_recognition_item_message' index:#{i}")[0]['text'] 
      badge_hashtag = query("ChipTextView id:'view_recognition_item_badge_tag' index:#{i}")[0]['text']

      puts "user_name #{user_name}"
      puts "badge_hashtag #{badge_hashtag}"
      puts "BADGE[badge_hashtag] #{BADGES[badge_hashtag]}"

      touch("AppCompatTextView id:'view_recognition_item_message' index:#{i}")

      wait_for(:timeout => 5){element_exists("AppCompatTextView id:'view_feed_recognition_primary_text' marked:'#{user_name} has been recognized'")}

      wait_for(:timeout => 5){element_exists("AppCompatTextView id:'view_feed_recognition_badge_name' marked:'#{BADGES[badge_hashtag]}'")}
      wait_for(:timeout => 5){element_exists("AppCompatTextView id:'view_feed_recognition_secondary_text' marked:'#{recognition_text}'")}

      press_back_button
    end

    wait_for(:timeout => 5){element_exists("AppCompatTextView id:'fragment_user_recognition_list_header_user_name'")}
    press_back_button
  end

end
