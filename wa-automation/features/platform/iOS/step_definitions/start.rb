# -*- encoding : utf-8 -*-
Given /^I am on the iOS Get Started screen$/ do
    steps %Q{
       Given the user is logged to the iOS app and not logged out
    }
    @start_page = page(IOSStartPage).await
end

When /^I click from the iOS Get Started screen "(.*?)"$/ do |button|
	@start_page.click_button(button)	
end

Then /^I insert "(.*?)" invitation code from the iOS app$/ do |invitation_code|
	$invitation_code = invitation_code
    if invitation_code == 'Personal Code'     
        steps %Q{
            And I recived an email with the subject "join"
        }
         
        puts "RETURNED_VALUE_FROM_EMAIL #{$returned_value_from_email}"
        @start_page.insert_code($returned_value_from_email)

        #@start_page.insert_code($returned_value_from_email)
    elsif invitation_code == 'Company Code'
        file_service = FileService.new
		@start_page.insert_code(file_service.get_from_file("company_invitation_code:")[0..-2])
    end
end

Given /^the user is logged to the iOS app and not logged out$/ do
    if (element_exists("* marked:'More'") || element_exists("* marked:'News Feed'") || element_exists("UIImageView id:'ic_skip_arrow'"))
        steps %Q{
            And I logout from the iOS app 
        }
    end
end
