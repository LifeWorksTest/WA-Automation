# -*- encoding : utf-8 -*-
Given /^I am on the iOS Profile screen$/ do
    @profile_page = page(IOSUserProfilePage).await
end

When /^I check the number of recognitions from the iOS app$/ do
  @TOTAL_RECOGNITION_FROM_PROFILE = @profile_page.check_total_recognitions
end

When /^I validate from the iOS app that the data of the user is presented$/ do
  @profile_page.validate_carousel_data
  @profile_page.check_total_recognitions
  @profile_page.check_user_profile_data
end

Then /^I click from the iOS Profile screen "(.*?)"$/ do |button|
   @profile_page.click_button(button) 
end

And /^I match the my total recogntion from the iOS app with All Time$/ do
  totle_recogntions_in_all_time = @profile_page.get_total_from_leaderboard
  if totle_recogntions_in_all_time.to_i != @TOTAL_RECOGNITION_FROM_PROFILE.to_i
    fail(msg = "Error. User total recogntion in User profile #{@TOTAL_RECOGNITION_FROM_PROFILE} and Leaderboard #{totle_recogntions_in_all_time} is not equal")
  elsif
    puts "User total recogntion in User profile is #{@TOTAL_RECOGNITION_FROM_PROFILE} and Leaderboard is #{totle_recogntions_in_all_time}"
  end
end

And /^I change the user profile to "(.*?)" from the iOS app$/ do |profile|
  @profile_page.change_to_profile(profile)
end

And /^I check that the user profile is match to "(.*?)" from the iOS app$/ do |profile|
  @profile_page.match_profile_with(profile)
end

And /^I go back to iOS Settings Screen from iOS User Profile screen$/ do
  @profile_page.back_to_settings
end
