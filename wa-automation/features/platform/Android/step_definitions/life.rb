# -*- encoding : utf-8 -*-
Given /^I am on the "(.*?)" screen$/ do |screen|
    @life_page = page(AndroidLifePage).await
    @life_page.is_visible(screen)
end

Given /^I login or signup to the Android App with a "(.*?)" user and navigate to the Assessment homepage$/ do |user_type|
    if user_type == 'personal'
        steps %Q{
            Given I am logged into the Android App as a user that has not used the Android App before
        }
    elsif user_type == 'shared'
        steps %Q{
            When I log into the Android App as a valid "shared" user
        }
    end
    steps %Q{
        Then I click from the Menu screen "Assessments"
        Given I am on the Assessments screen
    }
end