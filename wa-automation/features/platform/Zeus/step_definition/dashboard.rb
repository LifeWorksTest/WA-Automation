# -*- encoding : utf-8 -*-
Given /^I am on the Dashboard$/ do
    @dashboard_page = ZeusDashboardPage.new @browser
    @dashboard_page.is_visible
end

Given /^I invite friend$/ do
    if @dashboard_page == nil
        @dashboard_page = ZeusDashboardPage.new @browser
    end

    @dashboard_page.click_button('Add New Colleagues')
    steps %Q{
        Given I am on the Manage Colleagues screen
        And I invite a friend from the Manage Colleague screen
    }
end

When /^I send this post from dashboard "(.*?)"$/ do |post_text|
    @dashboard_page.send_new_post(post_text)
end

When /^I send this post from dashboard "(.*?)" for "(.*?)" times$/ do |post_text, amount|
    for i in 0..amount.to_i
        @dashboard_page.send_new_post(post_text + i.to_s)
        sleep(1)
    end
end

When /^I check that this recognition is existing in Latest Recognition "(.*?)" badge "(.*?)" to "(.*?)"$/ do |recognition_text, recognition_badge, recognition_reciver|
	@dashboard_page.validate_latest_recognitions(recognition_text, recognition_badge, recognition_reciver)
end

When /^I add a new user to the network from Dashboard$/ do
    @dashboard_page.click_button('Add New Colleagues')
    steps %Q{
        Given I am on the Manage Colleagues screen
        And I invite a friend from the Manage Colleague screen
        And I am on the Web App Login screen
        When I click "Signup" from the Web App Login screen
        Then I sign up to the Web App using "Personal Code" with a "matching" company email domain 
    }
end

When /^I set "(.*?)"$/ do |option|
    if option == 'Engagement'
        @dashboard_page.set_engagement
    elsif option == 'Total Spending'
        @dashboard_page.set_total_spending
    end
end

Then /^I validate empty state in the Admin Panel Dashboard screen$/ do
    @dashboard_page.validate_dashboard_empty_state
end

Then /^I check functionality of View All buttons$/ do
    @dashboard_page.view_all_button_functionality
end

Then /^I am back to Dashboard$/ do
    @dashboard_page.is_visible
end

Then /^I validate the date in "(.*?)"$/ do |box_name|
    @dashboard_page.validate_date_in(box_name)
end

And /^I validate the changes in "(.*?)"$/ do |option|
    if option == 'Engagement'
        @dashboard_page.validate_engagement_after_update
    elsif option == 'Total Spending'
        @dashboard_page.validate_total_spending_after_update
    end
end 

And /^I update statistics for this company$/ do
    api = Api.new 
    api.update_company_analystics($current_user_company_id)
end
