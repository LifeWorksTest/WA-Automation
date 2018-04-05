# -*- encoding : utf-8 -*-
Given /^I am on the iOS Colleagues Directory screen$/ do
	@colleagues_directory_page = page(IOSColleaguesDirectoryPage).await
end

Then /^I give this recognition "(.*?)" to a colleague index "(.*?)" from the iOS app$/ do |recognition_text, colleague_index|
	@colleagues_directory_page.give_recognition_to(recognition_text, colleague_index)
end

Then /^I click from the iOS Colleague Directory screen "(.*?)"$/ do |button|
    @colleagues_directory_page.click_button(button)
end

Then /^I search from the iOS app for colleague "(.*?)" that "(.*?)" my list$/ do |colleague, state|
    @colleagues_directory_page.search_for_colleague(colleague, state)
end

Then /^I click from the iOS Colleagues Directory screen "(.*?)"$/ do |button|
    @colleagues_directory_page.click_button(button)
end