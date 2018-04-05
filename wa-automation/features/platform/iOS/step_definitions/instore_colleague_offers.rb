# -*- encoding : utf-8 -*-
Given /^I am on the iOS "(.*?)" screen$/ do |page|
	@instore_colleague_offers_page = page(IOSInStoreColleagueOfferPage).await
end

Then /^I validate all "(.*?)" offers in the page from the iOS app$/ do |page|
	@instore_colleague_offers_page.validate_data_in_page(page)
end
