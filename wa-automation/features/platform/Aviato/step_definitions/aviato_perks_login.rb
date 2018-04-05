Given /^I log in to Perks Aviato and select "(.*?)"$/ do |country_code|
	@login_page = AviatoPerksLoginPage.new @browser
    @login_page.is_visible
    @login_page.login(ACCOUNT[:account_1][:arch][:email], ACCOUNT[:account_1][:arch][:password], country_code)
end

Given /^I log in to Perks Aviato and select the country code according to the test configuration$/ do
	@login_page = AviatoPerksLoginPage.new @browser
    @login_page.is_visible
    @login_page.login(ACCOUNT[:account_1][:arch][:email], ACCOUNT[:account_1][:arch][:password], ACCOUNT[:account_1][:valid_account][:country_code].upcase)
end

