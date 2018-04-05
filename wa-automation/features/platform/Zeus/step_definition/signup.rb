# -*- encoding : utf-8 -*-
Given /^I am on the Admin Panel Sign Up screen$/ do
	@browser = $browser
    @signup_page = ZeusSignUpPage.new @browser
end

Given /^I signup my company to Work Angel$/ do
	steps %Q{
		Given I am on the Admin Panel Sign Up screen
	    When I insert all my details "with" promotional code
	    Then I recived an email with the subject "welcome_to_lifeworks"
	    And I varify the new Admin Panel account  
	    And I logout from Admin Panel
	}
end

Given /^I am on the "(.*?)" lending screen$/ do |page|
	@santander_page = ZeusSantanderPage.new $browser
end

When /^I click on "(.*?)" from the lending screen$/ do |button|
	@santander_page.click_button(button)
end

Then /^I insert all my details "(.*?)" promotional code$/ do |with_promotional| 
    @signup_page.sign_up(with_promotional)
end

Then /^I signup new "(.*?)" company$/ do |company|
	@santander_page.signup

	if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "Your LifeWorks Free Trial"  
        }
    end
end

And /^I varify the new Admin Panel account$/ do
    @signup_page.varify_account
end
