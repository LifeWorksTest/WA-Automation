# -*- encoding : utf-8 -*-
Given /^I am on the Android Offers screen$/ do
	@in_store_colleague_offers_page = page(AndroidInStoreColleagueOffersPage).await
end

Then /^I validate all "(.*?)" in the page$/ do |page|
	@in_store_colleague_offers_page.validate_data_in_page(page)
end
