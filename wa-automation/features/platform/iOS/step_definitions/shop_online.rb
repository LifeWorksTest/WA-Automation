# -*- encoding : utf-8 -*-
Given /^I am on the iOS Shop Online screen$/ do
  @shop_online = page(IOSShopOnlinePage).await
end

When /^I search for "(.*?)" "(.*?)" "(.*?)" from the iOS app$/ do |exists_or_not, search_type, retailer_name|
	#@shop_online.click_button('Retailers')
	@shop_online.search(retailer_name, search_type, exists_or_not)
end

Then /^I click from the iOS Shop Online screen "(.*?)"$/ do |button|
	@shop_online.click_button(button)
end

Then /^I go to "(.*?)" in category "(.*?)" from the iOS app$/ do |retailer, category|
	@shop_online.click_button('Browse by Category')
	@shop_online.select_category(category)
	@shop_online.select_retailer(retailer)
end

Then /^I validate three deals of Featured Cashback table from the iOS app$/ do
	@shop_online.click_button('See All Featured Cashback')
	@shop_online.go_over_current_table
end

Then /^I validate validate three deals of Popular in Network table from the iOS app$/ do
	@shop_online.click_button('See All Popular in Network')
	@shop_online.go_over_current_table('Popular in Network')
end

Then /^I validate validate three deals of Recommended Offers table from the iOS app$/ do
	@shop_online.click_button('See All Recommended Offers')
	@shop_online.go_over_current_table('Recommended Offers')
end

Then /^I validate validate three deals of Featured Offers table from the iOS app$/ do
	@shop_online.click_button('See All Featured Offers')
	@shop_online.go_over_current_table('Featured Offers')
end

Then /^I save the first offer$/ do
	@shop_online.save_first_offer
end

Then /^I remove the first offer$/ do
	@shop_online.unsave_first_offer
end

And /^I validate that the offer is "(.*?)" Saved Offers category$/ do |option|
	@shop_online.select_category('Saved Offers')
	if option == 'in'
		@shop_online.validate_last_saved_offer_is_in_list('is in')
	elsif  option == 'not in'
		@shop_online.validate_last_saved_offer_is_in_list('is not in')
	end
end
 
Then /^I "(.*?)" this retailer to Favourites$/ do |option|
	if option == 'add'
		@shop_online.click_button('Favourite heart')
	elsif option == 'remove'
		@shop_online.click_button('Unfavourite')
	end

	@shop_online.click_button('Back')
	@shop_online.click_button('Back')
end


And /^I validate that the retailer is "(.*?)" Favourites category$/ do |option|
	@shop_online.select_category('Favourites')
	if option == 'in'
		@shop_online.validate_retailer_is_in_favourites('in')
	elsif  option == 'not in'
		@shop_online.validate_retailer_is_in_favourites('not in')
	end

	@shop_online.click_button('Back')
	@shop_online.click_button('Close')
end

And /^I open "(.*?)" retailer page from the iOS app$/ do |retailer_name|
	@shop_online.open_retailer_page(retailer_name)
end

And /^I open "(.*?)" product page from the iOS app$/ do |product_name|
	@shop_online.open_product_page(product_name)
end

Then /^I clear the retailer name from Search field$/ do
	@shop_online.clear_search
end 	
And /^I return to the main screen$/ do
	@shop_online.return_to_main_page
end
