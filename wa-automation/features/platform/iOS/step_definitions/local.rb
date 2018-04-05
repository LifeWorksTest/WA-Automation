# -*- encoding : utf-8 -*-
Given /^I am on the iOS Local screen$/ do
    @local_page = page(IOSLocalPage).await
end

When /^I click from the iOS Local screen "(.*?)"$/ do |button|
    @local_page.click_button(button)
end

Then /^I validate Deals in the iOS Local screen$/ do
	@local_page.validate_deals_date
end

Then /^I select "(.*?)" random categories from the list displayed on the iOS Local screen$/ do |total_categories_to_select|
	@local_page.select_random_categories(total_categories_to_select)
end