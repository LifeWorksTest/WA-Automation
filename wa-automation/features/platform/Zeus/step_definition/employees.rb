# -*- encoding : utf-8 -*-
Given /^I am on the Employees screen$/ do
    @employees_page = ZeusEmployeesPage.new @browser
end

Given /^I invite friend from the Colleague page$/ do
    @employees_page.click_button('Manage Colleagues')
    steps %Q{
        When I am on the Manage Colleagues screen
        Then I invite a friend from the Manage Colleague screen
    }
end

When /^I go to "(.*?)"$/ do |tab_name|
    @employees_page.go_to(tab_name)
end

Then /^I click on "(.*?)" from Employees screen$/ do |button|
    @employees_page.click_button(button)
end

Then /^I "(.*?)" all users accourding to the list$/ do |action|
    @employees_page.go_over_colleagues_list_and_do(action)
end

Then /^I open user profile index "(.*?)"$/ do |user_index|
    @employees_page.open_profile(nil, user_index.to_i)
end

Then /^I open user profile name "(.*?)"$/ do |user_name|
    if user_name == 'last user that join'
        file_service = FileService.new
        counter = file_service.get_from_file("invite_email_counter:")[0..-2]
        user_name = "user#{counter} user#{counter}"
        puts "Opein profile #{user_name}"
    end
   
    @employees_page.open_profile(user_name, nil)
end

Then /^I open the user profile I would like to deactivate$/ do
    steps %Q{
        Then I open user profile name "#{ACCOUNT[:"#{$account_index}"][:user_name_to_delete]}"
    }
end

Then /^I open the user profile the make as an Admin$/ do
    steps %Q{
        Then I open user profile name "#{ACCOUNT[:"#{$account_index}"][:user_name_to_make_as_admin]}"
    }
end

Then /^I validate all tabs$/ do
    @employees_page = ZeusEmployeesPage.new @browser
    @employees_page.validate_all_data_in_all_tabs
end

Then /^I "(.*?)" the latest user to sign up in Pending$/ do |action|
    @employees_page.remind_or_delete(action)
end

When /^I "(.*?)" the latest user to sign up in Archived$/ do |action|
    @employees_page = ZeusEmployeesPage.new @browser
    @employees_page.restore_or_delete(action)
end

Then /^I "(.*?)" the latest user to sign up in Approval$/ do |action|
    @user_name = @employees_page.approve_or_reject(action)
end

And /^I check that the new employee was add to Active Employees list$/ do
    @employees_page.search_for(@user_name)
    @employees_page.check_search_results(@user_name, 'Results')
end

And /^I check the link to each employee$/ do
    @employees_page.check_links_to_colleagues
end
    
And /^I search for "(.*?)" from Employees screen$/ do |search|
    @employees_page.search_for(search)
end

And /^I validate the results for "(.*?)" and I expect to see results "(.*?)"$/ do |search, with_results|
    @employees_page.check_search_results(search, with_results)
end

And /^I add a new user to the network$/ do
    steps %Q{
        Given I invite friend from the Colleague page
        Given I am on the Web App Login screen
        When I click "Signup" from the Web App Login screen
        Then I sign up to the Web App using "Personal Code" with a "matching" company email domain    
    }
    @browser.goto $ZEUS
end

And /^I set Colleague Managment snapshot$/ do
    @employees_page.set_colleague_managment_snapshot
end

And /^I check if "(.*?)" is in Pending list$/ do |user_email|
    @employees_page.check_user_is_in_pending_list(user_email)
end

And /^I check if the (\d+) uploaded "(.*?)" csv users are in Pending list$/ do |number_of_users_to_check, email_or_id|
    @employees_page.check_csv_uploaded_user_is_in_pending_list(number_of_users_to_check, email_or_id)
end

And /^I delete all users in Pending$/ do
    @employees_page.delete_all_pending
end

And /^I approve all users in Pending$/ do
    @employees_page.approve_all_pending
end

