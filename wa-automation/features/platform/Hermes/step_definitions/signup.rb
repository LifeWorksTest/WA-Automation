
Given /^I sign up to the Web App using "(.*?)" with a "(.*?)" company email domain$/ do |code_to_use, email_matches_company_doman|
    @signup_page = HermesSignupPage.new @browser
    
    if code_to_use == 'Personal Code'
        steps %Q{
            And I recived an email with the subject "join"
        }
        puts "RETURNED_VALUE_FROM_EMAIL #{$returned_value_from_email}"
        @signup_page.signup($returned_value_from_email)

        steps %Q{
            And I recived an email with the subject "welcome_to_lifeworks"
            And I recived an email with the subject "has_joined_lifeworks"
        }
        # And I recived an email with the subject "has_joined_workangel"
    elsif code_to_use == 'Dependant Code'
        steps %Q{
            And I recived an email with the subject "has_invited_you_to_join"
        }
        
        @signup_page.signup('Dependant Code')

        steps %Q{
            Given I am login to Web App
        }
    
        # @login_page.close_walkthrough_popup

    elsif code_to_use == 'Company Code'
        
        if email_matches_company_doman == 'matching'
            $email_domain = 'email_domain'
        else
            $email_domain = 'non_matching_email_domain'
        end

        @signup_page.signup(code_to_use)
    elsif code_to_use == 'Limited Account'
        @signup_page.signup(nil,nil,true)

        # steps %Q{
        #     Given I recived an email with the subject "activate_your_lifeWorks_account"
        # }
    end
end

Given /^I sign up "(.*?)" new users$/ do |number_of_new_users|
    $email_domain = 'email_domain'
    
    for i in 1..number_of_new_users.to_i
        steps %Q{
            Given I am on the Web App Login screen
            When I click "Signup" from the Web App Login screen
        }
        @signup_page = HermesSignupPage.new @browser
        @signup_page.signup('Company Code')
    end
end

Given /^I create a new limited account user and login to the Web App$/ do
    file_service = FileService.new
    file_service.insert_to_file('limited_account_user_name:', '')
    file_service.insert_to_file('limited_account_name:', '')

    steps %Q{
        Given I am on the Web App Login screen
        Then I login to the Web App with the latest new "limited" account
    }
end

Given /^I create a new dependant account user and login to the Web App$/ do
    file_service = FileService.new
    file_service.insert_to_file('dependant_account_user_name:', '')
    
    steps %Q{
        Given I am on the Web App Login screen
        Then I login to the Web App with the latest new "dependant" account
    }
end

Given /^I sign up users to LifeWorks using csv file$/ do
    @path = File.join(File.dirname(__FILE__),'/', 'csv')
    @aFile = File.new("#{@path}", "r")
    File.readlines(@aFile).each do |line|
        steps %Q{
            Given I am on the Web App Login screen
            When I click "Signup" from the Web App Login screen
        }
        puts "current user #{line}"
        new_user_data_array = line.split(",")
        @signup_page = HermesSignupPage.new @browser
        @signup_page.signup('Company Code', new_user_data_array)
    end
    @aFile.close
end


Given /^I create new Capita Company$/ do
    require 'securerandom'

    @api_page = Api.new
    sso_result = @api_page.get_id_and_secret_from_sso_server
    id = (/id .*,/.match sso_result).to_s[3..-2]
    secret = (/secret .*/.match sso_result).to_s[7..-1]

    if ENV_LOWCASE == 'integration' || ENV_LOWCASE == 'staging'
        url = "https://api.sso.#{ENV_LOWCASE}.workangel.com/oauth/v2/token?client_id=#{id}&client_secret=#{secret}&grant_type=client_credentials"
    else
        url = "http://api.sso.#{ENV_LOWCASE}.workivate.com/oauth/v2/token?client_id=#{id}&client_secret=#{secret}&grant_type=client_credentials"
    end

    @token = @api_page.request_from_sso_server('Get', url, nil, nil, 'access_token')

    if ENV_LOWCASE == 'integration' || ENV_LOWCASE == 'staging'
        url = "https://api.sso.#{ENV_LOWCASE}.workangel.com/v1.0/companies"
    else
        url = "http://api.sso.#{ENV_LOWCASE}.workivate.com/v1.0/companies"
    end

    @file_service = FileService.new

    # counter is use to create a different email address
    @COUNTER_INDEX = @file_service.get_from_file("invite_email_counter:")
    @file_service.insert_to_file("invite_email_counter:", @COUNTER_INDEX)

    $current_user_company_name = "capitacompany#{@COUNTER_INDEX}"
    @file_service.insert_to_file('latest_sso_company_subdomain:', $current_user_company_name)

    @current_company_uuid = SecureRandom.uuid

    parameters = {
        "company_uuid" => @current_company_uuid,
        "name" => $current_user_company_name,
        "nickname" => $current_user_company_name,
        "country_code" => "GB",
        "wa_subdomain" => $current_user_company_name,
        "locale" => "en_GB",
        "domain" => "companya.com",
        "started_on" => 1422291038
    }

    json_result = @api_page.request_from_sso_server('Post', url, @token, parameters, nil)
    puts "#{json_result}"
    $current_user_company_id = "#{json_result['body']['company_id']}"
    @file_service.insert_to_file('latest_sso_company_id:', $current_user_company_id)
    puts "$current_user_company_id:#{$current_user_company_id}"
end

And /^I add a new Capita user index "(.*?)" to this Capita new company$/ do |user_index|
    user_index = user_index.to_i
    $current_user_uuid = CAPITA[:"user#{user_index}"][:capita_user_uuid]

    @api_page.create_sso_user($current_user_uuid, "#{CAPITA[:"user#{user_index}"][:user_name]}", "#{CAPITA[:"user#{user_index}"][:user_name]}", "#{CAPITA[:"user#{user_index}"][:capita_user_email]}", @current_company_uuid, @token)
    @file_service.insert_to_file('latest_sso_new_user_uuid:', $current_user_uuid)
    @file_service.insert_to_file('latest_sso_new_user_name:', "#{CAPITA[:"user#{user_index}"][:user_name]} #{CAPITA[:"user#{user_index}"][:user_name]}")
    @file_service.insert_to_file('latest_capita_user_name:', "#{CAPITA[:"user#{user_index}"][:capita_user_name]}")
    @file_service.insert_to_file('latest_capita_user_name:', "#{CAPITA[:"user#{user_index}"][:capita_user_email]}")
end

And /^I delete the new Capita user$/ do
    @api_page.delete_user($current_user_uuid, $current_user_company_id, @token)
end
