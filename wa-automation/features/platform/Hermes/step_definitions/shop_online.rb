# -*- encoding : utf-8 -*-
Given /^I am on the Shop Online screen$/ do
    @shop_online_page = HermesShopOnlinePage.new @browser
    @shop_online_page.is_visible('main')
    @api_page = Api.new  
end

Given /^I log into the Web App as a "(.*?)" user and navigate to the Shop Online homepage/ do |user_type|
    steps %Q{
    Given I am on the Web App Login screen
    And I log into the Web App as a valid "#{user_type}" user
    When I click "Shop Online" from the "Perks" menu
    Then I am on the Shop Online screen
    }
end

When /^I validate the data of "(.*?)" "(.*?)" per category for "(.*?)" random categories$/ do |retailers_or_offers_to_validate, retailer_type, amt_of_categories|
    @shop_online_page.validate_retailers_data(retailers_or_offers_to_validate.to_i,retailer_type,amt_of_categories)
end

Then /^I get the users companies Incentive Networks base and bonus cashback rate$/ do
    company = @api_page.get_company($current_user_company_id)
    @bonus_incentive_networks = @api_page.get_cashback_value_from_feature_list(company, 'benefit_cashback_bonus_incentive_networks_multiple_proc').to_f
    @base_incentive_networks_multiple = @api_page.get_cashback_value_from_feature_list(company, 'benefit_cashback_base_incentive_networks_multiple_proc').to_f
    puts "@bonus_incentive_networks:#{@bonus_incentive_networks} @base_incentive_networks_multiple:#{@base_incentive_networks_multiple}"
end

Then /^I get retailer "(.*?)" base cashback using the configuration file$/ do |retailer_name| 
    user_token = @api_page.get_user_token(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password])
    @retailer_base_cashback = (@api_page.get_retailer(SHOP_ONLINE_RETAILERS[:"#{retailer_name}"][:id], user_token)['body']['cashback_base']['amount']).to_f
    puts "@retailer_base_cashback:#{@retailer_base_cashback}"
end

Then /^I validate that the presented cashback is correct accourding to Base & Bonus Incentive Networks cashback$/ do
    steps %Q{
        Then I get the users companies Incentive Networks base and bonus cashback rate
    }
    
    if @browser.div(:class, %w(offer__value offer__value--small offer__value--center ng-scope)).text.include? '.'
        presented_cashback = (/\d+[,.]\d+/.match @browser.div(:class, %w(offer__value offer__value--small offer__value--center ng-scope)).text)[0].to_f
    else
        presented_cashback = (/\d+/.match (@browser.div(:class, %w(offer__value offer__value--small offer__value--center ng-scope)).text))[0].to_f
    end

    puts "presented_cashback:#{presented_cashback}"

    if @bonus_incentive_networks == 0
        calaulated_cashback = @retailer_base_cashback
    else
        calaulated_cashback = ((@base_incentive_networks_multiple * @retailer_base_cashback) + (@bonus_incentive_networks * @retailer_base_cashback).round(2)).round(2)
    end

    if calaulated_cashback != presented_cashback
        fail(msg = "Error. Calculated cashback(#{calaulated_cashback}) is not match to presented_cashback(#{presented_cashback})")
    end

    puts "calaulated_cashback:#{calaulated_cashback}"
end

And /^I click on "(.*?)" from Shop Online screen$/ do |button|
    @shop_online_page.click_button(button)
end

And /^I "(.*?)" a "(.*?)" retailer to favourites using the retailers "(.*?)"$/ do |action, retailer, favourite_method| 
    # If the retailer is not random, then we use the category and retailer name from the ext data file and insert it to the data file
    if (retailer != 'random') && (@shop_online_page.return_or_amend_variable('Retailer Category') == nil)
        @shop_online_page.return_or_amend_variable('Retailer Category', SHOP_ONLINE_RETAILERS[:"#{retailer}"][:category])
        @shop_online_page.return_or_amend_variable('Retailer Name', SHOP_ONLINE_RETAILERS[:"#{retailer}"][:name])
    end

    @shop_online_page.select_category(@shop_online_page.return_or_amend_variable('Retailer Category'))
    @shop_online_page.select_retailer_type
    
    if favourite_method == 'retailers page'
        @shop_online_page.open_retailer(@shop_online_page.return_or_amend_variable('Retailer Name'))
        @shop_online_page.favourite_or_unfavourite_retailer(action)
        
        steps %Q{
            And I click "Shop Online" from the "Perks" menu
        }
    else
        @shop_online_page.favourite_or_unfavourite_retailer(action)
    end
end

And /^I remove all "(.*?)" retailers from favourites$/ do |retailer_type|
    @shop_online_page.remove_all_retailers_from_favourites(retailer_type)
end

And /^I check that the correct retailer "(.*?)" Favourites$/ do |state|
    @shop_online_page.validate_retailer_is_in_favourites(state)
end

And /^I validate the sort functionality of "(.*?)" "(.*?)" sorted by "(.*?)" for "(.*?)" random categories$/ do |retailers_or_offers_to_validate, retailer_type, sort_type, amt_of_categories|
    @shop_online_page.check_sort_filters(retailers_or_offers_to_validate.to_i,retailer_type,sort_type,amt_of_categories)
end

And /^I open "(.*?)" retailer website$/ do |retailer_type|
    retailer_type == 'retailers' ? button_name = 'Get Cashback' : button_name = 'Get offer'
    @shop_online_page.click_button(button_name)
end

And /^I select a random category and open a random "(.*?)" retailer$/ do |retailer_type|
    @shop_online_page.select_category
    @shop_online_page.select_retailer_type(retailer_type)
    @shop_online_page.open_retailer(nil)
end    

And /^I select a random category$/ do
    @shop_online_page.select_category
end

And /^I search for the "(.*?)" that is displayed last on the Shop Online page$/ do |retailer_type|
    @shop_online_page.validate_shop_online_search_functionality(false,nil,retailer_type)
end

And /^I search for a "(.*?)" retailer and click on the retailers name in the suggested search results dropdown$/ do |retailer_name|
    @shop_online_page.validate_shop_online_search_functionality(true,retailer_name)
end