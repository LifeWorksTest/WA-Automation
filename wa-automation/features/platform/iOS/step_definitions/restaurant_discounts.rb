# -*- encoding : utf-8 -*-
Given /^I am on the iOS Restaurant Discounts screen$/ do    
    @restaurant_discounts_page = page(IOSRestaurantDiscountsPage).await
    @restaurant_discounts_page.set_favorites_counter
    @restaurant_name = (query "* id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")[0]["text"]    
    
    while (@restaurant_name.include? "\'")
        flick("scrollView", {x:0, y:-50})
        sleep(3)        
        @restaurant_name = (query "* id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")[0]["text"]    
    end

    puts "@restaurant_name:#{@restaurant_name}"
end

When /^I favorite the first restaurant in the iOS list from the restaurant page$/ do 
    wait_for(:timeout => 10){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")}
    @restaurant_discounts_page.open_restaurant(@restaurant_name)
    @restaurant_discounts_page.click_button('Favorite')
end

Then /^I match from the iOS restaurant details within the list with the details within the restaurant profile$/ do
    @restaurant_discounts_page.check_restaurant_list_details
end

Then /^I "(.*?)" the restaurant from the favorites page$/ do |action|
    wait_for(:timeout => 10,:post_timeout => 1){element_exists("* marked:'#{@restaurant_name}' sibling button marked:'ic favourite active'")}
    touch "* marked:'#{@restaurant_name}' sibling button marked:'ic favourite active'"
    wait_for_none_animating
    wait_for(:timeout => 10){element_exists("* marked:'#{IOS_STRINGS["WAMRSFavouriteRemoveButton"]}'")}
    touch "* marked:'#{IOS_STRINGS["WAMRSFavouriteRemoveButton"]}'"
    wait_for(:timeout => 10){element_does_not_exist("* marked:'#{IOS_STRINGS["WAMRSFavouriteRemoveButton"]}'")}
    wait_for(:timeout => 10){element_exists("* marked:'#{@restaurant_name}' sibling button marked:'ic favourite default'")}
end

Then /^I validate that the restaurant is "(.*?)" the favorites list$/ do |in_or_not|
    if in_or_not == 'in'
        @restaurant_discounts_page.search_for_restaurant_in_favorites(@restaurant_name)
    elsif in_or_not == 'not_in'
        @restaurant_discounts_page.search_for_restaurant_in_favorites(@restaurant_name)
    end
end

Then /^I validate from the iOS Restaurant Discounts screen that the map contains results$/ do 
    @restaurant_discounts_page.validate_map_view
end

Then /^I click from iOS Restaurant Discounts screen "(.*?)"$/ do |button|
    @restaurant_discounts_page.click_button(button)
end

Then /^I search from the iOS Restaurant Discounts for restaurants around "(.*?)"$/ do |location|
    @restaurant_discounts_page.search_for_location(location)
end

And /^I validate that the favorites counter has "(.*?)"$/ do |expected_value|
    @restaurant_discounts_page.validate_favorite_counter_has_update(expected_value)
end

And /^I update the Favourites counter$/ do
    @restaurant_discounts_page.set_favorites_counter
end

And /^I validate from the iOS Restaurant Discounts that "(.*?)" is visible in the previous search results$/ do |location|
    wait_for(:timeout => 30){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSContainerViewController.change_location'")}
    touch("* id:'net.wamapp.wam.Calabash.WAMRSContainerViewController.change_location'")
    @restaurant_discounts_page.validate_location_exists_in_page(location)
end 

Then /^I search for a restaurant on the iOS Restaurant Discounts screen$/ do
    @restaurant_discounts_page.search_a_restaurant(@restaurant_name)
end

Then /^I validate the displayed restaurant from the iOS Restaurant Discounts screen$/ do
  @restaurant_discounts_page.validate_restaurant(@restaurant_name)
end