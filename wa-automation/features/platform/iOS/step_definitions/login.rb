# -*- encoding : utf-8 -*-
Given /^I am on the iOS Login screen$/ do
	@login_page = page(IOSLoginPage).await
	puts "$account_index:#{$account_index}"

end

Given /^I login to LifeWorks from the iOS app$/ do
	steps %Q{
			Given I am on the iOS Get Started screen
	    Then I click from the iOS Get Started screen "Log in"

	    Given I am on the iOS Login screen
	    When I insert valid credential
	    Then I see the iOS Menu Tab
	}
end

When /^I insert valid email$/ do
	@login_page.insert_email_for_login(ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email])
	@login_page.click_button('Continue')
end

When /^I try to login with invalid password$/ do
	@login_page.login_to_wam(ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email], '123qweasdggh')
end

When /^I try to login with invalid email format$/ do
	@login_page.login_to_wam('1.com', ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])
end

Then /^I insert "(.*?)" email$/ do |is_valid_email|
	@login_page.insert_email_for_reset_password(is_valid_email)
end

Then /^I change to valid password$/ do
	@login_page.login_to_wam(nil, ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])
end

Then /^I insert valid credential$/ do
	puts "$account_index:#{$account_index}"
	@file_service = FileService.new
	$current_user_email = ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email]
	@login_page.login_to_wam($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])

	@api_page = Api.new
    json_result = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password], true)

    # if password is the new password
    if json_result['body']['token'] == nil
        json_result = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:reset_password_email][:new_password], true)
    end

	$current_user_name = "#{json_result['body']['user']['last_name']} #{json_result['body']['user']['first_name']}"
    $current_user_company_id = json_result['body']['company']['company_id']
    $current_user_id = json_result['body']['user']['user_id']
    @file_service.insert_to_file('current_user_name:', $current_user_name)
    @file_service.insert_to_file('current_user_company_id:', $current_user_company_id)
    @file_service.insert_to_file('current_user_id:', $current_user_id)
    @file_service.insert_to_file('current_user_email:', $current_user_email)
end

Then /^I insert details of user that was deactivated$/ do
	@login_page.login_to_wam(USER_TO_DEACTIVATE[:email], USER_TO_DEACTIVATE[:password])
end

Then /^I insert details of user deactivated company$/ do
	@login_page.login_to_wam(ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email], ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])
end

Then /^I insert details of unavailable network$/ do
	# @login_page.login_to_wam(USERS[:unavailable_network][:email], USERS[:unavailable_network][:password])
end

Then /^I am still on the Get Started screen$/ do
	@login_page.await
end

And /^I click from the iOS Login screen "(.*?)"$/ do |button|
	@login_page.click_button(button)
end

And /^I am back again to Login screen$/ do
	@login_page.await
end
