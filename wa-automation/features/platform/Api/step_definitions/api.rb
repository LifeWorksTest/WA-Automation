# -*- encoding : utf-8 -*-
Given /^I create a new company using the API$/ do

  @api_page = Api.new

  json_result = @api_page.create_company
  puts "json_result:#{json_result}"
  company_id = json_result['body']['company_id']
  package_id = json_result['body']['package']['id']
  company_invetation_code = json_result['body']['invitation_code']
  
  # set company state to Active
  @api_page.update_company(company_id, 1)

  # enable all company's feature keys
  @api_page.set_all_company_features(company_id, package_id, true)

  locale = ACCOUNT[:account_1][:valid_account][:password]
  password = ACCOUNT[:account_1][:valid_account][:password]
  
  for i in 1..3 do
    email = ACCOUNT[:account_1][:valid_account][:email_subdomain] + '+' +
          ACCOUNT[:account_1][:valid_account][:user_creation_country_code] + 
          "#{i}" + '@' + ACCOUNT[:account_1][:valid_account][:email_domain]

    @api_page.create_user('user' + "#{i}", 'user' + "#{i}", email, password, 'user', locale, company_invetation_code)
  end

  admin_token_response = @api_page.get_admin_token(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password])
  @api_page.approve_users(admin_token_response)
end