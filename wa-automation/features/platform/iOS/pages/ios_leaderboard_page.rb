# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSLeaderboardPage < Calabash::IBase
  BTN_CLOSE = "button marked:'bt close white'"
  BTN_BACK = "UINavigationBar descendant * index:6"
  BTN_POST = "button marked:'#{IOS_STRINGS["WAMFeedPostTitle"]}'"

  LBL_LEADERBOARD = "label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerTitle"]}'"
  LBL_THIS_MONTH = "label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerThisMonth"]}'"
  LBL_LAST_MONTH = "label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerLastMonth"]}'"
  LBL_ALL_TIME = "label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerAllTime"]}'"
  LBL_RECOGNITIONS = "label marked:'#{IOS_STRINGS["WAMIndividualRecognitionsTitle"]}'"

  IMG_SPINNER = "imageView id:'spin'"

  def trait
    LBL_LEADERBOARD
  end

  def click_button (button)
    case button
    when 'Close'
      wait_for(:timeout => 30){element_exists(BTN_CLOSE)}
      touch(BTN_CLOSE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_CLOSE)}
    when 'Back'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      touch(BTN_BACK)
    when 'This Month'
      wait_for(:timeout => 30){element_exists(LBL_THIS_MONTH)}
      touch(LBL_THIS_MONTH)
      sleep(0.8)
    when 'Last Month'
      wait_for(:timeout => 30){element_exists(LBL_LAST_MONTH)}
      touch(LBL_LAST_MONTH)
      sleep(0.8)
    when 'All Time'
      wait_for(:timeout => 30){element_exists(LBL_ALL_TIME)}
      touch(LBL_ALL_TIME)
      sleep(0.8)
    when 'Post'
      wait_for(:timeout => 30){element_exists(BTN_POST)}
      touch(BTN_POST)
      wait_for(:timeout => 15){element_exists(BTN_POST)}
    else
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end

    wait_for_none_animating
  end

  # Give recognition from colleague by the index in colleagues directory
  # @param recognition_text
  # @param colleague_index
  def give_recognition (recognition_text, colleague_index)
    open_menu(colleague_index)
    wait_for(:timeout => 30){element_exists("WAMGiveRecognitionBadgeTableViewCell")}
    touch("WAMGiveRecognitionBadgeTableViewCell")

    wait_for_none_animating
    keyboard_enter_text(recognition_text)
    click_button('Post')
  end

  # Open the hidden menu under each cell
  # @param index - the index number of the cell
  def open_menu (index)
    flick "UITableViewCellContentView index:#{index}", {x:-50, y:0}
    touch("button marked:'icon swipe rec solid'")
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMSelectBadgeTitle"]}'")}
    wait_for_none_animating
  end

  # check up to the first 5
  def check_table_is_sorted 
    wait_for(:timeout => 30,:post_timeout => 1){element_exists("UITableViewCellContentView")}
    first_index = 0

    last_index = query("UITableViewCellContentView").size - 4
    puts "last_index:#{last_index}"

      for i in first_index..last_index
        
        if query("WAMLeaderboardTableViewCell index:#{i} descendant *").count == 2
          rank_1 =  query("WALeaderboardMyPositionView descendant * UILabel index:0")[0]['text'].to_i
          number_of_recognition_1 = query("WALeaderboardMyPositionView descendant * UILabel index:3")[0]['text'].to_i
        else
          rank_1 = query("view:'WAMLeaderboardTableViewCell' index:#{i} descendant * index:4")[0]['label'].to_i
          number_of_recognition_1 = query("view:'WAMLeaderboardTableViewCell' index:#{i} descendant label")[2]['label'].to_i
        end

        if query("WAMLeaderboardTableViewCell index:#{i+1} descendant *").count == 2
          rank_2 =  query("WALeaderboardMyPositionView descendant * UILabel index:0")[0]['text'].to_i
          number_of_recognition_2 = query("WALeaderboardMyPositionView descendant * UILabel index:3")[0]['text'].to_i
        else
          rank_2 = query("view:'WAMLeaderboardTableViewCell' index:#{i+1} descendant * index:4")[0]['label'].to_i
          number_of_recognition_2 = query("view:'WAMLeaderboardTableViewCell' index:#{i+1} descendant label")[2]['label'].to_i
        end
      end 

      if rank_1 > rank_2
        fail(msg = 'Error. check_table_is_sorted. Table is not sorted well. rank_1=#{rank_1} rank_2=#{rank_2}.')
      end
    
      if number_of_recognition_1 < number_of_recognition_2
        fail(msg = 'Error. check_table_is_sorted. Table is not sorted well. number_of_recognition_1=#{number_of_recognition_1} number_of_recognition_2=#{number_of_recognition_2}.')
      end

      puts "rank_1=#{rank_1} rank_2=#{rank_2}"
      puts "number_of_recognition_1=#{number_of_recognition_1} number_of_recognition_2=#{number_of_recognition_2}"
  end  

  # Open colleague recognitions list
  # @param colleague_name
  def see_colleague_recognitions (colleague_name)
    wait_for(:timeout => 30){element_exists("label marked:'#{colleague_name}'")}
    colleague_roll = query("label marked:'#{colleague_name}' parent * index:0 descendant label")[1]['label']

    touch("label marked:'#{colleague_name}'")
    wait_for(:timeout => 30){element_exists(LBL_RECOGNITIONS)}
    wait_for(:timeout => 30){element_exists("label marked:'#{colleague_name}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{colleague_roll}'")}
  end

  # Go over all user recognitions and check that each badge have the right a
  def go_over_user_recognitions
    wait_for(:timeout => 30){element_exists("view:'WAMIndividualRecognitionTableViewCell'")}
    number_of_celles = query("view:'WAMIndividualRecognitionTableViewCell'").size - 2
    puts "number_of_celles:#{number_of_celles}"

    for i in 0..number_of_celles
      wait_for_none_animating
      puts "i:#{i}"
      wait_for(:timeout => 30){element_exists("view:'WAMIndividualRecognitionTableViewCell' index:#{i}")}
      badge_hashtag = query("view:'WAMIndividualRecognitionTableViewCell' index:#{i} label")[1]['label']
      puts "badge_hashtag:#{badge_hashtag}"
      badge_name = BADGES[badge_hashtag]
      touch("view:'WAMIndividualRecognitionTableViewCell' index:#{i}")
      wait_for_none_animating
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      wait_for(:timeout => 30){element_exists("label marked:'#{badge_name}'")}
      click_button('Back')
    end
  end
end
