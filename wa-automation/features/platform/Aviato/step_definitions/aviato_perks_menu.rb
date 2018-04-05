Then /^I click "(.*?)" from the Perks Aviato menu$/ do |section|
	@menu_page = AviatoPerksMenuPage.new @browser
	@menu_page.click_button(section)
end

And /^I logout from Perks Aviato$/ do
	@menu_page.logout
end