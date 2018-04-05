Given /^I am on the Perks Aviato Gift Cards screen$/ do
	@gift_card_page = AviatoPerksGiftCardsPage.new @browser
end

When /^I search for "(.*?)" Gift Card$/ do |gift_card_title|
	@gift_card_page.search_for_gift_card(gift_card_title)
end

When /^I open the "(.*?)" Gift Card$/ do |index|
	@gift_card_page.open_by_index(index.to_i)
end

Then /^I edit the Gift Card with random info and enable it$/ do
	@gift_card_page.edit_gift_card_page
end

Then /^I make the "(.*?)" Gift Card "(.*?)"$/ do |index, enabled_disabled|
	@gift_card_page.enable_disable_giftcard(index.to_i, enabled_disabled.downcase)
end