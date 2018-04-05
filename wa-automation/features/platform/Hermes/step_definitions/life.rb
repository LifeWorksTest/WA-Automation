# -*- encoding : utf-8 -*-
Given /^I am on the "(.*?)" screen$/ do |screen|
    @life_page = HermesLifePage.new @browser
    @life_page.is_visible(screen)
end

Given /^I login or signup to the Web App with a "(.*?)" user and navigate to the Assessment homepage$/ do |user_type|
    if user_type == 'personal'
        steps %Q{
            Given I am logged into the Web App as a user that has not used the Web App before
        }
    elsif user_type == 'shared'
        steps %Q{
            Given I am on the Web App Login screen
            When I log into the Web App as a valid "shared" user
        }
    else
        steps %Q{
            Given I create a new limited account user and login to the Web App
        }
    end

    steps %Q{
        Given I click "Assessments" from the "Life" menu
        Then I am on the "Assessment Homepage" screen
    }
end    

And /^I validate that all the pages in Life section are accessible$/ do

	if $USER_FEATURE_LIST['eap']
        steps %Q{
            When I click "Need Help" from the "Life" menu
            Then I am on the "Need Help" screen
        }
    end 
 	
 	if $USER_FEATURE_LIST['eap_assistance']
        steps %Q{
            When I click "Employee Assitance" from the "Life" menu
            Then I am on the "Employee Assitance" screen
        }    
    end

    if $USER_FEATURE_LIST['eap_chat']
        steps %Q{
            When I click "Chat" from the "Life" menu
            Then I am on the "Chat" screen
        }  
    end
    
    if $USER_FEATURE_LIST['eap_health_library']
        steps %Q{
            When I click "Health Library" from the "Life" menu
            Then I am on the "Health Library" screen
        }      
    end
    
    if $USER_FEATURE_LIST['eap_legal_services']
        steps %Q{
            When I click "Legal Services" from the "Life" menu
            Then I am on the "Legal Services" screen
        }    
    end

    if $USER_FEATURE_LIST['eap_cerner']
        steps %Q{
            When I click "Wellness Tools" from the "Life" menu
            Then I am on the "Wellness Tools" screen
        }      
    end
end

When /^I open "(.*?)" with exeternal links and validate successful redirection$/ do |screen|
    puts "Screen is #{screen}"
    
    if (screen == 'Health Library') && ($USER_FEATURE_LIST['eap_health_library'])
        steps %Q{
            When I click "Health Library" from the "Life" menu
            Then I am on the "Health Library" screen
            Then I click GoTo button
            Then I am successfully redirected to the external website
        }      
    end

    if (screen == 'Wellness Tools') && ($USER_FEATURE_LIST['eap_cerner']) && (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US')
        steps %Q{
            When I click "Wellness Tools" from the "Life" menu
            Then I am on the "Wellness Tools" screen
        }

        if $ACCOUNT_TYPE != 'shared'
            steps %Q{
            Then I click GoTo button
            Then I am successfully redirected to the external website
        }      
        end
    end
    
    if (screen == 'Legal Services') && ($USER_FEATURE_LIST['eap_legal_services']) && (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US')
        steps %Q{
            When I click "Legal Services" from the "Life" menu
            Then I am on the "Legal Services" screen
            Then I click GoTo button
            Then I am successfully redirected to the external website
        }    
    end
    sleep 5
end

Then /^I open one of the articles in the first category by following the links$/ do
  @life_page.open_an_article
end

Then /^I search for the article title$/ do
  @life_page.open_an_article_by_searching
end

When /^I click GoTo button$/ do
  @life_page.go_to_external_page
end

When /^I validate that "(.*?)" form can be opened successfully$/ do |form_type|
 @life_page.open_enquiry(form_type)
end

When /^I validate that all the categories have sub-categories linked to them$/ do
 @life_page.eap_page_validate_categories
end

When /^I open one of the articles in the second category$/ do
 @life_page.eap_page_open_article
end

When /^I go back to the main page$/ do
 @life_page.eap_page_navigate_to_homepage
end

Given /^I select "(.*?)" categories and "(.*?)" Snackable sub topics$/ do |categories_to_select, topics_to_select|
    @life_page.select_wellness_categories(categories_to_select,topics_to_select)
end

And /^I verify that "(.*?)" Snackable sessions can be viewed per day$/ do |max_sessions|
    @life_page = HermesLifePage.new @browser
    @life_page.verify_snackable_session_limit(max_sessions)
end

Then /^I verify snackable re engagement functionality "(.*?)"$/ do |set_another_interest|
    @life_page.verify_re_engagement(eval(set_another_interest))
end

Then /^I validate that I only see the phone numbers displayed for the logged-in users locale$/ do
    @life_page.validate_cms_phone_numbers
end

Then /^I start a new assessment$/ do
    @life_page.click_button('Start main assessment')
end

Then /^I complete a Wellbeing Assessment series and retake each assessment "(.*?)" times$/ do |times_to_retake_assessment|
    @life_page.get_assessment_group_details
    @life_page.complete_assessment_series(times_to_retake_assessment.to_i)
end

