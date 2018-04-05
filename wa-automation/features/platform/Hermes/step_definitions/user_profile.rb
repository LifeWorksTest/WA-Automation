# -*- encoding : utf-8 -*-
When /^I click "(.*?)" from User Profile screen$/ do |button|
    @user_profile_page.click_button(button)
end

When /^I change user Birthday and Joind to the current month and day$/ do
    @user_profile_page.set_birthday_joined_data_today
end

Then /^I am on Web App User Profile screen$/ do
    @user_profile_page = HermesUserProfilePage.new @browser
    @user_profile_page.is_visible('Proflie')
end

Then /^I am on the Settings screen$/ do 
    @user_profile_page.validate_settings
end

Then /^I change my details to "(.*?)"$/ do |user|
    @user_profile_page.change_profile_data_to(user)
end

Then /^I "(.*?)" my age$/ do |hide_or_not|
    @user_profile_page.hide_dont_hide_my_age(hide_or_not)
end

Then /^I validate Interests functionality$/ do
    @user_profile_page.tick_untick_all_interests('untick')
    @user_profile_page.tick_untick_all_interests('tick')

end

Then /^I hover over Medals and Milstones and I validate the data$/ do
    @user_profile_page.validate_achievements
end

And /I check that user profile as change to "(.*?)"$/ do |user|
    @user_profile_page.check_profile_is_match_to(user)
end

And /^I check the functionality of the carousel$/ do
    @user_profile_page.check_carousel
end

And /^I click back from the browser$/ do
    @browser.back
end

And /^I am back to User Profile screen$/ do
    @user_profile_page.is_visible('user_profile')
end

And /^I invite "(.*?)" new family members to the company$/ do |users_to_invite|
    @user_profile_page.invite_family_members(users_to_invite.to_i)
end

And /^I remove "(.*?)" family members from the company$/ do |users_to_delete|
    @user_profile_page.delete_family_members(users_to_delete)
end

Then /^I should not be able to invite anymore family members to the company$/ do
    steps %Q{ 
        Given I invite "1" new family members to the company
    }
end

Then /^I verify that the latest dependant user has a status of Active$/ do
    @user_profile_page.validate_family_members_added_or_deleted('active')
end