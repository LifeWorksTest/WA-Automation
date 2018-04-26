# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidColleaguesDirectoryPage < Calabash::ABase
  BTN_SEARCH = "* contentDescription:'Search'"
  BTN_GIVE_RECOGNITION = "* marked:'Give Recognition'"
  BTN_BACK = "android.widget.ImageButton"

  TXV_NO_RESULTS = "* id:'view_generic_error_message'"

  def trait
    "* id:'view_colleague_directory_user_overflow'"
  end
  
  def click_button (button)
    case button
    when 'Give Recognition'
      wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
      touch(BTN_GIVE_RECOGNITION)
      wait_for(:timeout => 30){element_does_not_exist(BTN_GIVE_RECOGNITION)}
    when 'Search'
      wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      wait_for(:timeout => 30){element_exists("* id:'activity_navigation_search_field'")}
    when 'BACK'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_BACK)}   
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Open small menu according the user index
  # @param user_index
  def open_3_menu (user_index)
    wait_for(:timeout => 30){element_exists("AppCompatImageView id:'view_colleague_directory_user_overflow_anchor' index:#{user_index}")}
    touch("AppCompatImageView id:'view_colleague_directory_user_overflow_anchor' index:#{user_index}")
    wait_for(:timeout => 30){element_exists(BTN_GIVE_RECOGNITION)}
  end

  # Search for the give colleague
  # @param colleague
  # @param state - colleague is in the colleagues list or not
  def search_for_colleague (colleague, state)
    click_button('Search')
    puts "#{colleague}"
    wait_for(:timeout => 30){element_exists("* id:'activity_navigation_search_field'")}
    query("* id:'activity_navigation_search_field'",{:setText => "#{colleague}"})
    case state
    when 'is not in'
    wait_for(:timeout => 30){element_exists("* id:'view_generic_error_message'")}

      if !element_exists("* id:'view_generic_error_message'")
        fail(msg = 'Error. search_for_colleague. Expected to 0 results for #{colleague} but there is more then 0.')
      end
    
    when 'is in'
      wait_for(:timeout => 30, :post_timeout =>1){element_does_not_exist("* id:'view_generic_error_message'")}
      number_of_match_results = query("AppCompatTextView id:'view_colleague_directory_user_name'").size
      
      if number_of_match_results == 0
        fail(msg = 'Error. search_for_colleague. Expected to at at least one result for #{colleague} but there is no result.')
      end
      
      puts "number_of_match_results:#{number_of_match_results}"
      
      for i in 0..number_of_match_results - 1
        if (/#{colleague}/i.match query("AppCompatTextView id:'view_colleague_directory_user_name' index:#{i}")[0]['text']) == nil
          fail(msg = 'Error. search_for_colleague. Result that is not matched appears in the results')
        end
      end
    end
  end

end
