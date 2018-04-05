# -*- encoding : utf-8 -*-
When /^I click on "(.*?)" from Top Bar menu$/ do |button|
	@top_bar_page = ZeusTopBarPage.new @browser
    @top_bar_page.click_button(button)
end

When /^I click on "(.*?)" from the "(.*?)" Zeus Top Bar menu$/ do |button, menu|
	@top_bar_page = ZeusTopBarPage.new @browser # To be removed 
	@top_bar_page.click_button(menu)
	@top_bar_page.click_button(button)
end	

Then /^I am login to Admin Panel$/ do
    @top_bar_page = ZeusTopBarPage.new @browser
end

# Call by user profile feature
Then /^I try to login to this account with expected retult to "(.*?)"$/ do |result|
	steps %Q{
		Given I am on the Web App Login screen
		When I try to login with the deactivated account and expect to "#{result}"
	}
	@browser.goto $ZEUS
end

Then /^I logout from Admin Panel$/ do
	if eval(ENV['LOGOUT_AFTER_SCENARIO'])
    	@top_bar_page.logout
    else
    	puts "Not logout"
    end
end

And /^I get back to Admin Panel$/ do
	@browser.goto $ZEUS
end

And /^I validate that all sections are visible in the Admin Panel$/ do

    steps %Q{
    	Given I click on "Dashboard" from Top Bar menu
		Then I am on the Dashboard

	    Given I click on "Performance" from Top Bar menu
	    When I click on "Leaderboard" from Top Bar menu
	    Then I am on the Admin Panel Leaderboard screen

	    Given I click on "Performance" from Top Bar menu
	    When I click on "Company" from Top Bar menu

	    Given I click on "Colleagues" from Top Bar menu
		Then I am on the Employees screen

		Given I click on "Timeline" from Top Bar menu
	    Then I am on the Timeline screen

	   	Given I click on "Menu" from Top Bar menu
	    When I click on "Account" from Top Bar menu
	    Then I am on the Account screen

	    Given I click on "Menu" from Top Bar menu
	    When I click on "Settings" from Top Bar menu
	    Then I am on the Admin Panel Settings screen    
    }

    if ACCOUNT[:account_1][:valid_account][:currency_name] == 'GBP'
    	steps %Q{
	    	Given I click on "Rewards" from Top Bar menu
	    }
	end
end


And /^I validate empty states in the Admin Panel$/ do
	steps %Q{
    	Given I am on the Admin Panel Login screen
		When I login with the new company account
		Then I am login to Admin Panel
		When I am on the Dashboard
		Then I validate empty state in the Admin Panel Dashboard screen
		
		Given I click on "Performance" from Top Bar menu
	    When I click on "Leaderboard" from Top Bar menu
	    Then I am on the Admin Panel Leaderboard screen
	    And I validate empty state in the Admin Panel Leaderboard screen
	}

	if ACCOUNT[:account_1][:valid_account][:currency_name] == 'GBP'
    	steps %Q{
	    	Given I click on "Rewards" from Top Bar menu
	    	Then I validate empty state in the rewards screen
	    }
	end
end