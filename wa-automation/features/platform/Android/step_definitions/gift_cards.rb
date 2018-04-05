# -*- encoding : utf-8 -*-
Given /^I am on the Android Gift Cards screen$/ do
	@gift_cards_page = page(AndroidGiftCardsPage).await
	@gift_cards_page.is_visible('Main')
end
	
When /^I click from the Android Gift Cards screen "(.*?)"$/ do |button|
	@gift_cards_page.click_button(button)
end

Then /^I validate Gift Cards offers from the Android app$/ do
	@gift_cards_page.go_over_table
end

Then /^I select from the Android Gift Cards screen "(.*?)"$/ do |category|
	@gift_cards_page.select_category(category)
end

And /^I open "(.*?)" Gift Cards offer from the Android app$/ do |gift_card_name|
	@gift_cards_page.select_gift_card(gift_card_name)
end

And /^I buy "(.*?)" gift cards from the Android app with value of "(.*?)" pounds$/ do |quantity, value|
	@gift_cards_page.buy_gift_card(quantity.to_i, value.to_i)
end
