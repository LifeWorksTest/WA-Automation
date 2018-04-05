# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSNewsFeedPage < Calabash::IBase
  LBL_NEWS_FEED = "label marked:'#{IOS_STRINGS["WAMMenuItemRecognitionFeedTitle"]}'"
  LBL_SELECT_COLLEAGUES = "label marked:'#{IOS_STRINGS["WAMRecognizeColleaguesViewControllerTitle"]}'"
  LBL_GIVE_RECOGNITION = "label marked:'#{IOS_STRINGS["WAMMenuItemGiveNewRecognitionTitle"]}'"
  LBL_NEW_POST = "label marked:'#{IOS_STRINGS["WAMRecogntionFeedSendPostTitle"]}'"
  LBL_WRITE_A_COMMENNT = "label marked:'Write a comment'"

  LBL_SEARCH_POSTS = "label marked:'#{IOS_STRINGS["WAMRecognitionFeedSearchPlaceholder"]}'"
  LBL_SNACK_COMPLETED = "label marked:'#{IOS_STRINGS["WAMWBNewsFeedSessionCompleteComeBackTomorrowHeaderTitle"]}'"
  LBL_DAILY_SNACK = "UILabel marked:'#{IOS_STRINGS["WAMWBArticleVCTitle"]}'"
  LBL_DAILY_SNACK_WELLBEING = "UILabel marked:'#{IOS_STRINGS["WAMWBNewsFeedYourDailyWellbeing"]}'"
  LBL_SKIPPED = "UILabel marked: '#{IOS_STRINGS["WAMWBNewsFeedReEngagementSkippedSubtitle"][0..-4]}'"
  LBL_NEW_TOPIC  = "UILabel marked:'#{IOS_STRINGS["WBReflectionContinueTitle"]}'"

  BTN_POST = "button marked:'#{IOS_STRINGS["WAMGiveRecognitionPostLabel"]}'"
  BTN_NEXT = "button marked:'#{IOS_STRINGS["WAMFoundationNextKey"]}'"
  BTN_GIVE_RECOGNITION = "button marked:'#{IOS_STRINGS["WAMGiveRecognitionTitleLabel"]}'"
  BTN_CREATE_NEW_POST = "button marked:'#{IOS_STRINGS["WAMRecognitionFeedButtonBarCreateNewPostTitle"]}'"
  BTN_SELECT_BADGE = "* id:'giverecognition_icn_badges'"
  BTN_BACK = "UINavigationBar child * index:1 descendant * index:4"
  BTN_SEARCH = "* marked:'search icon'"
  BTN_CANCEL = "button marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'"
  BTN_DONE = "button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'"
  BTN_START_SNACK = "WAMBackgroundButton"
  BTN_FINISIH_READING = "button marked:'#{IOS_STRINGS["WAMWBVCSessionFinishReadingButton"]}'"
  BTN_LIKE_ARTICLE = "* id:'btnThumbsUpInactive'"
  BTN_REFINE = "UIButtonLabel marked:'#{IOS_STRINGS["WAMFeedFilterRefineTitle"]}'"
  BTN_CLOSE = "UIButtonLabel marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'"
  BTN_SKIP = "UIButtonLabel marked:'#{IOS_STRINGS["WAMFoundationSkip"]}'"
  BTN_SET_ANOTHER_TOPIC = "WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedSkipAnotherInterest"]}'"
  BTN_NO_CONTINUE = "WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedSkipContinue"]}'"
  BTN_SELECT_NEW_WELLEBING_TOPIC  = "UIButtonLabel marked:'#{IOS_STRINGS["WBReflectionBottomTitle"]}'"
  BTN_SEND = "UIButtonLabel marked:'#{IOS_STRINGS["WAMFoundationSendKey"]}'"

  TXV_WRITE_A_COMMENT = "textView text:'#{IOS_STRINGS["WAMRecogntionFeedSendCommentPlaceHolderText"]}'"

  IMG_SPINNER = "imageView id:'spin'"

  def trait
    wait_for_none_animating
    LBL_NEWS_FEED
  end

  def click_button (button)
    case button
    when 'Next'
      wait_for(:timeout => 30){element_exists(BTN_NEXT)}
      touch(BTN_NEXT)
      wait_for(:timeout => 30){element_does_not_exist(BTN_NEXT)}
    when 'Cancel'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists("UISearchBarTextField")}
      touch("UISearchBarTextField")
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_CANCEL)}
      flash(BTN_CANCEL)
      touch(BTN_CANCEL)
      wait_for(:timeout => 30){element_does_not_exist("UISearchBarTextField")}
    when 'Search'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      wait_for(:timeout => 30){element_exists(LBL_SEARCH_POSTS)}
    when 'Back'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
    when 'Give Recognition'
      wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
      touch(BTN_GIVE_RECOGNITION)
      wait_for(:timeout => 30){element_exists(BTN_NEXT)}
    when 'Create New Post'
      wait_for(:timeout => 30){element_exists(BTN_CREATE_NEW_POST)}
      touch(BTN_CREATE_NEW_POST)
      wait_for(:timeout => 30){element_exists(LBL_NEW_POST)}
    when 'select badge'
      wait_for(:timeout => 30){element_exists(BTN_SELECT_BADGE)}
      sleep(1)
      touch(BTN_SELECT_BADGE)
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMSelectBadgeTitle"]}'")}
    when 'Post'
      wait_for(:timeout => 30){element_exists(BTN_POST)}
      touch(BTN_POST)
      wait_for(:timeout => 30){element_does_not_exist(BTN_POST)}
      wait_for(:timeout => 30){element_exists(LBL_NEWS_FEED)}
      refresh_page
    when 'Post Comment'
      wait_for(:timeout => 30){element_exists(BTN_POST)}
      touch(BTN_POST)
      wait_for(:timeout => 30){element_does_not_exist(BTN_POST)}
    when 'Add a comment...'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(LBL_ADD_COMMENNT)}
      touch(LBL_ADD_COMMENNT)
      wait_for(:timeout => 30){element_exists(TXV_WRITE_A_COMMENT)}
    when 'New Posts'
      wait_for(:timeout => 30, :post_timeout => 0.5){element_exists("label marked:'New Posts'")}
      touch("label marked:'New Posts'")
    when 'Done'
      wait_for(:timeout => 30){element_exists(BTN_DONE)}
      touch(BTN_DONE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_DONE)}
    when 'Start Snack'
      snack_type = determine_article_type
      if (snack_type == 'read_now' || snack_type == 'continue_reading')
        wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_START_SNACK)}
        touch(BTN_START_SNACK)
        wait_for(:timeout => 30){element_does_not_exist(BTN_START_SNACK)}
      else
        fail(msg = "Error. Start Snack. #{snack_type} type is not supported on iOS - Test environment.")
      end
    when 'Like Article'
      wait_for(:timeout => 30){element_exists(BTN_LIKE_ARTICLE)}
      touch(BTN_LIKE_ARTICLE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_LIKE_ARTICLE)}
    when 'Finish Reading'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_FINISIH_READING)}
      touch(BTN_FINISIH_READING)
      wait_for(:timeout => 30){element_does_not_exist(BTN_FINISIH_READING)}
    when 'Set Another Interest'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_SET_ANOTHER_TOPIC)}
      touch(BTN_SET_ANOTHER_TOPIC)
      wait_for(:timeout => 30){element_exists(LBL_NEW_TOPIC)}
      wait_for(:timeout => 30){element_exists(LBL_NEW_TOPIC)}
    when 'No Continue'
      touch(Start Snack)
    else
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end
  end

  # Refresh the page by scroll up
  def refresh_page
    wait_for(:timeout => 30, :post_timeout => 0.5){element_exists(LBL_NEWS_FEED)}
    flick "UIView", {x:200, y:200}
    sleep(2)
  end

  # Check that a specific post or recognition is in the first view of the feed
  # @param text_to_search
  def check_post_or_recognition_in_feed (text_to_search)

    wait_poll(:retry_frequency => 0.5, :until_exists => "WAMBackgroundButton") do
      scroll("scrollView", :down)
    end

    wait_for_none_animating
    wait_for(:timeout => 30, :post_timeout => 0.5){element_exists("label marked:'#{text_to_search}'")}

    if !element_exists("label marked:'#{text_to_search}'")
      fail(msg="Error. check_post_in_feed. The text: #{text_to_search} was not found in the feed.")
    end
  end

  # Write Comment
  # @param comment_text
  def write_comment (comment_text)
    wait_for_none_animating

    wait_poll(:retry_frequency => 0.5, :until_exists => "label marked:'Write a comment' * index:0") do
      scroll("scrollView", :up)
    end

    scroll("scrollView", :down)
    wait_for_none_animating

    touch("label marked:'Write a comment' * index:0")
    wait_for_keyboard
    keyboard_enter_text(comment_text)
    wait_for(:timeout => 30){element_exists("UIButtonLabel marked:'Send'")}
    touch("UIButtonLabel marked:'Send'")
    wait_for_none_animating
    wait_for(:timeout => 30){element_does_not_exist("UIButtonLabel marked:'Send'")}

    #validate the the comment is visible
    found_match = false
      comment_label_array = query("TTTAttributedLabel")
      
      for array_index in 0..comment_label_array.size - 1
        if (comment_label_array[array_index]['text'] != nil) && (comment_label_array[array_index]['text'].include? comment_text)
          found_match = true
          break
        end     
      end

    if !found_match
      fail(msg = "Error. write_comment. The comment: #{comment_text} was not found in the feed.")
    end

    wait_for_none_animating
    like_or_unliked('Like')
    like_or_unliked('Liked')
  end

  # Write recognition (only type the text)
  # @param recognition_text
  def write_recognition (recognition_text)
    wait_for_keyboard
    wait_for_none_animating
    keyboard_enter_text(recognition_text)
    sleep(0.8)
  end

  # Write post
  # @param recognition_text
  def write_post (recognition_text)
    wait_for_keyboard
    keyboard_enter_text(recognition_text)

    click_button('Post')
  end

  # Like or unlike post
  # @param
  def like_or_unliked (like_unlike)
    if like_unlike == 'Like'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists("WorkAngel.FeedLikeActionBarCell descendant * index:5")}
      touch("WorkAngel.FeedLikeActionBarCell descendant * index:4")
      wait_for(:timeout => 30){element_exists("UIButtonLabel marked:'#{IOS_STRINGS["WAMRecognitionFeedButtonLike"]}'")}
    elsif like_unlike == 'Liked'
      wait_for(:timeout => 30){element_exists("UIButtonLabel marked:'#{IOS_STRINGS["WAMRecognitionFeedButtonLike"]}'")}
      touch("UIButtonLabel marked:'#{IOS_STRINGS["WAMRecognitionFeedButtonLike"]}'")
      wait_for(:timeout => 30){element_does_not_exist("UIButtonLabel marked:'#{IOS_STRINGS["WAMRecognitionFeedButtonLike"]}'")}
    end
  end

  # Select the user to give recognition
  # @param user_name
  def select_user (user_name)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists(LBL_SELECT_COLLEAGUES)}

    wait_poll(:retry_frequency => 0.5, :until_exists => "label marked:'#{user_name}'", :timeout => 30) do
      scroll("scrollView", :down)
    end

    touch("label marked:'#{user_name}'")
    sleep(0.8)

    # check if the user name is inside the box of user that will get recogntion
    name = query("collectionView descendant label")[0]["label"]

    if ! user_name.include? name
       fail(msg="Error. select_user. The comment: #{name} was not found in box which contains the user that will get recognition.")
    end
  end

  # Choose badge to add to the recognition
  # @param badge_name
  def choose_badge (badge_name)

    #while !element_exists("label marked:'#{badge_name}'")
    wait_poll(:retry_frequency => 0.5,:until_exists => "label marked:'#{badge_name}'", :timeout => 30) do
      scroll("scrollView index:0", :down)
      sleep(0.8)
    end

    touch("label marked:'#{badge_name}'")
    sleep(0.8)
  end

  # Select Cancel button from Select a Badge screen
  def back_to_news_feed
    wait_for(:timeout => 30){element_exists("UIButtonLabel index:0")}
    flash("UIButtonLabel index:0")
    touch("UIButtonLabel index:0")
    wait_for(:timeout => 30){element_exists("UIButtonLabel index:0")}
    flash("UIButtonLabel index:0")
    touch("UIButtonLabel index:0")
    wait_for(:timeout => 30){element_exists(LBL_NEWS_FEED)}
  end

  # Go over all badges and chack that the badge name is match to the badge hash tag
  def check_badges
    BADGES.each { |key, value|
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMSelectBadgeTitle"]}'")}
      wait_for_none_animating

      # TODO - Confirm that logic that values are always lowercased
      # Badge Creative is used for recognition in Hermes news feed page, line 134 and hence first char of value needs to be uppercase
      if (key.match(/\p{Upper}/) != nil) && (value.match(/\p{Upper}/) == nil)
        wait_poll(:retry_frequency => 0.5, :until_exists => "label marked:'#{key}'", :timeout => 30) do
          scroll("scrollView", :down)
        end

        touch("label marked:'#{key}'")

        if element_exists(BTN_DONE)
          click_button('Done')
        end

        wait_for(:timeout => 60){element_exists("UILabel marked:'#{value}'")}
        click_button('select badge')
      end
    }
  end

  # Search for post. This function is not 100% bullet proof (because index issue)
  # THERE IS BUG FROM THE SERVER SIDE
  # @param feed_text
  # @param state - 'is not in' or 'is in'
  def search_in_feed (post_text, state)
    click_button('Search')
    wait_for_keyboard
    keyboard_enter_text(post_text)
    tap_keyboard_action_key

    case state
    when 'is not in'
      wait_for(:timeout => 30){element_exists("imageView id:'empty_view_no_results'")}
      wait_for(:timeout => 30){element_does_not_exist("view:'WAMRecognitionFeedUserPostGenericCell'")}
      touch("button marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'")
      wait_for_none_animating
      LBL_NEWS_FEED
    when 'is in'
      wait_for(:timeout => 30){element_exists("WorkAngel.FeedGenericComplexBodyCell")}

      i = 0
      while element_exists("WorkAngel.FeedGenericComplexBodyCell index:#{i}") || i < 2
        touch("WorkAngel.FeedGenericComplexBodyCell index:#{i}")
        wait_for_none_animating

        found_match = false
        label_array = query 'label'

        for array_index in 0..label_array.size - 1
          if label_array[array_index]['text'].match post_text
            found_match = true
            break
          end
          i += 1
        end

        click_button('Back')
      end
    end

    click_button('Cancel')
  end

  # @param max_sessions
  # @param like_article
  # Verifies that you can only view x amount of snackable articles per day
  def verify_snackable_session_limit (max_sessions, like_article = true)
    max_sessions = max_sessions.to_i

    for i in 1..max_sessions
      scroll("scrollView", :up)
      click_button('Start Snack')

      wait_poll(:retry_frequency => 0.5, :until_exists => BTN_FINISIH_READING) do
        scroll("scrollView", :down)
        sleep(1)
      end

      click_button('Finish Reading')
      click_button('Like Article')
      wait_for_none_animating
      sleep(0.5)

      #Scrolls till it finds Refine button on the top of the screen
      wait_poll(:retry_frequency => 0.5, :until_exists => BTN_GIVE_RECOGNITION) do
        scroll("scrollView", :up)
      end
    end
    wait_for(:timeout => 30){element_exists(LBL_SNACK_COMPLETED)}
  end

 # Returns the snackable button name eg 'Read, Listen or 'Watch' now
  def determine_article_type (continue_snack = false)
    wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_START_SNACK)}

    if !continue_snack
      if element_exists("WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedContentStartReading"]}'")
        @SNACK_TYPE = 'read_now'
      elsif element_exists("WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedContentStartWatching"]}'")
        @SNACK_TYPE = 'watch_now'
      elsif element_exists("WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedContentStartListening"]}'")
        @SNACK_TYPE = 'listen_now'
      else
        fail(msg= 'Error. determine_article_type. Link to snack is not present')
      end
    else
      # Pardha  - No tranlsation for Continue Reading, issue to be raised
      if element_exists("WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedContentContinueReading"]}'")
        @SNACK_TYPE = 'continue_reading'
      elsif element_exists("WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedContentContinueWatching"]}'")
        @SNACK_TYPE = 'continue_watching'
      elsif element_exists("WAMBackgroundButton marked:'#{IOS_STRINGS["WAMWBNewsFeedContentContinueListening"]}'")
        @SNACK_TYPE = 'continue_listening'
      else
        fail(msg= 'Error. determine_article_type. Link to snack is not present')
      end
    end
    return @SNACK_TYPE
  end

  # @params set_another_interest
  # Verifies re_engagement functionality for snackable. Eg You can re set topics if you skip an article 3 times
  def verify_re_engagement (set_another_interest)

    for i in 1..3 do
      click_button('Start Snack')
      wait_for(:timeout => 30){element_exists(LBL_DAILY_SNACK)}
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_CLOSE)}
      touch(BTN_CLOSE)
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_SKIP)}
      touch(BTN_SKIP)

      if i < 3
        wait_for(:timeout => 30){element_exists(LBL_DAILY_SNACK_WELLBEING)}
      else
        wait_for(:timeout => 30){element_exists(BTN_SET_ANOTHER_TOPIC)}
        wait_for(:timeout => 30){element_exists(BTN_NO_CONTINUE)}

        if set_another_interest
          click_button('Set Another Interest')
          wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_CLOSE)}
          touch(BTN_CLOSE)
        else
          click_button('No Continue')
        end
      end
    end

  end
end
