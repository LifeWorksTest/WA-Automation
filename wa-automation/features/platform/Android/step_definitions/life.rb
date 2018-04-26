
Given(/^I am on the Employee Assistance screen$/) do
    @life_page = page(AndroidLifePage).await
  end
  
  Then(/^I validate that all the categories have sub\-categories$/) do
    @life_page.validate_catogries
  end

  Then(/^I open one of the articles by following the links$/) do
    @life_page.open_an_article
  end

# -*- encoding : utf-8 -*-
Given /^I am on the Assessments screen$/ do
    @life_page = page(AndroidLifePage).await
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

Then /^I complete new Assessment$/ do
    @life_page.complete_new_assessment
end

And /^I retake the assessment "(.*?)" times$/ do |times_to_retake_assessment|
    @life_page.complete_assessment_series(times_to_retake_assessment.to_i)
end
