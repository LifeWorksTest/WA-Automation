# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidUserProfilePage < Calabash::ABase  
  BTN_SAVE = "ActionMenuItemView id:'action_selection_done' marked:'Save'"
  BTN_OK = "AppCompatButton id:'button1' marked:'OK'"
  BTN_X = "AppCompatImageButton"
  BTN_EDIT_PROFILE = "FloatingActionButton id:'fragment_user_details_edit_button'"
  BTN_HOME = "AppCompatImageButton"
  BTN_BACK = "AppCompatImageButton contentDescription:'Navigate up'"
  
  def trait
    BTN_EDIT_PROFILE
  end

  def click_button (button)
    case button
    when 'OK'
      wait_for(:timout => 10){element_exists(BTN_OK)}
      touch(BTN_OK)
      sleep(0.5)
    when 'Save'
      wait_for(:timout => 10){element_exists(BTN_SAVE)}
      touch(BTN_SAVE)
      wait_for(:timout => 10){element_exists(BTN_SAVE)}
    when 'X'
      wait_for(:timout => 10){element_exists(BTN_X)}
      touch(BTN_X)
      wait_for(:timout => 10){element_exists(BTN_EDIT_PROFILE)}
    when 'Edit Profile'
      sleep(1)
      wait_for(:timout => 10){element_exists(BTN_EDIT_PROFILE)}
      touch(BTN_EDIT_PROFILE)
      wait_for(:timout => 10){element_exists(BTN_SAVE)}
    when 'Home Btn'
      wait_for(:timout => 10){element_exists(BTN_EDIT_PROFILE)}
      touch(BTN_EDIT_PROFILE)
      wait_for(:timout => 10){element_exists(BTN_SAVE)}
    when 'Back'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      sleep(1)
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  def is_visible
    wait_for(:timout => 10){element_exists("AppCompatTextView {text BEGINSWITH 'Recognition'} sibling *")}
    wait_for(:timout => 10){element_exists("AppCompatTextView {text BEGINSWITH 'Achievement'} sibling *")}
    wait_for(:timout => 10){element_exists("AppCompatTextView {text BEGINSWITH 'Interest'} sibling *")}
  end

  # Check that the carousel have data
  # @param profile - user profile to match with
  def validate_carousel_data
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'fragment_user_details_info_carousel_item_title' marked:'#{ACCOUNT[:"#{$ACCOUNT_INDEX}"][:valid_account][:user_name]}'")}
    #wait_for(:timout => 10){element_exists("AppCompatTextView id:'fragment_user_details_info_carousel_item_subtitle' marked:'#{USER_PROFILE[:"#{profile}"][:role_title]}'")}

    perform_action('drag', 50, 10, 40, 40, 5)
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'fragment_user_details_info_carousel_item_title' marked:'Joined #{ACCOUNT[:"#{$ACCOUNT_INDEX}"][:valid_account][:company_name]}'")}

    perform_action('drag', 50, 10, 40, 40, 5)
    #wait_for(:timout => 10){element_exists("AppCompatTextView id:'fragment_user_details_info_carousel_item_description' marked:'\"#{USER_PROFILE[:"#{profile}"][:about]}\"'")}
  end
  
  # Validate user profile
  # @param profile - user profile to match with
  def check_user_profile_data (profile)
    
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_title' marked:'Email'")}
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_description' marked:'#{ACCOUNT[:account_1][:valid_account][:email]}'")}

    scroll_down

    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_title' marked:'Cell'")}
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_description' marked:'#{USER_PROFILE[:"#{profile}"][:phone]}'")}

    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_title' marked:'Work'")}
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_description' marked:'#{USER_PROFILE[:"#{profile}"][:phone]}'")}

    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_title' marked:'Birthday'")}
    month_array = Date::MONTHNAMES
    birthday_date = "#{month_array.select {|value| value =~ /#{USER_PROFILE[:"#{profile}"][:b_day_month]}/}[0][0..2]}" + ' ' + "#{USER_PROFILE[:"#{profile}"][:b_day_date]}" + ',' + ' ' + "#{USER_PROFILE[:"#{profile}"][:b_day_year]}" 
    puts "birthday_date:#{birthday_date}"
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_description' marked:'#{birthday_date}'")}

    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_title' marked:'Joined #{ACCOUNT[:"#{$ACCOUNT_INDEX}"][:valid_account][:company_name]}'")}
    joined_date = "#{month_array.select {|value| value =~ /#{USER_PROFILE[:"#{profile}"][:date_join_month]}/}[0][0..2]}" + ' ' + "#{USER_PROFILE[:"#{profile}"][:date_join_day]}" + ',' + ' ' + "#{USER_PROFILE[:"#{profile}"][:date_join_year]}" 
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_title_text_layout_description' marked:'#{joined_date}'")}

    wait_for(:timout => 10){element_exists("AppCompatTextView id:'fragment_user_details_timeline_title' marked:'My Progression'")}

    month_array = Date::MONTHNAMES
    month_array -= [nil, '']
    current_month = Date.today.strftime("%m").to_i
    

    puts "XXX:#{(month_array[current_month - 1][0..2]).upcase}" 
    wait_for(:timout => 10){element_exists("AppCompatTextView marked:'#{(month_array[current_month - 1][0..2]).upcase}'")}
    wait_for(:timout => 10){element_exists("AppCompatTextView marked:'#{(month_array[current_month - 2][0..2]).upcase}'")}
    wait_for(:timout => 10){element_exists("AppCompatTextView marked:'#{(month_array[current_month - 3][0..2]).upcase}'")}
  end

  # Check that the data in Recognitions, Achievements and Interests is not null
  # @return check_total_recognitions
  def check_total_recognitions
    if (total_recognitions = query("AppCompatTextView {text BEGINSWITH 'Recognition'} sibling *")[0]['text']) == nil
      fail(msg = 'Error. check_total_recognitions. One of the data in the summary table is nil')
    elsif query("AppCompatTextView {text BEGINSWITH 'Achievement'} sibling *")[0]['text'] == nil 
      fail(msg = 'Error. check_total_recognitions. One of the data in the summary table is nil')
    elsif query("AppCompatTextView {text BEGINSWITH 'Interest'} sibling *")[0]['text'] == nil
      fail(msg = 'Error. check_total_recognitions. One of the data in the summary table is nil')
    end
    
    puts "total_recognitions:#{total_recognitions}"    
    return total_recognitions
  end

  # Change user profile to the given profile
  # @param profile - user profile to change to
  def change_to_profile (profile)
    
      wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_about'")}
      clear_text_in("LwTextInputLayout id:'fragment_edit_profile_about' descendant * TextInputEditText")
      enter_text("LwTextInputLayout id:'fragment_edit_profile_about' descendant * TextInputEditText", USER_PROFILE[:"#{profile}"][:about])
      hide_soft_keyboard

      wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_job_title'")}
      clear_text_in("LwTextInputLayout id:'fragment_edit_profile_job_title' descendant * TextInputEditText")
      enter_text("LwTextInputLayout id:'fragment_edit_profile_job_title' descendant * TextInputEditText", USER_PROFILE[:"#{profile}"][:role_title])
      hide_soft_keyboard

      year = USER_PROFILE[:"#{profile}"][:date_join_year].to_i
      month = Date::ABBR_MONTHNAMES.index( USER_PROFILE[:"#{profile}"][:date_join_month]).to_i - 1
      day = USER_PROFILE[:"#{profile}"][:date_join_day].to_i
      wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_work_start'")}
      touch("LwTextInputLayout id:'fragment_edit_profile_work_start'")
      wait_for(:timout => 10){element_exists("datePicker")}
      query("datePicker", :method_name =>'updateDate', :arguments =>[year, month, day])
      sleep(1)
      click_button('OK')

      perform_action('drag', 50, 50, 70, 40, 5)
      sleep(0.5)

      wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_gender'")}
      touch("LwTextInputLayout id:'fragment_edit_profile_gender'")
      wait_for(:timout => 10){element_exists("* id:'contentPanel' * child marked:'Male'")}
      wait_for(:timout => 10){element_exists("* id:'contentPanel' * child marked:'Female'")}
      wait_for(:timout => 10){element_exists("* id:'contentPanel' * child marked:'Other'")}
      touch("* id:'contentPanel' * child marked:'#{USER_PROFILE[:"#{profile}"][:gender]}'")

      wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_mobile'")}
      touch("LwTextInputLayout id:'fragment_edit_profile_mobile'")

      clear_text_in("LwTextInputLayout id:'fragment_edit_profile_mobile' descendant * TextInputEditText")
      enter_text("LwTextInputLayout id:'fragment_edit_profile_mobile' descendant * TextInputEditText", USER_PROFILE[:"#{profile}"][:phone])
      hide_soft_keyboard

      clear_text_in("LwTextInputLayout id:'fragment_edit_profile_work_number' descendant * TextInputEditText")
      enter_text("LwTextInputLayout id:'fragment_edit_profile_work_number' descendant * TextInputEditText", USER_PROFILE[:"#{profile}"][:phone])
      hide_soft_keyboard

      touch("LwTextInputLayout id:'fragment_edit_profile_last_birthday'")
      year = USER_PROFILE[:"#{profile}"][:b_day_year].to_i
      month = Date::ABBR_MONTHNAMES.index( USER_PROFILE[:"#{profile}"][:b_day_month]).to_i - 1
      day = USER_PROFILE[:"#{profile}"][:b_day_date].to_i
      puts "#{year}/#{month}/#{day}"
      wait_for(:timout => 10){element_exists("datePicker")}
      query("datePicker", :method_name =>'updateDate', :arguments =>[year, month, day])
      sleep(1)
      click_button('OK')

      click_button('Save')
  end

  # Match the current profile with the given profile
  # @param profile - user profile to match with
  def match_profile_with (profile)
    click_button('Edit Profile')
      
    wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_about' marked:'#{USER_PROFILE[:"#{profile}"][:about]}'")}
    wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_job_title' descendant * TextInputEditText marked:'#{USER_PROFILE[:"#{profile}"][:role_title]}'")}
    
    perform_action('drag', 50, 50, 70, 40, 5)
    perform_action('drag', 50, 50, 70, 40, 5)
    sleep(0.5)

    month_array = Date::MONTHNAMES
    joined_date = "#{month_array.select {|value| value =~ /#{USER_PROFILE[:"#{profile}"][:date_join_month]}/}[0]}" + ' ' + "#{USER_PROFILE[:"#{profile}"][:date_join_day]}" + ',' + ' ' + "#{USER_PROFILE[:"#{profile}"][:date_join_year]}" 
    puts "joined_date:#{joined_date}"
    wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_work_start' descendant * TextInputEditText marked:'#{joined_date}'")}

    wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_gender' TextInputEditText marked:'#{USER_PROFILE[:"#{profile}"][:gender]}'")}

    birthday_date = "#{month_array.select {|value| value =~ /#{USER_PROFILE[:"#{profile}"][:b_day_month]}/}[0]}" + ' ' + "#{USER_PROFILE[:"#{profile}"][:b_day_date]}" + ',' + ' ' + "#{USER_PROFILE[:"#{profile}"][:b_day_year]}" 
    puts "birthday_date:#{birthday_date}"
    wait_for(:timout => 10){element_exists("LwTextInputLayout id:'fragment_edit_profile_last_birthday' descendant * TextInputEditText marked:'#{birthday_date}'")}
    
    click_button('X')
  end

  # Get the current user total amount of recognitions from leaderboard
  def get_total_from_leaderboard
    wait_for(:timout => 10){element_exists("AppCompatTextView id:'view_leaderboard_list_user_item_name' marked:'#{ACCOUNT[:"#{$ACCOUNT_INDEX}"][:valid_account][:user_name]}'")}
    totle_recogntions_in_all_time = query("AppCompatTextView id:'view_leaderboard_list_user_item_name' marked:'#{ACCOUNT[:"#{$ACCOUNT_INDEX}"][:valid_account][:user_name]}' parent * index:2 descendant AppCompatTextView id:'view_leaderboard_list_user_item_recognition_count'")[0]['text'].to_i

    return totle_recogntions_in_all_time
  end
end
