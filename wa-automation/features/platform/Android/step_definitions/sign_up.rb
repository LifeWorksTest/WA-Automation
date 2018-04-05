# -*- encoding : utf-8 -*-
Given /^I am on the Android Sign up screen$/ do
	@sign_up_page = page(AndroidSignUpPage).await
end

When /^I enter all my details in the Android app$/ do
	@sign_up_page.enter_details 
end

Then /^I click from the Android Sign up screen "(.*?)"$/ do |button|
	@sign_up_page.click_button(button)
end

And /^I choose my intersts from the Android app$/ do
	@sign_up_page.choose_intersts
end
