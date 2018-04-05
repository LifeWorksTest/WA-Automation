# -*- encoding : utf-8 -*-
Given /^I am on the Web App Login screen$/ do
    $SSO = false
    puts "$IS_FIRST_USER_LOGIN:#{$IS_FIRST_USER_LOGIN}"
    if $IS_FIRST_USER_LOGIN || !(@browser.div(:text, HERMES_STRINGS["components"]["main_menu"]["company"]["title"]).present?)
        @login_page = HermesLoginPage.new @browser
        @login_page.is_visible('login')
    end
end

Given /^I am on the new company Web App Login screen$/ do
    @file_service = FileService.new
    $SSO = false
    @browser.goto @file_service.get_from_file('new_company_url:')
    @login_page = HermesLoginPage.new @browser
    @login_page.is_visible('login')
end

Given /^I log into the Web App with a valid email and password$/ do
    steps %Q{
        Given I am on the Web App Login screen
        When I insert valid email and password
        Then I am login to Web App
        }
end

When /^I insert valid email and the new password$/ do
    if ($current_user_email == nil) || ( $current_user_email == '' )
        $current_user_email = ACCOUNT[:"#{$account_index}"][:valid_account][:email]
    end
    
    @login_page.login_to_web_app($current_user_email, ACCOUNT[:"#{$account_index}"][:reset_password_email][:new_password])
end

When /^I insert valid email and password$/ do
    if $IS_FIRST_USER_LOGIN || !(@browser.div(:text, HERMES_STRINGS["components"]["main_menu"]["company"]["title"]).present?)
        $current_user_email = ACCOUNT[:"#{$account_index}"][:valid_account][:email]
        @login_page.login_to_web_app($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
    end
end
    
When /^I try to login 5 times with incorrect password until the account is locked$/ do
    $SSO = false
    @login_page.lock_account(ACCOUNT[:"#{$account_index}"][:account_to_lock][:email], ACCOUNT[:"#{$account_index}"][:account_to_lock][:password])
end

When /^I click "(.*?)" from the Web App Login screen$/ do |button|
    @login_page.click_button (button)
end

When /^I login to Web App with the next user "(.*?)"$/ do |email_or_name|
    $SSO = false
    if email_or_name.include? '@'
        $current_user_email = email_or_name 
    else
        puts "email_or_name:#{email_or_name}"
        user_index = (/\d+/.match email_or_name)[0].to_i
        $current_user_email = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{user_index}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
        puts "#{$current_user_email}"
    end

    @login_page.login_to_web_app($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
end

Then /^I try to login with this account "(.*?)" and expect to "(.*?)"$/ do |email, failure_or_success|
    $SSO = false
    @login_page.login_to_web_app(email, ACCOUNT[:"#{$account_index}"][:valid_account][:password], failure_or_success)
end

Then /^I reset my password with valid email "(.*?)" and invalid email$/ do |email_to_reset|
    @login_page.reset_password(email_to_reset)
end

Then /^I reset my password with valid email$/ do
    @login_page.reset_password(ACCOUNT[:"#{$account_index}"][:valid_account][:email])
end

Then /^I reset my password with valid email using the configuration file and invalid email$/ do
    steps %Q{
        Then I reset my password with valid email "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email]}" and invalid email
    }
end

Then /^I try to login with unvalid format of email and password$/ do
    $SSO = false
    @login_page.login_error_check
end

Then /^I am login to Web App$/ do
    @api_page = Api.new
    puts "current_user_email:#{$current_user_email}"
    
    json_result = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password], true)
    
    # if password is the new password
    if json_result['body']['token'] == nil
        json_result = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:reset_password_email][:new_password], true)
    end

    $COMPANY_FEATURE_LIST = json_result['body']['user']['features_list']   
    $USER_FEATURE_LIST = Hash.new

    for i in 0..($COMPANY_FEATURE_LIST.size - 1) 
        feature_name = $COMPANY_FEATURE_LIST[i]['name']
        feature_name_value = $COMPANY_FEATURE_LIST[i]['value']
        $USER_FEATURE_LIST["#{feature_name}"] = feature_name_value
    end 

    puts "USER_FEATURE_LIST is -------------- #{$USER_FEATURE_LIST}"
    $COMPANY_PACKAGE_ID = json_result['body']['company']['package']['id']
    $ACCOUNT_TYPE = json_result['body']['user']['account_type']

    puts "account type = #{$ACCOUNT_TYPE}"

    if $IS_FIRST_USER_LOGIN || !(@browser.div(:text, HERMES_STRINGS["components"]["main_menu"]["company"]["title"]).present?)
        $IS_FIRST_USER_LOGIN = false
        
        if $ACCOUNT_TYPE == 'shared' 
            @browser.div(:id, 'skip-button').wait_until_present
        else
            @browser.div(:class, 'item-navbar-dropdown').wait_until_present
        end
        
        if @browser.a(:class, %w(modal__btn-close ng-scope)).exists?
            @browser.a(:class, %w(modal__btn-close ng-scope)).click
            @browser.a(:class, %w(modal__btn-close ng-scope)).wait_while_present
        end

        if $SSO
            file_service = FileService.new
            $current_user_name = "#{json_result['body']['user']['last_name']} #{json_result['body']['user']['first_name']}"
            $current_user_company_id = file_service.get_from_file('latest_sso_company_id:')[0..-2]
            $current_user_id = file_service.get_from_file('latest_sso_new_user_id:')[0..-2]
        else
            $current_user_name = "#{json_result['body']['user']['last_name']} #{json_result['body']['user']['first_name']}"
            $current_user_company_id = json_result['body']['company']['company_id']
            $current_user_id = json_result['body']['user']['user_id']    
        end

        file_service = FileService.new
        file_service.insert_to_file("current_user_id:", $current_user_id)
        file_service.insert_to_file("current_user_company_id:", $current_user_company_id)

        # On login, if user account is 'Shared', then there is a check to make sure the Perks & Work Menus are not present
        if $ACCOUNT_TYPE == 'shared'
            steps %Q{
                Given I am on the Limited Account screen
                And I skip the Limited Account page
            }
        end
    end

    if $USER_FEATURE_LIST['social_feed']
        steps %Q{
            Then I am on the News Feed screen
        }
        puts "landed on newsfeed page"
    elsif $USER_FEATURE_LIST['eap_assistance']
        steps %Q{
            Then I am on the "Employee Assitance" screen
        }
        puts "landed on employee assistance page"
    else 
        steps %Q{
            Then I am on the Shop Online screen
        }
        puts "landed on shop online page"
    end
