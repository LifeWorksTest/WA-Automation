# -*- encoding : utf-8 -*-
Given /^I am on the Android Colleagues Directory screen$/ do
    @colleagues_directory_page = page(AndroidColleaguesDirectoryPage).await
end

Then /^I click from the Colleagues Directory screen "(.*?)"$/ do |button|
    @colleagues_directory_page.click_button(button)
end

Then /^I serach for colleague "(.*?)" that "(.*?)" my list$/ do |colleague, state|
    @colleagues_directory_page.search_for_colleague(colleague, state)
end

Then /^I give the following recognition "(.*?)", "(.*?)" to user index "(.*?)" from the Android Colleagues Directory screen$/ do |text, badge, user_index|
	@colleagues_directory_page.open_3_menu(user_index)
    @colleagues_directory_page.click_button('Give Recognition')

	@news_feed_page = page(AndroidGiveANewRecognitionPage)
	@news_feed_page.give_recognition(text, badge)
end

Then /^I validate all badges from the Android Colleagues Directory screen$/ do
	@colleagues_directory_page.open_3_menu(0)
    @colleagues_directory_page.click_button('Give Recognition')

	@news_feed_page = page(AndroidGiveANewRecognitionPage)
	@news_feed_page.give_recognition('Good work', nil, true)
end