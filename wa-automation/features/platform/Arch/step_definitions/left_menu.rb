# -*- encoding : utf-8 -*-
When /^I click on "(.*?)" from Left menu$/ do |button|
    @left_menu_page = ArchLeftMenuPage.new @browser_arch
    @left_menu_page.click_button(button)
end

When /^I return to Arch$/ do
	@browser_arch.goto $ARCH
end

And /^I logout from Arch$/ do
	@browser_arch.a(:id, 'user-logged-in-as').wait_until_present
	@browser_arch.a(:id, 'user-logged-in-as').fire_event('click')
	@browser_arch.div(:class, %w(navbar navbar-fixed-top navbar-inverse)).a(:text, 'Logout').wait_until_present
	@browser_arch.div(:class, %w(navbar navbar-fixed-top navbar-inverse)).a(:text, 'Logout').fire_event('click')
end