end

Then /^I login to the Web App with the latest new "(.*?)" account$/ do |user|
    $SSO = false
    file_service = FileService.new
    signed_in = false

    if user == 'user'
        counter = file_service.get_from_file("invite_email_counter:")[0..-2]
        $current_user_email = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_subdomain]}" + '+' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:country_code]}" + "#{counter}" + '@' + "#{ACCOUNT[:"#{$account_index}"][:valid_account][:email_domain]}"
    elsif user == 'admin'
        email_address = file_service.get_from_file('new_admin_email:')[0..-2]
        $current_user_email = email_address
    elsif user == 'shared'
        if file_service.get_from_file('shared_account_user_name:')[0..-2] == ''
            steps %Q{
                Given I "add" the new shared account user in Arch
                When I logout from Arch  
                Then I am on the Web App Login screen
            }
        end

        $current_user_email = file_service.get_from_file('shared_account_user_name:')[0..-2]
    elsif user == 'limited'
        if file_service.get_from_file('limited_account_user_name:')[0..-2] != ''
            $current_user_email = file_service.get_from_file('limited_account_user_name:')[0..-2]
        else 
            steps %Q{
                Given I login to the Web App with the latest new "shared" account
                And I click "Help" from the "Global Action" menu
                And I am on the Limited Account screen
                When I click "Create your account" from the Limited Account Screen
                Then I sign up to the Web App using "Limited Account" with a "matching" company email domain
            }
            
            $current_user_email = file_service.get_from_file('limited_account_user_name:')[0..-2]

            steps %Q{
                Then I am login to Web App
            }

            @login_page.close_walkthrough_popup
            signed_in = true
        end
    elsif user == 'dependant'
        if file_service.get_from_file('dependant_account_user_name:')[0..-2] != ''
            $current_user_email = file_service.get_from_file('dependant_account_user_name:')[0..-2]
        else
            steps %Q{ 
                Given I am on the Web App Login screen
                And I insert valid email and password
                And I am login to Web App
                And I click "Profile" from the "Global Action" menu
                And I am on Web App User Profile screen
                And I click "Family" from User Profile screen
                And I remove "all" family members from the company
                And I click "Invite family members" from User Profile screen
                When I invite "1" new family members to the company
                Then I click "Logout" from the "Global Action" menu

                Given I am on the Web App Login screen
                When I click "Signup" from the Web App Login screen
                Then I sign up to the Web App using "Dependant Code" with a "matching" company email domain

            }
            signed_in = true
        end
    elsif user == 'upgraded personal'
        if file_service.get_from_file('upgraded_personal_account_username:')[0..-2] != ''
            email_address = file_service.get_from_file('upgraded_personal_account_username:')[0..-2]
            $current_user_email = email_address
            $ACCOUNT_TYPE = 'personal'
        else 
            if file_service.get_from_file('limited_account_user_name:')[0..-2] == ''
                steps %Q{
                    Given I login to the Web App with the latest new "limited" account
                    Then I click "Logout" from the "Global Action" menu
                }
            end

            steps %Q{
                Given I upgrade the latest Limited account user to Personal 
                When I am on the Web App Login screen
                Then I login to the Web App with the latest new "upgraded personal" account
            }

            @login_page.close_walkthrough_popup
            signed_in = true
        end
    end
    
    if !signed_in
        @login_page.login_to_web_app($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
        
        steps %Q{
            Then I am login to Web App
        }
    end
end

And /^I back to the Web App Login screen$/ do
    @login_page.is_visible ('login')
end

And /^I reset Web App password to "(.*?)"$/ do |change_password_to|
    puts "EMAIL LINK #{$returned_value_from_email}"
    @login_page.insert_new_password($returned_value_from_email, change_password_to)
end

And /^I login to LifeWorks with this new Capita Company$/ do
    $SSO = true

    file_service = FileService.new
    company_subdommain = file_service.get_from_file('latest_sso_company_subdomain:')[0..-2]
    if ENV_LOWCASE == 'integration' || ENV_LOWCASE == 'staging' 
        $HERMES = 'https://' + "#{URL[:"#{ENV['ENV']}"][:password]}" + '@' +"#{company_subdommain}" + '.' + "#{URL[:"#{ENV['ENV']}"][:hermes]}"
    else
        $HERMES = 'http://' + "#{URL[:"#{ENV['ENV']}"][:password]}" + '@' +"#{company_subdommain}" + '.' + "#{URL[:"#{ENV['ENV']}"][:hermes]}"
    end
    puts "$HERMES:#{$HERMES}"
    @login_page = HermesLoginPage.new @browser
    @login_page.is_visible('login')
    @login_page.click_button('Login with Orbit')

    if ENV_LOWCASE == 'integration' || ENV_LOWCASE == 'staging' 
        @login_page.login_to_capita('test6 workangel','P@55w0rd')
    else
        uuid = file_service.get_from_file('latest_sso_new_user_uuid:')[0..-2]
        @login_page.login_to_capita(nil, nil, uuid)
    end
end

And /^I login to LifeWorks with the latest Capita user$/ do
    $SSO = true

    file_service = FileService.new
    company_subdommain = file_service.get_from_file('latest_sso_company_subdomain:')[0..-2]
    if ENV_LOWCASE == 'integration' || ENV_LOWCASE == 'staging'
        $HERMES = 'https://' + "#{URL[:"#{ENV['ENV']}"][:password]}" + '@' +"#{company_subdommain}" + '.' + "#{URL[:"#{ENV['ENV']}"][:hermes]}"
    else
        $HERMES = 'http://' + "#{URL[:"#{ENV['ENV']}"][:password]}" + '@' +"#{company_subdommain}" + '.' + "#{URL[:"#{ENV['ENV']}"][:hermes]}"
    end

    @login_page = HermesLoginPage.new @browser
    @login_page.is_visible('login')
    @login_page.click_button('Login with Orbit')

    if ENV_LOWCASE == 'integration' || ENV_LOWCASE == 'staging' 
        @login_page.login_to_capita(CAPITA[:"#{user_index}"][:capita_user_name] ,CAPITA[:"#{user_index}"][:capita_user_password])
    else
        uuid = file_service.get_from_file('latest_sso_new_user_uuid:')[0..-2]
        @login_page.login_to_capita(nil, nil, uuid, false)
    end

    $current_user_id = file_service.get_from_file('latest_sso_new_user_id:')[0..-2]
    $current_user_company_id = file_service.get_from_file('latest_sso_company_id:')[0..-2]
    $current_user_name = file_service.get_from_file('latest_sso_new_user_name:')[0..-2]
end

And /^I log into the Web App as a valid "(.*?)" user$/ do |user_type|

    if (user_type == 'shared') || (user_type == 'limited') || (user_type == 'upgraded personal') 
        steps %Q{
            Given I login to the Web App with the latest new "#{user_type}" account  
        }
    elsif user_type == 'personal'
        steps %Q{
            Given I insert valid email and password
            When I am login to Web App
            Then I am on the News Feed screen
        }
    end
end

And /^I validate that I can not log in as with the latest deleted user$/ do
    @login_page.login_to_web_app($LATEST_DELETED_USER, ACCOUNT[:"#{$account_index}"][:valid_account][:password], 'failure')
end
