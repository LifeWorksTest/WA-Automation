

Given /^I am on Gift Cards screen$/ do
    @gift_cards_page = ArchGiftCardsPage.new @browser_arch
    @gift_cards_page.is_visible
end

Then /^I turn "(.*?)" all Gift Cards$/ do |on_off|
	@gift_cards_page.enable_disable_all_gift_card(on_off)
end