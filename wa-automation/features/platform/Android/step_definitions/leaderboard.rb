# -*- encoding : utf-8 -*-
Given /^I am on the Android Leaderboard screen$/ do
	@leaderboard_page = page(AndroidLeaderboardPage).await
end

When /^I click from the Android Leaderboard screen "(.*?)"$/ do |button|
    @leaderboard_page.click_button(button)
end

Then /^I see "(.*?)" recognitions$/ do |colleague_name|
    @leaderboard_page.see_colleague_recognitions(colleague_name)
end

Then /^I go over user recognitions$/ do
    @leaderboard_page.go_over_user_recognitions
end

Then /^I validate that the table is sorted on the Android app$/ do
    @leaderboard_page.check_table_is_sorted
end

Then /^I give this recognition "(.*?)" with the next badge "(.*?)" to user in the "(.*?)"th place from the Android app$/ do |recognition, badge, colleague_index|
    @leaderboard_page.give_recognition(recognition, badge, colleague_index.to_i)
end

Then /^I give the following recognition "(.*?)", "(.*?)" to user index "(.*?)" from the Android Leaderboard screen$/ do |text, badge, user_index|
	@leaderboard_page.open_3_menu(user_index)
    @leaderboard_page.click_button('Give Recognition')

	@news_feed_page = page(AndroidGiveANewRecognitionPage)
	@news_feed_page.give_recognition(text, badge)
end

And /^I am back to Android Leaderboard screen$/ do
    @leaderboard_page.await
end
