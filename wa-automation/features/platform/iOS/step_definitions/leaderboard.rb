# -*- encoding : utf-8 -*-
Given /^I am on the iOS Leaderboard screen$/ do
	@leaderboard_page = page(IOSLeaderboardPage).await
end

When /^I click from the iOS Leaderboard screen "(.*?)"$/ do |button|
    @leaderboard_page.click_button(button)
end

Then /I go over the user recognitions from the iOS app$/ do
    @leaderboard_page.go_over_user_recognitions
end

Then /^I see "(.*?)" recognitions from the iOS app$/ do |colleague_name|
	@leaderboard_page.see_colleague_recognitions(colleague_name)
end

Then /^I give this recognition "(.*?)" to user in the "(.*?)"th place$/ do |recognition, colleague_index|
    @leaderboard_page.give_recognition(recognition, colleague_index) 
end

Then /^I check that the table is sorted and have the right images$/ do
    @leaderboard_page.check_table_is_sorted
end

And /^I am back to Leaderboard screen$/ do
    @leaderboard_page.await
end
