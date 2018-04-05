# -*- encoding : utf-8 -*-
Given /^I am on the Restaurant screen$/ do
    @restaurant_page = HermesRestaurantDiscountsPage.new @browser
    @restaurant_page.is_visible('Main')
end

Given /^I log into the Web App as a "(.*?)" user and navigate to the Restaurant homepage$/ do |user_type|
    steps %Q{
        Given I am on the Web App Login screen
        And I log into the Web App as a valid "#{user_type}" user
        When I click "Restaurant" from the "Perks" menu
        Then I am on the Restaurant screen
    }
end

Given /^I select "(.*?)" random cuisine types from the cuisine filter list$/ do |cuisines_to_select|
    @restaurant_page.select_random_cuisine_types(cuisines_to_select.to_i)
end

When /^I "(.*?)" "(.*?)" using the "(.*?)"$/ do |operation, restaurant, favouriting_method|
    favouriting_method == 'Restaurant image' ? click_restaurant_card = true : click_restaurant_card = true
    
    @restaurant_page.go_to_resturant(restaurant, click_restaurant_card)
    @restaurant_page.favourite_unfavourite_restaurant(operation, restaurant)
end

Then /^I validate Hilife Dining Card functionality for "(.*?)" restaurants$/ do |counter|
    counter = counter.to_i - 1

    for i in 0..counter
        @restaurant_page.open_restaurant_by_index(i)
        @restaurant_page.click_button('Browser back')
    end
end

And /^I check Restaurant link to restaurants$/ do
    @restaurant_page.check_link_to_restaurant
end

And /^I check that "(.*?)" "(.*?)" favourites$/ do |restaurant, state| 
    steps %Q{
        Given I click "Restaurant" from the "Perks" menu
   		And I am on the Restaurant screen
    }
    @restaurant_page.check_if_in_favourites(restaurant, state)
    steps %Q{
        Given I click "Restaurant" from the "Perks" menu
   		And I am on the Restaurant screen
    }
end

And /^I remove all restaurants from favourites$/ do
    @restaurant_page.remove_all_restaurants_from_favourites
    steps %Q{
        Given I click "Restaurant" from the "Perks" menu
        And I am on the Restaurant screen
    }
end

And /^I should only see restaurants that contain the cuisine type selected$/ do
    @restaurant_page.verify_restaurant_visibility(false)
end

And /^I should see an unfiltered list of restaurants that contain all available cuisine types$/ do
    @restaurant_page.verify_restaurant_visibility(true)
end

And /^I deselect all selected cuisine filters by clicking "(.*?)"$/ do |method_to_deselect|
    @restaurant_page.clear_all_cuisines(method_to_deselect)
end