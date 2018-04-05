# -*- encoding : utf-8 -*-
Given /^I am on the User Profile screen$/ do 
    @user_profile_page = ZeusUserProfilePage.new @browser
    @user_profile_page.is_visible(nil)
end

When /^I change the user profile to "(.*?)"$/ do |profile|
    @user_profile_page.change_profile_data_to(profile)
end

When /^I click on "(.*?)" from User Profile screen$/ do |button|
    @user_profile_page.click_button(button)
end

When /^I "(.*?)" a user$/ do |operation|
    if operation == 'reactivate'
        @user_profile_page.reactivate_user
    elsif  operation == 'deactivate'
        @user_profile_page.deactivate_user
    end 
end

Then /^I check that the user profile as change to "(.*?)"$/ do |profile|
    @user_profile_page.check_that_profile_as_change_to profile
end

Then /^I validate total amount of recognition that the user received/ do
    @user_profile_page.valid_total_amount_of_recognition_received
end

Then /^I validate total amount of recognition that the user sent$/ do
    @user_profile_page.valid_total_amount_of_recognition_given
end

Then /^I count the amount from each badge that the user used$/ do
    @user_profile_page.count_badges_by_type
end

Then /^I validate Milestones$/ do
    @user_profile_page.check_milestones
end

Then /^I change months to option index "(.*?)"$/ do |index|
    @user_profile_page.change_month(index.to_i, nil)
end

And /^I match both total amount of the badges that the user used$/ do
    @user_profile_page.match_total_amount_of_badges
end

And /^I validate Performance and Engagment for each month$/ do
    @user_profile_page.check_performance_and_engagment_for_every_month
end

And /^I "(.*?)" "(.*?)" as Admin from Employee Profile screen$/ do |action, user_name|
     @user_profile_page.add_remove_user_from_admin_list(action, user_name)
end

And /^I "(.*?)" an existing user as Admin from Employee Profile screen$/ do |action|
    steps %Q{
        And I "#{action}" "#{ACCOUNT[:"#{$account_index}"][:user_name_to_make_as_admin]}" as Admin from Employee Profile screen
    }
end
