# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidNewsFeedPage < Calabash::ABase
  
  TXV_NEWS_FEED = "AppCompatTextView marked:'News Feed'"
  TXV_CHOOSE_BADGE = "AppCompatTextView marked:'Select a Badge'"
  TXV_GIVE_RECOGNITION = "* id:'fragment_give_recognition_usersuggestion'"
  TXV_NEW_POSTS = "* id:'card_feed_give_recognition_new_post_button'"
  TXF_COMMENT = "* id:'fragment_compose_message_usersuggestions'"
  TXV_NO_RESULTS = "* id:'view_generic_error_message'"

  BTN_GIVE_RECOGNITION = "AppCompatTextView marked:'Give Recognition'"
  BTN_POST = "android.widget.TextView marked:'New Post'"
  BTN_CREATE_NEW_POST = "AppCompatTextView id:'card_feed_give_recognition_update_status'"
  BTN_HOME = "* id:'view_toolbar_wrapper_toolbar' AppCompatImageButton"
  BTN_SEARCH = "* contentDescription:'Search'"
  BTN_NEXT = "* marked:'Next'"
  BTN_POST_COMMENT = "* id:'view_comment_field_send'"
  
  TXF_POST_A_COMMENT = "UserSuggestionsEditText id:'view_comment_field_user_suggestion_edittext'"

  IMG_SPINNER = "android.widget.Spinner id:'action_bar_spinner'"

  def trait
    TXV_NEWS_FEED
  end

  def is_visible
    wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
  end
  
  def click_button (button)
    case button
    when 'Post comment'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_POST_COMMENT)}
      touch(BTN_POST_COMMENT)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_POST_COMMENT)}
    when 'Give recognition'
      wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
      touch(BTN_GIVE_RECOGNITION)
      wait_for(:timeout => 30){element_does_not_exist(BTN_GIVE_RECOGNITION)}
    when 'POST'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_POST)}
      touch(BTN_POST)
      wait_for(:timeout => 30,:post_timeout => 1){element_does_not_exist(BTN_POST)}
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(TXV_NEW_POSTS)}
      touch(TXV_NEW_POSTS)
      wait_for(:timeout => 30){element_does_not_exist(TXV_NEW_POSTS)}
    when 'Create new post'
      wait_for(:timeout => 30){element_exists(BTN_CREATE_NEW_POST)}
      touch(BTN_CREATE_NEW_POST)
      wait_for(:timeout => 30){element_exists(BTN_POST)}
    when 'Home Btn'
      wait_for(:timeout => 30){element_exists(BTN_HOME)}
      touch(BTN_HOME)
      sleep(1)
    when 'DONE'
      wait_for(:timeout => 30){element_exists(BTN_DONE)}
      sleep(1)
      touch(BTN_DONE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_DONE)}
    when 'Search'
      wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      wait_for(:timeout => 30){element_exists("* id:'activity_navigation_search_field'")}
    when 'NEXT'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_NEXT)}
      flash(BTN_NEXT)
      touch(BTN_NEXT)
      flash(BTN_NEXT)
      touch(BTN_NEXT)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_NEXT)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Select user by the given index
  # @param user_index
  def select_user(user_index)
    wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'Select colleague(s)'")}
    wait_for(:timeout => 30){element_exists("* id:'view_pick_user_name'")}
    touch("android.widget.CheckBox index:#{user_index}")
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_pick_user_summary_name'")}
  end

  # Select the given badge
  # @param badge
  def choose_badge(badge)
    wait_for(:timeout => 30){element_exists(TXV_CHOOSE_BADGE)}
    wait_poll(:until_exists => "* marked:'#{badge}'", :timeout => 60, :post_timeout => 1) do 
      perform_action('drag', 50, 50, 70, 50, 5)
    end
    touch("* marked:'#{badge}'")
    #wait_for(:timeout => 30){element_exists(BTN_POST)}
  end

  # Write the given recognition 
  # @recognition_text
  def write_recognition(recognition_text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_GIVE_RECOGNITION)}
    flash(TXV_GIVE_RECOGNITION)
    touch(TXV_GIVE_RECOGNITION)
    enter_text(TXV_GIVE_RECOGNITION, recognition_text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Post'")}
    touch("* marked:'Post'")
    wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist("* marked:'Post'")}
  end

  # Write post
  # @param text
  def write_post(text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_POST)}
    touch(TXF_COMMENT)
    enter_text(TXF_COMMENT, text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Post'")}
    touch("* marked:'Post'")
    wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist("* marked:'Post'")}
  end

  # Write comment
  # @param text
  def write_comment(text) 
    wait_for(:timeout => 30){element_exists(TXV_NEWS_FEED)}

    wait_poll(:retry_frequency => 0.5, :until_exists => TXF_POST_A_COMMENT) do
      perform_action('drag', 50, 50, 70, 50, 5)
    end

    perform_action('drag', 50, 50, 70, 55, 5)
        
    touch(TXF_POST_A_COMMENT)
    enter_text(TXF_POST_A_COMMENT, text)
    click_button('Post comment')
    wait_for(:timeout => 30, :post_timeout => 1){query("* id:'view_comment_item_user_comment_time'")[0]['text'] == "a few seconds ago"}
    
    #validate the the comment is visible
    found_match = false
      
      if query("* id:'view_comment_item_user_comment'")[0]['text'] == text
        found_match = true
      end     

    if !found_match
      fail(msg = "Error. write_comment. The comment: #{text} was not found in the feed.")
    end
  end

 
  # Check that the given recognition is first the feed
  # @param recognition_text
  def check_recognition_is_first(badge, recognition_text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_feed_recognition_secondary_text' index:0")}
    recognition_in_feed = query("* id:'view_feed_recognition_secondary_text' index:0")[0]['text']
    badge_in_feed = query("* id:'view_feed_recognition_badge_name' index:0")[0]['text']

    if recognition_in_feed != recognition_text 
      fail(msg = "Error. check_recognition_is_first. Recognition found in the feed: #{recognition_in_feed} is not match to '#{recognition_text}'")
    end

    if badge_in_feed != badge
      fail(msg = "Error. check_recognition_is_first. Badge found in the feed: #{badge_in_feed} is not match to '#{badge}'")
    end
  end

  # Check that the given post is first the feed
  # @param post_text
  def check_post_is_first (post_text)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_feed_post_text_content' index:0")}
    post_in_feed = query("* id:'view_feed_post_text_content' index:0")[0]['text']

    if post_in_feed != post_text 
      fail(msg = "Error. check_post_is_first. Post found in the feed: #{post_in_feed} is not match to '#{post_text}'")
    end
  end

  # search for post. This function is not 100% bullet proof. In case
  # of two identical posts that are neighbors the search stop (because 'last post issue')
  # @param post_text 
  # @param state - 'is not in' or 'is in'


  def search_in_feed (post_text, state)
   
    wait_for(:timeout => 30){element_exists("* id:'activity_navigation_search_field'")}
    query("* id:'activity_navigation_search_field'",{:setText => "#{post_text}"})

    hide_soft_keyboard

    case state
    when 'is not in'
      wait_for(:timeout => 30){element_exists(TXV_NO_RESULTS)}
    when 'is in'
      wait_for(:timeout => 30){element_exists("* id:'view_feed_post_container'")}
      
      temp_post_sender = ""
      temp_feed_text = ""

      # while the last feed is not idantical to the current feed
      while !((temp_post_sender == query("* id:'view_feed_post_text_content'")[0]['text']) && (temp_feed_text == query(("* id:'view_feed_post_text_content'")[1]['text'])))
        
        # the news i
        text = query("* id:'view_feed_post_text_content'")[1]['text']
        puts "#{text}"

        # compare the top post
        if (/#{post_text}/i.match text) == nil    
          fail(msg = 'Error. search_in_feed. Result that is not matched appear')
        end

        temp_feed_text = text
        temp_post_sender = query("* id:'view_feed_post_text_content'")[0]['text']
        
        # if a second is visible in the current view
        if element_exists("* id:'view_feed_post_text_content' index:1")
          
          text = query("* id:'view_feed_post_text_content'")[1]['text']
          temp_feed_text = text
          temp_post_sender = query("* id:'view_feed_post_text_content'")[0]['text']
          puts "#{text}"
        
          if (/#{post_text}/i.match text) == nil    
            fail(msg = 'Error. search_in_feed. Result that is not matched appears in the results')
          end
        end

       
        # scroll even if in the view there is one post. Because there is edge case where the post is too big so in the current view
        # there is only one post but maybe there is another post below
        scroll("android.support.v7.widget.RecyclerView", :down)
        sleep(0.5)

        # another edge case. The post in the second place can be in the first place after scrolling so in this case the while loop will stop. To avoid it scroll another time
        if (temp_post_sender == query("* id:'view_feed_post_text_content'")[0]['text']) && (temp_feed_text == query("* id:'view_feed_post_text_content'")[1]['text'])
          scroll("android.support.v7.widget.RecyclerView", :down)
          sleep(0.5)

          # if there is no option to scroll more check the first post and the scoend if it exists
          if (temp_post_sender == query("* id:'view_feed_post_text_content'")[0]['text'] && temp_feed_text == query("* id:'view_feed_post_text_content'")[1]['text'])
            if element_exists("* id:'view_feed_post_text_content' index:1") 
              text_2 = query("* id:'view_feed_post_text_content'")[1]['text']
              puts "#{text_2}"
              
              # check the second if it exsits 
              if (/#{post_text}/i.match text_2) == nil    
                fail(msg = 'Error. search_in_feed. Result that is not matched appears in the results')
              end
            end

            break
          end

          temp_feed_text = query("* id:'view_feed_post_text_content'")[1]['text']
          temp_post_sender = query("* id:'view_feed_post_text_content'")[0]['text']

          puts "in2: #{temp_feed_text}"
          puts "in2: #{temp_post_sender}"
        end  
      end
      press_button('KEYCODE_BACK')
    end
  end

  def refresh_page
    perform_action('drag', 50, 50, 40, 70, 5)
    wait_for(:timeout => 30){element_does_not_exist(TXV_NEW_POSTS)}
  end

end
