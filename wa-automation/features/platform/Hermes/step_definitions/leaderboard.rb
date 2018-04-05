# -*- encoding : utf-8 -*-
Then /^I am on the Leaderboard screen$/ do
    @leaderboard_page = HermesLeaderboardPage.new @browser
    @leaderboard_page.is_visible
end

When /^I select "(.*?)" from the Leaderboard screen$/ do |period| 
	@leaderboard_page.select_period(period)
end

When /^I select "(.*?)" from the Leaderboard screen and check that the leaderboard is sorted$/ do |period|
    if !(period == 'Last Month' && (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Headless'))
    	@leaderboard_page.select_period(period)
    	@leaderboard_page.check_table_is_sorted
    end
end

 When /^I select "(.*?)" from the Leaderboard screen and check my position$/ do |period|
	if !(period == 'Last Month' && (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Headless'))
        @leaderboard_page.select_period(period)
    	@leaderboard_page.check_my_position
    end
 end

Then /^I check that the table is sorted$/ do
    @leaderboard_page.check_table_is_sorted
end

Then /^I see "(.*?)" users recognitions$/ do |users_to_validate|
	@leaderboard_page.see_users_recognitions(users_to_validate.to_i)
end

And /^I check my position$/ do 
    @leaderboard_page.check_my_position
end

And /^I validate that grouping fuctionalty is "(.*?)" in Leaderboard screen$/ do |enabled_disabled|
	@leaderboard_page.grouping_is_valid (enabled_disabled)
end
