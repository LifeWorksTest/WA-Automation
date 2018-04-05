# -*- encoding : utf-8 -*-
Given /^I am on Arch Withdrawls screen$/ do
    @withdrawls_page = ArchWithdrawlsPage.new @browser_arch
    @withdrawls_page.is_visible
end

When /^I "(.*?)" withdrew request to "(.*?)" that belong to User: "(.*?)" ID: "(.*?)" with amount of "(.*?)"$/ do |action, paypal_or_bank, user_name, user_id, amount|
	puts "#{action}, #{paypal_or_bank}, #{user_id}, #{amount}, #{user_name}"
	@withdrawls_page.approve_decline_transaction(action, paypal_or_bank, user_name, user_id, amount)
end
