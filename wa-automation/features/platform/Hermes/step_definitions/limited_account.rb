Given /^I am on the Limited Account screen$/ do
    @limited_account_page = HermesLimitedAccountPage.new @browser
    @limited_account_page.is_visible('main')
end

Given /^I skip the Limited Account page$/ do
	 @limited_account_page.skip_limited_account_page
end

When /^I click "(.*?)" from the Limited Account Screen$/ do |button|
	@limited_account_page.click_button(button)
end