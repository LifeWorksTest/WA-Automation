	# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSColleaguesDirectoryPage < Calabash::IBase
  LBL_COLLEAGUES_DIRECTORY = "UISegmentLabel marked:'Directory'"
  LBL_SELECT_A_BADGE = "UILabel marked:'#{IOS_STRINGS["WAMSelectBadgeTitle"]}'"
  LBL_LAST_MONTH = "label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerLastMonth"]}'"
  TXF_SEARCH = "* marked:'search icon'"

  BTN_CANCEL = "UINavigationButton marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'"
  BTN_BACK = "UINavigationBar descendant * index:6"
  BTN_POST = "button marked:'#{IOS_STRINGS["WAMFeedPostTitle"]}'"
  BTN_GIVE_RECOGNITION = "button view:'WAMProfileHeaderGiveRecognitionButton'"
  BTN_LEADERBOARD = "UISegmentLabel marked:'Leaderboard'"
  
  def trait
    LBL_COLLEAGUES_DIRECTORY
  end
  
  def click_button (button)
    case button
    when 'Give Recognition'
      sleep(1)
      wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
      touch(BTN_GIVE_RECOGNITION)
      wait_for(:timeout => 30){element_exists(LBL_SELECT_A_BADGE)}
    when 'Post'
      wait_for(:timeout => 30){element_exists(BTN_POST)}
      touch(BTN_POST)
      wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
    when 'Back'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      wait_for(:timeout => 30){element_exists(LBL_COLLEAGUES_DIRECTORY)}
    when 'Cancel'
      wait_for(:timeout => 30){element_exists(BTN_CANCEL)}
      touch(BTN_CANCEL)
      sleep(0.5)
      wait_for(:timeout => 30){element_does_not_exist(BTN_CANCEL)}
    when 'Leaderboard'
      wait_for(:timeout => 30){element_exists(BTN_LEADERBOARD)}
      touch(BTN_LEADERBOARD)
      sleep(0.5)
      wait_for(:timeout => 30){element_exists(LBL_LAST_MONTH)}
    else 
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end

    sleep(0.8)
  end

  # Give recognition from colleague by the index in colleagues directory
  # @param recognition_text 
  # @param colleague_index
  def give_recognition_to (recognition_text, colleague_index)
    wait_for(:timeout => 30){element_exists("view:'WAMColleagueDirectoryTableViewCell' index:#{colleague_index}")}
    touch("view:'WAMColleagueDirectoryTableViewCell' index:#{colleague_index}")
    wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
    
    click_button('Give Recognition')

    wait_for(:timeout => 30){element_exists("WAMGiveRecognitionBadgeTableViewCell index:1")}
    touch("WAMGiveRecognitionBadgeTableViewCell index:1")

    wait_for_keyboard
    wait_for_none_animating
    keyboard_enter_text(recognition_text)
    sleep(0.8)

    click_button('Post')
    click_button('Back')
  end 

  # Search for colleague by it's name
  # @param colleague_name
  # @param state - 'is not in' or 'is in'
  def search_for_colleague (colleague_name, state)  
    touch(TXF_SEARCH)
    wait_for_keyboard
    keyboard_enter_text(colleague_name)
    puts "#{colleague_name}"
    wait_for_none_animating

    case state
    when 'is not in'
      
      if !element_exists("UILabel marked:'Uh oh, no results!'")
        fail(msg = "Error. search_for_colleague. Expected to 0 results for #{colleague_name} but there is more then 0.")
      end
    
    when 'is in'
      number_of_match_results = query("view:'WAMColleagueDirectoryTableViewCell'").size - 2       
      
      for i in 0..number_of_match_results

        # There are cases where this element in place 0 is nil so beacuse of scroll function
        if query("view:'WAMColleagueDirectoryTableViewCell' index:#{i} descendant label")[0] == nil
          puts "Next"
          next
        end
        
        puts "#{i} #{query("view:'WAMColleagueDirectoryTableViewCell' index:#{i} descendant label")[0]['label']}"

        if (/#{colleague_name}/i.match query("view:'WAMColleagueDirectoryTableViewCell' index:#{i} descendant label")[0]['label']) == nil
          if (/#{colleague_name}/i.match query("view:'WAMColleagueDirectoryTableViewCell' index:#{i} descendant label")[1]['label']) == nil        
            fail(msg = 'Error. search_for_colleague. Result that is not matched appears in the results')
          end
        end
      end
    click_button('Cancel')  
    end
  end
end
