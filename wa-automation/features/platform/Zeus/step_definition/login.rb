# -*- encoding : utf-8 -*-
Given /^I am on the Admin Panel Login screen$/ do
    if !(@browser.a(:href, '/dashboard').present?)
        @api_page = Api.new
        @login_page = ZeusLoginPage.new @browser
        @login_page.is_visible('login')
    end
end

When /^I login with the new "(.*?)" company account$/ do |distributor|
    $distributor = distributor

    steps %Q{
        When I login with the new company account
    }
end

When /^I login with the new company account$/ do
    file_service = FileService.new
    new_admin_user_email = file_service.get_from_file('new_admin_email:')[0..-2]

    if !(@browser.a(:href, '/dashboard').present?)
        @login_page.login(new_admin_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
        admin_token_response = @api_page.get_admin_token(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password], true)
        $COMPANY_FEATURE_LIST = admin_token_response['body']['company']['features_list']
        $ADMIN_FEATURE_LIST = Hash.new

        for i in 0..($COMPANY_FEATURE_LIST.size - 1) 
            feature_name = $COMPANY_FEATURE_LIST[i]['name']
            feature_name_value = $COMPANY_FEATURE_LIST[i]['value']
            $ADMIN_FEATURE_LIST["#{feature_name}"] = feature_name_value
        end

        puts "ADMIN_FEATURE_LIST: #{$ADMIN_FEATURE_LIST}"
        $COMPANY_CREATION_DATE = admin_token_response['body']['company']['created_on']
    end
end

When /^I insert valid email and password from the Admin Panel screen$/ do
    if !(@browser.a(:href, '/dashboard').present?)
        @login_page.login(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password])
        admin_token_response = @api_page.get_admin_token(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password], true)

        $COMPANY_FEATURE_LIST = admin_token_response['body']['company']['features_list']
        $ADMIN_FEATURE_LIST = Hash.new

        for i in 0..($COMPANY_FEATURE_LIST.size - 1) 
            feature_name = $COMPANY_FEATURE_LIST[i]['name']
            feature_name_value = $COMPANY_FEATURE_LIST[i]['value']
            $ADMIN_FEATURE_LIST["#{feature_name}"] = feature_name_value
        end

        puts "ADMIN_FEATURE_LIST: #{$ADMIN_FEATURE_LIST}"

        $COMPANY_CREATION_DATE = admin_token_response['body']['company']['created_on']
    end
end

When /^I try to login with "(.*?)"$/ do |user_email|
     @login_page.login(user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
end
    
When /^I try to login 5 times to Admin panel with incorrect password until the account is locked$/ do
    @login_page.lock_account(ACCOUNT[:"#{$account_index}"][:account_to_lock][:email], ACCOUNT[:"#{$account_index}"][:account_to_lock][:unvalid_password])
end

Then /^I cant login$/ do
    @browser.span(:text ,/Your e-mail or password is incorrect./).wait_until_present
end

Then /^I verify that a non admin user cannot login into Admin Panel$/ do
    @browser.p(:text, ZEUS_STRINGS["api_errors"]["wrong_platform"]).wait_until_present
end

Then /^I reset my password with valid and invalid email$/ do
    @login_page.reset_password
end

Then /^I try to login with unvalid format of email and password to Admin Panel$/ do
    @login_page.login_error_check
end

And /^I login after 11 minutes$/ do
    sleep(660) # wait for 11 min
    @login_page.login(ACCOUNT[:"#{$account_index}"][:account_to_lock][:email], ACCOUNT[:"#{$account_index}"][:account_to_lock][:password])
end

And /^I reset password to "(.*?)"$/ do |change_password_to|
    @login_page.insert_new_password($returned_value_from_email, change_password_to)
end

And /^I login to Admin Panel using the "(.*?)"$/ do |password|
    @login_page.login(ACCOUNT[:"#{$account_index}"][:reset_password_email][:email], ACCOUNT[:"#{$account_index}"][:reset_password_email][:"#{password}"])
end

# Call by user profile feature
Then /^I try to login with the deactivate account and I expect to "(.*?)"$/ do |result|
    steps %Q{
        Given I am on the Web App Login screen
        When I try to login with this account "#{ACCOUNT[:"#{$account_index}"][:user_email_to_delete]}" and expect to "#{result}"
    }
    @browser.goto $ZEUS
end

Then /^I try to login to the admin panel when the company account is deactivated$/ do
    @login_page = ZeusLoginPage.new @browser
    
    @login_page.is_visible('login')
    @login_page.login(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password])
    @browser.span(:text, ZEUS_STRINGS["login"]["not_activated"]).wait_until_present
end
