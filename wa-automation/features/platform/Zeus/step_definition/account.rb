# -*- encoding : utf-8 -*-
Given /^I am on the Account screen$/ do 
    @account_page = ZeusAccountPage.new @browser
    @account_page.is_visible('Company Profile')
end

When /^I click on "(.*?)" from the Account screen$/ do |button|
    @account_page.click_button(button)
end

When /^I change company Founded date to today$/ do
    @account_page.change_founded_date_to_today
end

Then /^I upgrade the company account to premium$/ do
    @browser.div(:text, 'Stay on Premium').wait_until_present
    @browser.span(:text, 'Continue on Premium').wait_until_present

    month = (Date.today >> 3).strftime("%B")
    payment_month = (Date.today >> 4).strftime("%B")
    day = (Date.today >> 3).strftime("%-d")
    year = (Date.today >> 3).strftime("%Y")

    @browser.div(:text => /Your current trial ends on the #{day}.. #{month} #{year}. Upgrade your account now to continue enjoying LifeWorks Premium./).wait_until_present

    @browser.span(:text, 'Continue on Premium').click
    
    @account_page = ZeusAccountPage.new @browser

    @account_page.upgrade_to_premium

    if $distributor == 'Santander'
        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "company upgraded to premium"
            }
        end
    else
        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "upgraded to LifeWorks"
            }
        end
    end
end

Then /^I change company profile to "(.*?)"$/ do |profile|
    @account_page.change_profile_data_to(profile)
end

Then /^I get company profile$/ do
    @account_page.get_company_profile
end

Then /^I check pricing calculation$/ do 
    @account_page.check_pricing
end

Then /^I change card details to "(.*?)"$/ do |profile|
    @account_page.change_card_details(profile)
end

Then /^I change billing address details to "(.*?)"$/ do |profile|
    @account_page.change_billing_address(profile)
end

Then /^I "(.*?)" "(.*?)" as Admin$/ do |action, user_name|
    @account_page.add_remove_user_from_admin_list(action, user_name)
end

Then /^I "(.*?)" an existing user as Admin$/ do |action|
    steps %Q{
        Then I "#{action}" "#{ACCOUNT[:"#{$account_index}"][:user_name_to_make_as_admin]}" as Admin
    }
end

And /^I check that the changes are match to "(.*?)"$/ do |profile|
    @account_page.check_profile_is_match_to(profile)
end

And /^I am back to Company Profile$/ do
   @account_page.is_visible('Company Profile')
end 

And /^I check that the billing as change to "(.*?)"$/ do |profile|
    @account_page.check_card_and_billing_detail_are_match_to(profile)
end

And /^I check that the new Admin "(.*?)" login as "(.*?)"$/ do |state, role|
    steps %Q{
        And I check that "#{ACCOUNT[:"#{$account_index}"][:user_name_to_make_as_admin]}" "#{state}" login as "#{state}"
    }
end

And /^I check that "(.*?)" "(.*?)" login as "(.*?)"$/ do |user_name, state, role|
    if state == 'can'
        steps %Q{
            Given I am on the Admin Panel Login screen
            When I try to login with "#{ACCOUNT[:"#{$account_index}"][:user_email_to_make_as_admin]}" 
            Then I am login to Admin Panel
        } 
    elsif  state == 'cant'
        steps %Q{
            Given I am on the Admin Panel Login screen
            When I try to login with "#{ACCOUNT[:"#{$account_index}"][:user_email_to_make_as_admin]}"
            Then I verify that a non admin user cannot login into Admin Panel
        } 
    end
end

And /^I validate all changes in view after I "(.*?)" an existing user$/ do |action|
    steps %Q{
        And I validate all changes in view after I "#{action}" "#{ACCOUNT[:"#{$account_index}"][:user_name_to_make_as_admin]}"
    }
end

And /^I validate all changes in view after I "(.*?)" "(.*?)"$/ do |action, user_name|
    steps %Q{
       And I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
    }
    
    @account_page.validate_changes_in_view_after_changing_admin_list(action, user_name)
end

And /^I change the Newtwork Owner$/ do
    @account_page.transfer_ownership
end

