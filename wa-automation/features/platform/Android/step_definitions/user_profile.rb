# -*- encoding : utf-8 -*-
Given /^I am on the Android Profile screen$/ do
  @profile_page = page(AndroidUserProfilePage).await
  @profile_page.is_visible
end

When /^I check the number of recognitions$/ do
  @total_recognition_from_profile = @profile_page.check_total_recognitions
end

When /^I validate that the data of the user is presented$/ do
  @profile_page.validate_carousel_data
  @profile_page.check_total_recognitions
  @profile_page.check_user_profile_data("user1")
end

Then /^I click from the Android Profile screen "(.*?)"$/ do |button|
   @profile_page.click_button(button) 
end

And /^I match the my total recogntion with All Time$/ do
  totle_recogntions_in_all_time = @profile_page.get_total_from_leaderboard

  if totle_recogntions_in_all_time.to_i != @total_recognition_from_profile.to_i
    fail(msg = "Error. User total recogntion in User profile #{@total_recognition_from_profile} and Leaderboard #{totle_recogntions_in_all_time} is not equal")
  elsif
    puts "User total recogntion in User profile is #{@total_recognition_from_profile} and Leaderboard is #{totle_recogntions_in_all_time}"
  end
end

And /^I change the user profile to "(.*?)" from the Android app$/ do |profile|
    @profile_page.change_to_profile(profile)
end

And /^I check that the user profile is match to "(.*?)"$/ do |profile|
    @profile_page.match_profile_with(profile)
end
