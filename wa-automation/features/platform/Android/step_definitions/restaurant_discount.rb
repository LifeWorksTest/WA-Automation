# # -*- encoding : utf-8 -*-
Given /^I am on the Android Restaurant Discounts screen$/ do    
    @restaurant_discounts_page = page(AndroidRestaurantDiscountsPage).await
    @restaurant_discounts_page.set_favorites_counter
end

When /^I validate that the restaurant "(.*?)" the favorites list$/ do |state|
	@restaurant_discounts_page.check_resturent_in_favourites('state')
end

When /^I favorite the first restaurant in the list$/ do
	@restaurant_discounts_page.open_first_restaurant_in_list
	@restaurant_name = @restaurant_discounts_page.favorite_unfavorite('Favorite')
end

# When /^I "(.*?)" restaurant "(.*?)"$/ do |state, restaurant_name|
#     @restaurant_discounts_page.choose_result(restaurant_name)
#     @restaurant_discounts_page.favourite(state)
# end

Then /^I match restaurant details within the list with the details within the restaurant profile$/ do
    @restaurant_discounts_page.check_resturent_list_details
end

Then /^I validate that the map contains results$/ do
	@restaurant_discounts_page.validate_map_results
end



Then /^I unfavorite the restaurant from the favorites page$/ do
	@restaurant_discounts_page.favorite_unfavorite('Unfavorite')
end

Then /^I search for restaurants around "(.*?)"$/ do |location|
	@restaurant_discounts_page.near_me(location)
end

And /^I validate that "(.*?)" is visible in the previous search results$/ do |location|
	@restaurant_discounts_page.click_button('Near Me')
	@restaurant_discounts_page.check_near_me_location_is_saved(location)
end

And /^I validate that the favorites counter as updated$/ do
	@restaurant_discounts_page.validate_favorites_counter
end


# When /^I "(.*?)" restaurant "(.*?)"$/ do |state, restaurant_name|
#     @restaurant_discounts_page.choose_result(restaurant_name)
#     @restaurant_discounts_page.favourite(state)
# end

Then /^I click from Android Restaurant Discounts screen "(.*?)"$/ do |button|
    @restaurant_discounts_page.click_button(button)
end

Then /^I search for restaurant "(.*?)"$/ do |restaurant|
    @restaurant_discounts_page.search_restaurant(restaurant)
end

# And /^I check that "(.*?)" "(.*?)" my favourites$/ do |restaurant_name, state|
#     @restaurant_discounts_page.check_resturent_in_favourites(restaurant_name, state)
# end
 
And /^I select "(.*?)" restaurant$/ do |restaurantName|
	@restaurant_discounts_page.choose_result(restaurantName)
end

Then /^I navigate back to more$/ do
	@restaurant_discounts_page.navigate_back_to_more
end


