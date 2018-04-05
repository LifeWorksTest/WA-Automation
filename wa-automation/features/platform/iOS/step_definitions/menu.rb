# -*- encoding : utf-8 -*-
Given /^I am on the iOS Menu screen$/ do
	steps %Q{
		Given I am on the iOS Get Started screen and not logged in to the app
	}

	@menu_page = page(IOSMenuPage).await

	#if $current_user_company_id == nil
	#	@file_service = FileService.new
#		$current_user_name = @file_service.get_from_file('current_user_name:')[0..-2]
#		$current_user_company_id = @file_service.get_from_file('current_user_company_id:')[0..-2]
#		$current_user_id =  @file_service.get_from_file('current_user_id:')[0..-2]
#	end
end

Then /^I click from the iOS Menu screen "(.*?)"$/ do |button|
	@menu_page.open_from_menu(button)
end 

Given /^I am on the iOS Get Started screen and not logged in to the app$/ do
	if element_exists("label marked:'Enter invitation code'") || element_exists("button marked:'close button'")
		steps %Q{
			Given I am on the iOS Get Started screen
		    Then I click from the iOS Get Started screen "Log in"
		    
		    Given I am on the iOS Login screen
		    When I insert valid credential
		    Then I am on the iOS Menu screen
		}
		puts "The user was not logged in and therefor login scenario was executed"
	end
end

When /^I open iOS Notification from the menu$/ do
	steps %Q{
		Given I am on the iOS Menu screen
	}
	
    @menu_page.open_from_menu('Notification')
end

And /^I check that this user got the next notification "(.*?)" from the iOS app$/ do |notification|
	@menu_page.check_for_notification(notification)
end

