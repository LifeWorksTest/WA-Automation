# -*- encoding : utf-8 -*-
Given /^I am on the Android Give A New Recongtion screen$/ do
    @news_feed_page = page(AndroidGiveANewRecognitionPage).await
end

Then /^I give recognition to user index "(.*?)" from Give A New Recongtion screen$/ do |user_index|
	@news_feed_page.select_user(user_index)
end

Then /^I click "(.*?)" from Give A New Recongtion screen$/ do |button|
	@news_feed_page.click_button(button)
end

And /^I choose "(.*?)" badge from Give A New Recongtion screen$/ do |badge|
	@news_feed_page.choose_badge(badge)
end

And /^I write this recoginition "(.*?)" from Give A New Recongtion screen$/ do |recoginition_text|
	@news_feed_page.write_recognition(recoginition_text)
end
