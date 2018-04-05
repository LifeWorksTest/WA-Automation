# -*- encoding : utf-8 -*-
Given /^I am on the Android Get Started screen$/ do
    steps %Q{
        Given the user is logged to the Android app and not logged out
    }
    
    @start_page = page(AndroidStartPage).await
    @start_page.set_env
end

When /^I click from the Android Get Started screen "(.*?)"$/ do |button|
	@start_page.click_button(button)
end

Then /^I insert "(.*?)" invitation code from the Android app$/ do |invitation_code|
	$invitation_code = invitation_code
    
    if invitation_code == 'Personal Code'     
        steps %Q{
            And I recived an email with the subject "Join"
        }
         
        puts "RETURNED_VALUE_FROM_EMAIL #{$returned_value_from_email}"
        @start_page.insert_code($returned_value_from_email)
    elsif invitation_code == 'Company Code'
        file_service = FileService.new
		@start_page.insert_code(file_service.get_from_file("company_invitation_code:")[0..-2])
    end
end

