# -*- encoding : utf-8 -*-
Given /^I am on Arch Login screen$/ do
	@browser_arch = $browser
    @arch_page = ArchLoginPage.new @browser_arch
    @arch_page.is_visible('login')
end

When /^I login to Arch$/ do
	@arch_page.login(ACCOUNT[:account_1][:arch][:email], ACCOUNT[:account_1][:arch][:password])
end
