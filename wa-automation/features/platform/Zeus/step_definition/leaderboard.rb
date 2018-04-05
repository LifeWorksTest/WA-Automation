# -*- encoding : utf-8 -*-
Given /^I am on the Admin Panel Leaderboard screen$/ do 
    @leaderboard_page = ZeusLeaderboardPage.new @browser
end

When /^I click on "(.*?)" from Leaderboard screen$/ do |button|
    @leaderboard_page.click_button(button)
end

When /^I validate all months recognitions per day average$/ do
	@leaderboard_page.validate_recognitions_per_day_by_month
end 
   
Then /^I check that the table is sorted and have the right badges$/ do 
    @leaderboard_page.check_table_is_sorted
end

Then /^I check the link to each user profile$/ do
    @leaderboard_page.check_link_to_users
end

Then /^I set Network Summery$/ do
	@leaderboard_page.set_network_summery
end

Then /^I validate empty state in the Admin Panel Leaderboard screen$/ do
	@leaderboard_page.validate_empty_state
end

And /^I count all Total Recognitions$/ do
    @TOTAL_OF_RECOGNITIONS = @leaderboard_page.sum_recognition
end

And /^match it with Network Summery$/ do
    @leaderboard_page.compere_total_recognition_with_network_summery(@TOTAL_OF_RECOGNITIONS)
end

And /^I set time filter to "(.*?)"$/ do |filter|
    @leaderboard_page.set_time_filter_to(filter)
end
