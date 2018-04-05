# -*- encoding : utf-8 -*-
Given /^I am on the Android Shop Online screen$/ do
	@shop_online = page(AndroidShopOnlinePage).await
end

When /^I select "(.*?)" from categories$/ do |category_to_select|
	@shop_online.select_category(category_to_select)
end

Then /^I validate "(.*?)"$/ do |option|
	case option
	when 'Featured Cashback'
		@shop_online.click_button('SEE ALL Featured Cashback')
	when 'Recommended Cashback'
		@shop_online.click_button('SEE ALL Recommended Offers')
	when 'Popular Cashback'
		@shop_online.click_button('SEE ALL Popular Cashback')
	end

	@shop_online.go_over_current_list
end

Then /^"(.*?)" "(.*?)" in favourites list$/ do |retailer, state|
	@shop_online.check_if_retailer_is_in_favourites(retailer, state)
end

Then /^I search for "(.*?)" retailer$/ do |retailer|
	@shop_online.search_for_retailer(retailer)
end

Then /^I click from the Android Shop Online screen "(.*?)"$/ do |button|
	@shop_online.click_button(button)
end

And /^I "(.*?)" retailer$/ do |favourite_unfavourite|
	@shop_online.favourite_unfavourite_retailer(favourite_unfavourite)
end

And /^I open retailer page "(.*?)" from Favourite Retailers screen$/ do |retailer_name|
	@shop_online.open_retailer_from_favourites(retailer_name)
end






