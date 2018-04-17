# -*- encoding : utf-8 -*-
Given /^I am on the Android Login screen$/ do
	@login_page = page(AndroidLoginPage).await
end

Given /^I login to LifeWorks from the Android app$/ do
	steps %Q{
		Given I am on the Android Get Started screen
    Then I click from the Android Get Started screen "Login"

    Given I am on the Android Login screen
    When I insert valid email and password from the Android app
    Then I am on the Android Menu screen
	}
end

When /^I insert invalid password from the Android app$/ do
	$current_user_email = ACCOUNT[:"#{$account_index}"][:valid_account][:email]
	@login_page.login_to_wam(ACCOUNT[:"#{$account_index}"][:valid_account][:email], '11111ddasdq')
end

When /^I try to login with invalid email format from the Android app$/ do
	@login_page.login_to_wam('1.com', ACCOUNT[:"#{$account_index}"][:valid_account][:password])
end

Then /^I insert "(.*?)" email from the Android app$/ do |is_valid_email|
	@login_page.insert_email(is_valid_email)
end

Then /^I change to valid password from the Android app$/ do
	@login_page.login_to_wam(nil, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
end

Then /^I insert valid email and password from the Android app$/ do
	$current_user_email = ACCOUNT[:"#{$account_index}"][:valid_account][:email]
	@login_page.login_to_wam(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password])

	@api_page = Api.new
    json_result = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password], true)

    # if password is the new password
    if json_result['body']['token'] == nil
        json_result = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:reset_password_email][:new_password], true)
    end

	$current_user_name = "#{json_result['body']['user']['last_name']} #{json_result['body']['user']['first_name']}"
    $current_user_company_id = json_result['body']['company']['company_id']
    $current_user_id = json_result['body']['user']['user_id']

    @file_service = FileService.new
    @file_service.insert_to_file('current_user_name:', $current_user_name)
    @file_service.insert_to_file('current_user_company_id:', $current_user_company_id)
    @file_service.insert_to_file('current_user_id:', $current_user_id)
    @file_service.insert_to_file('current_user_email:', $current_user_email)
end

Then /^I insert details of user that was deactivated$/ do
	@login_page.login_to_wam(USERS[:deactivated_account][:email], USERS[:deactivated_account][:password])
end

Then /^I insert details of user deactivated company$/ do
	@login_page.login_to_wam(USERS[:deactivated_company][:email], USERS[:deactivated_company][:password])
end

Then /^I insert details of unavailable network$/ do
	@login_page.login_to_wam(USERS[:unavailable_network][:email], USERS[:unavailable_network][:password])
end

Then /^I am still on the Get Started screen$/ do
	@login_page.await
end

And /^I click from the Android Login screen "(.*?)"$/ do |button|
	@login_page.click_button(button)
end

And /^I am back again to Login screen$/ do
	@login_page.await
end

And /^I reset password with "(.*?)" email$/ do |is_valid_email|
	@login_page.reset_password(is_valid_email)
end

And /^I log into the Android App as a valid "(.*?)" user$/ do |user_type|

    if (user_type == 'shared') || (user_type == 'limited') || (user_type == 'upgraded personal') 
        steps %Q{
            Given I login to the Android App with the latest new "#{user_type}" account  
        }
    elsif user_type == 'personal'
        steps %Q{
            Given I insert valid email and password from the Android app
            When I am login to Android App
            Then I am on the Android Menu screen
        }
    end
end

Then /^I login to the Android App with the latest new "(.*?)" account$/ do |user|
    $SSO = false
    file_service = FileService.new
    signed_in = false
    if user == 'shared'
        if file_service.get_from_file('shared_account_user_name:')[0..-2] == ''
            steps %Q{
                Given I am on the Web App Login screen
                Given I "add" the new shared account user in Arch
                When I logout from Arch  
            }
		end
		$current_user_email = file_service.get_from_file('shared_account_user_name:')[0..-2]
	end
    if !signed_in
        steps %Q{
            Given I am on the Android Get Started screen
            Then I click from the Android Get Started screen "Login"
            Then I am on the Android Login screen
        }
        @login_page.login_to_wam($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
        steps %Q{
            Then I am on the Android Menu screen
        }
    end
end