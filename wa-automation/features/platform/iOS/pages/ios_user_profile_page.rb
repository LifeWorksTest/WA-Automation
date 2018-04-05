# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSUserProfilePage < Calabash::IBase
  BTN_DONE = "button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'"
  BTN_SAVE_PROFILE = "button marked:'#{IOS_STRINGS["WAMEditUserProfileSaveProfileButtonTitle"]}'"
  BTN_HOME =  "* id:'view_toolbar_wrapper_toolbar' imageButton"
  BTN_EDIT_PROFILE = "button marked:'#{IOS_STRINGS["WAMEditUserProfileTitle"]}'"
  BTN_NEXT = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingCategoriesNextButton"]}'"
  BTN_EXPLORE = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingSummaryStartButtonText"]}'"
  BTN_BACK = "UINavigationBar child * index:1 descendant * index:4"
  BTN_BACK_WHITE = "UIButton marked:'ic back white arrow'"
  BTN_SETTINGS = "button marked:'icnSettingsActive'"

  LBL_NEWS_FEED = "label marked:'#{IOS_STRINGS["WAMMenuItemRecognitionFeedTitle"]}'"
  LBL_SNACKABLE_TOPICS = "label marked:'#{IOS_STRINGS["WAMSettingsTypeWellbeingInterests"]}'"
  LBL_CHOOSE_TOPICS = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingCategoriesPleaseSelect"]}'"
  LBL_SELECT_TOPICS = "label marked:'#{IOS_STRINGS["WAMWBVCOnboardingSubcategoriesPleaseSelect"]}'"
  LBL_JOINED = "#{IOS_STRINGS["WAMUserProfileHeaderJoined"]}"[0..-4]

  TXT_ACHIEVEMENT = ("#{IOS_STRINGS["WAMUserProfileAchievementsTitle"]}"[0..-2])
  TXT_INTEREST = ("#{IOS_STRINGS["WAMUserProfileInterestsTitle"]}"[0..-2])
  TXT_JOINED = ("#{IOS_STRINGS["WAMTimelineJoined"]}".capitalize)

  def trait
    BTN_EDIT_PROFILE
  end

  def click_button (button)
    case button
    when 'Home Btn'
      wait_for(:timout => 10){element_exists(BTN_HOME)}
      touch(BTN_HOME)
      sleep(1)
    when 'Done'
      wait_for(:timout => 10){element_exists(BTN_DONE)}
      touch(BTN_DONE)
      sleep(0.5)
    when 'Edit Profile'
      wait_for(:timout => 10){element_exists(BTN_EDIT_PROFILE)}
      touch(BTN_EDIT_PROFILE)
      wait_for(:timout => 10){element_exists(BTN_SAVE_PROFILE)}
    when 'Save Profile'
      wait_for(:timout => 10){element_exists(BTN_SAVE_PROFILE)}
      touch(BTN_SAVE_PROFILE)
      wait_for(:timout => 10){element_exists(BTN_EDIT_PROFILE)}
    when 'Settings'
      sleep(0.5)
      wait_for(:timout => 10){element_exists(BTN_SETTINGS)}
      touch(BTN_SETTINGS)
      wait_for(:timout => 10){element_exists( "label marked:'#{IOS_STRINGS["WAMFoundationSettings"]}'")}
    when 'Back'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_BACK)}  
    when 'Log out'
      sleep(1)
      scroll("scrollView", :down)
      wait_for_none_animating
      wait_for(:timout => 10){element_exists(BTN_LOGOUT)}
      touch(BTN_LOGOUT)
      wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")}
      sleep(0.5)
      touch("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")
      wait_for(:timout => 10){element_exists("button marked:'#{IOS_STRINGS["WAMLMLandingLogin"]}'")}
    when 'Snackable'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(LBL_SNACKABLE_TOPICS)}
      touch(LBL_SNACKABLE_TOPICS)
      wait_for(:timeout => 30){element_exists(LBL_CHOOSE_TOPICS)}
    when 'Next'
      wait_for(:timeout => 30){element_exists(BTN_NEXT)}
      flash(BTN_NEXT)
      touch(BTN_NEXT)
      wait_for(:timeout => 10) {element_does_not_exist("button marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'")}
    when 'Explore'
      wait_for(:timeout => 30){element_exists(BTN_EXPLORE)}
      flash(BTN_EXPLORE)
      touch(BTN_EXPLORE)
      wait_for(:timout => 30, :post_timeout => 1){element_does_not_exist(BTN_EXPLORE)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Check that the carousel have data
  def validate_carousel_data
    user_name_from_bar = query("WAMUserProfileHeaderView * label")[0]['text']

    if user_name_from_bar != ACCOUNT[:"#{$account_index}"][:valid_ios_account][:user_name]
      fail(msg = "Error. validate_carousel_data. User name is not match in the carousel: #{user_name_from_bar} and in the the DB:#{ACCOUNT[:"#{$account_index}"][:valid_ios_account][:user_name]}.")
    end

    for i in 0..2

      if i != 2
        if query("WAMUserProfileHeaderView * label index:0")[0]['text'] ==  nil || query("WAMUserProfileHeaderView * label index:1")[0]['text'] == nil
          fail(msg = 'Error. check_carousel. Field number #{i} is nil')
        end
      else
         if query("WAMUserProfileHeaderView * label index:1")[0]['text'] == nil
          fail(msg = 'Error. check_carousel. Field number 3 is nil')
        end
      end

      scroll("scrollView index:1", :right)
      wait_for_none_animating
    end
  end

  # Check that the details are not nil
  def check_user_profile_data
    wait_poll(:retry_frequency => 0.5, :until_exists => "label {text BEGINSWITH 'Joined'}", :timeout => 30) do
      scroll("scrollView", :down)
    end

    for i in 0..2
      wait_for(:timout => 30, :post_timeout => 2){element_exists("WAMUserProfileInfoTableViewCell index:#{i}")}

      if query("WAMUserProfileInfoTableViewCell index:#{i} descendant * index:2")[0]['text'] == nil
        fail(msg = "Error. check_user_info_date. There was emppty data in field index #{i}")
      end
    end
  end

  # Check that the data in Recognitions, Achievements and Interests is not null
  # @return check_total_recognitions
  def check_total_recognitions
    if query("label {text CONTAINS '#{IOS_STRINGS["WAMIndividualRecognitionsTitle"]}'} sibling *")[0]['text'] == nil
      fail(msg = 'Error. check_total_recognitions. One of the data in the summary table is nil')
    elsif query("label {text CONTAINS '#{TXT_ACHIEVEMENT}'} sibling *")[0]['text'] == nil
      fail(msg = 'Error. check_total_recognitions. One of the data in the summary table is nil')
    elsif query("label {text CONTAINS '#{TXT_INTEREST}'} sibling *")[0]['text'] == nil
      fail(msg = 'Error. check_total_recognitions. One of the data in the summary table is nil')
    end

    total_recognitions = query("label  marked:'#{IOS_STRINGS["WAMFeedFilterRecognitions"]}' sibling *")[0]['text']
    return total_recognitions
  end

  # Change user profile to the given profile
  # @param profile - user profile to change to
  def change_to_profile (profile)
    puts "#{profile}"
      wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeName"]}'")}
      wait_for_none_animating
      touch("UITextView")
      wait_for_keyboard
      clear_text("UITextView")
      wait_for_none_animating
      keyboard_enter_text("#{USER_PROFILE[:"#{profile}"][:about]}")
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')
      wait_for_none_animating

      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeName"]}'")
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')
      wait_for_none_animating

      wait_for(:timout => 10,:post_timeout => 1){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeSurname"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeSurname"]}'")
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')
      wait_for_none_animating

      wait_for(:timout => 10,:post_timeout => 1){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeJobTitle"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeJobTitle"]}'")
      wait_for_keyboard
      wait_for_none_animating
      clear_text("UIFieldEditor")
      keyboard_enter_text("#{USER_PROFILE[:"#{profile}"][:role_title]}")
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')
      wait_for_none_animating

      year = USER_PROFILE[:"#{profile}"][:date_join_year].to_i
      month = Date::ABBR_MONTHNAMES.index( USER_PROFILE[:"#{profile}"][:date_join_month]).to_i
      day = USER_PROFILE[:"#{profile}"][:date_join_day].to_i

      wait_for(:timout => 10,:post_timeout => 1){element_exists("label {text BEGINSWITH '#{TXT_JOINED}'}")}
      touch("label {text BEGINSWITH '#{TXT_JOINED}'}")
      wait_for(:timout => 10,:post_timeout => 1){element_exists('datePicker')}

      picker_set_date_time(DateTime.new(year,month,day), options = {:animate => true, :picker_id => nil, :notify_targets => true})
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')

      touch("label {text CONTAINS '#{TXT_JOINED}'}")
      year = USER_PROFILE[:"#{profile}"][:date_join_year].to_i
      month = Date::ABBR_MONTHNAMES.index( USER_PROFILE[:"#{profile}"][:date_join_month]).to_i
      day = USER_PROFILE[:"#{profile}"][:date_join_day].to_i
      wait_for(:timout => 10,:post_timeout => 1){element_exists('datePicker')}
      puts "#{year}#{month}#{day}"
      picker_set_date_time(DateTime.new(year,month,day), options = {:animate => true, :picker_id => nil, :notify_targets => true})
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')

      wait_for(:timout => 10,:post_timeout => 1){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeWork"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeWork"]}'")
      wait_for_keyboard
      clear_text("UIFieldEditor")
      keyboard_enter_text("#{USER_PROFILE[:"#{profile}"][:phone]}")
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')

      wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeGender"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeGender"]}'")
      wait_for(:timout => 10){element_exists("label marked:'#{USER_PROFILE[:"#{profile}"][:gender]}'")}
      touch("label marked:'#{USER_PROFILE[:"#{profile}"][:gender]}'")
      wait_for(:timout => 10,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')

      wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeMobile"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeMobile"]}'")
      wait_for_keyboard
      clear_text("UIFieldEditor")
      keyboard_enter_text("#{USER_PROFILE[:"#{profile}"][:phone]}")
      click_button('Done')

      year = USER_PROFILE[:"#{profile}"][:b_day_year].to_i
      month = Date::ABBR_MONTHNAMES.index( USER_PROFILE[:"#{profile}"][:b_day_month]).to_i
      day = USER_PROFILE[:"#{profile}"][:b_day_date].to_i
      puts "#{month} #{day}, #{year}"
      wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeBirthday"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeBirthday"]}'")
      wait_for(:timout => 10){element_exists("datePicker")}
      picker_set_date_time(DateTime.new(year,month,day), options = {:animate => true, :picker_id => nil, :notify_targets => true})
      wait_for(:timout => 10){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'")}
      click_button('Done')

      click_button('Save Profile')
  end

  # Match the current profile with the given profile
  # @param profile - user profile to match with
  def match_profile_with (profile)
    puts "#{profile}"
    phone = USER_PROFILE[:"#{profile}"][:phone]
    puts "Phone number is #{phone}"
    wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMUserProfileCellTypeMobile"]}'")}
    scroll("scrollView", :down)
    wait_for_none_animating

    year = USER_PROFILE[:"#{profile}"][:b_day_year].to_i
    month = Date::MONTHNAMES[(USER_PROFILE[:"#{profile}"][:date_join_month_code].to_i+1)]
    day = "#{sprintf('%.2d', USER_PROFILE[:"#{profile}"][:b_day_date].to_i)}"

    puts "#{month} #{day}, #{year}"
    birthday_date = "#{month} #{day}, #{year}"

    wait_for(:timeout => 30){query("UILabel marked:'#{IOS_STRINGS["WAMUserProfileCellTypeBirthday"]}' parent * child * index:2")[0]['text'] == birthday_date}

    year = USER_PROFILE[:"#{profile}"][:date_join_year].to_i
    month = Date::MONTHNAMES[(USER_PROFILE[:"#{profile}"][:date_join_month_code].to_i+1)]

    puts "#{month} #{year}"
    joined_date = "#{month} #{year}"

    wait_for(:timeout => 30){query("UILabel {text CONTAINS '#{LBL_JOINED}'} parent * child * index:2")[0]['text'] == joined_date}

    scroll('scrollView', :up)
    wait_for_none_animating
    scroll('scrollView', :up)
    wait_for_none_animating
  end

  # Get total amount of recognitions from leaderboard
  def get_total_from_leaderboard
    wait_for(:timout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerAllTime"]}'")}
    touch("label marked:'#{IOS_STRINGS["WAMLeaderboardViewControllerAllTime"]}'")
    wait_for_none_animating

    wait_poll(:retry_frequency => 0.5, :until_exists => "label marked:'#{ACCOUNT[:"#{$account_index}"][:valid_ios_account][:user_name]}'") do
      scroll("scrollView", :down)
    end

    total_recogntions_in_all_time = query("label marked:'#{ACCOUNT[:"#{$account_index}"][:valid_ios_account][:user_name]}' parent * index:1 child * UILabel index:2")[0]['text'].to_i

    return total_recogntions_in_all_time
  end

  #Go back to News Feed before logging out
  def back_to_settings
    while element_exists(BTN_BACK)
      click_button('Back')
    end
    while element_exists(BTN_BACK_WHITE)
      touch(BTN_BACK_WHITE)
      wait_for(:timeout => 30) {element_does_not_exist(BTN_BACK_WHITE)}
    end  
  end

  def naviagte_to_snackable
    click_button('Settings')
    click_button('Snackable')
  end
end
