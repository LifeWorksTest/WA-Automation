# -*- encoding : utf-8 -*-
Given /^I am on the iOS Signup screen$/ do
	@sign_up_page = page(IOSSignUpPage).await
end

When /^I enter all my details from the iOS app$/ do
	@sign_up_page.enter_details 
end

Then /^I click from the iOS Signup screen "(.*?)"$/ do |button|
	@sign_up_page.click_button(button)
end

And /^I choose my intersts from the iOS app$/ do
	@sign_up_page.choose_intersts
end


