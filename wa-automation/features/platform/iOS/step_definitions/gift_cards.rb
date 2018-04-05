# -*- encoding : utf-8 -*-
Given /^I am on the iOS Gift Cards screen$/ do
	@gift_cards_page = page(IOSGiftCardsPage).await
	@gift_cards_page.is_visible('Main')
end
	
When /^I click from the iOS Gift Cards screen "(.*?)"$/ do |button|
	@gift_cards_page.click_button(button)
end

Then /^I validate Gift Cards offers$/ do
	@gift_cards_page.go_over_table
end

Then /^I select from the iOS Gift Cards screen "(.*?)"$/ do |category|
	@gift_cards_page.select_category(category)
end

And /^I open "(.*?)" Gift Cards offer$/ do |gift_card_name|
	@gift_card_name = gift_card_name
	@gift_cards_page.select_gift_card(gift_card_name)
end

And /^I buy "(.*?)" gift cards from the iOS app with value of "(.*?)" pounds$/ do |quantity, value|
	@gift_cards_page.buy_gift_card(@gift_card_name, quantity.to_i, value.to_i)
end

And /^I return to the iOS Gift Cards main screen$/ do
  	@gift_cards_page.return_to_main_page
end

And /^I buy the Gift Card that was enabled with the first denomination available from the iOS app$/ do
	steps %Q{
		And I open "#{(FileService.new.get_from_file("current_gift_card:"))[0..-2]}" Gift Cards offer
	}
	@gift_cards_page.buy_gift_card(@gift_card_name, 1)
end