# -*- encoding : utf-8 -*-
Given /^I am on the Gift Cards Offers screen$/ do 
	@gift_cards_page = HermesGiftCardsPage.new @browser
	@gift_cards_page.is_visible('main')
end
	
When /^I open category "(.*?)" from Gift Cards screen$/ do |category|
	@gift_cards_page.open_category(category)
end

Then /^I validate data of all cards in the page$/ do
	@gift_cards_page.validate_data_of_cards
end

Then /^I open "(.*?)" gift card$/ do |gift_card_name|
	@gift_cards_page.open_gift_card_page(gift_card_name)
end

Then /^I buy "(.*?)" "(.*?)" gift cards with the value of "(.*?)"$/ do |quantity,gift_card_name, value|
	@gift_cards_page.buy_gift_card(quantity, gift_card_name, value)
end

Then /^I buy the Gift Card that was enabled with the first denomination available$/ do
	@gift_cards_page.open_category($GIFT_CARD_HASH[:category])
	@gift_cards_page.buy_gift_card(1, (FileService.new.get_from_file("current_gift_card:"))[0..-2])
end

Then /^I verify that the View your Gift Card Codes link redirects the user to the external giftcard page$/ do
	steps %Q{
    	Given I click "Gift Cards" from the "Perks" menu
  	}

  	@gift_cards_page.verify_view_giftcard_codes_link_redirection
end

Then /^I log into the Web App as a "(.*?)" user and navigate to the Gift Cards homepage$/ do |user_type|
    steps %Q{
	    Given I am on the Web App Login screen
	    And I log into the Web App as a valid "#{user_type}" user
	    When I click "Gift Cards" from the "Perks" menu
	    Then I am on the Gift Cards Offers screen
    }
end

Then /^I validate search functionality for a giftcard that "(.*?)" exist with "(.*?)"$/ do |giftcard_exists, suggested_search|
	@gift_cards_page.validate_gift_card_search_functionality(eval(giftcard_exists),eval(suggested_search))
end

Then /^I verify that the giftcard is hidden or visible depending on whether it has been enabled$/ do
	@gift_cards_page.open_category($GIFT_CARD_HASH[:category])
	@gift_cards_page.verify_giftcard_enabled_disabled
end