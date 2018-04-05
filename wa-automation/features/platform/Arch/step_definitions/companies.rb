# -*- encoding : utf-8 -*-
Given /^I am on Companies screen$/ do
    @companies_page = ArchCompaniesPage.new @browser_arch
    @companies_page.is_visible('companies')
end

Given /^I "(.*?)" wellness tools and limit the number or interests to "(.*?)" and sessions to "(.*?)" from Arch$/ do |enable_disable, max_interests, max_sessions|
    @companies_page = ArchCompaniesPage.new @browser
    row = 'EAP & Wellness (eap)'
    
    steps %Q{
        Given I am on Arch Login screen
        And I login to Arch
        And I click on "Companies" from Left menu
        And I am on Companies screen
        When I open the current user company
    }
        
    @companies_page.disabled_enabled_company_features(row, 'Snackable Wellbeing (eap_wellness)', enable_disable)
    @companies_page.disabled_enabled_company_features(row, 'User wellness interest category limit selection (eap_wellness_category_limit)', enable_disable, max_interests)
    @companies_page.disabled_enabled_company_features(row, 'User wellness maximum sessions per day limitation (eap_wellness_content_consumption_limit)', enable_disable, max_sessions)
    
    @companies_page.click_button('Save')

    steps %Q{
        And I logout from Arch  
    }
end

Given /^I set the Gift Card Discount Tier to "(.*?)" for my current company in Arch$/ do |discount_tier|
    steps %Q{
        Given I am on Arch Login screen
        And I login to Arch
        And I click on "Companies" from Left menu
        And I am on Companies screen
        When I open the current user company
    }

    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Global Gift Cards (benefit_global_gift_cards)', 'true', "Discount Tier #{discount_tier}")
    
    @companies_page.click_button('Save')
   
    steps %Q{
        And I logout from Arch  
    }

end

Given /^I "(.*?)" "(.*?)" features in Arch$/ do |enable_disable, features_to_enable_disable|
	@companies_page = ArchCompaniesPage.new @browser
	enable_disable == 'enable' ? enable_disable = 'true' : enable_disable = 'false'
    feature_array = features_to_enable_disable.split(', ')

    if ( feature_array.include? 'perks' ) || ( feature_array.include? 'all' )
    	if eval(enable_disable)
    		@companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Discounts (benefit)', enable_disable)
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Shop online (benefit_online_shop)', enable_disable)
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Global Gift Cards (benefit_global_gift_cards)', enable_disable, 'Discount Tier 2')
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Restaurant (benefit_restaurant)', enable_disable)
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Hilife Dining Card (benefit_restaurant_hilife)', enable_disable)
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Cinema (benefit_cinema)', enable_disable)
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Price Points (benefit_cinema_pricing_tier)', enable_disable, 'Price Tier 2')
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Colleague Offers (benefit_colleague_offer)', enable_disable)  
		    @companies_page.disabled_enabled_company_features('Discounts (benefit)', 'In-Store Offers (benefit_in_store_offer)', enable_disable)
 		else
 			@companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Discounts (benefit)', enable_disable)
 		end
 	end

 	if ( feature_array.include? 'news feed' ) || (feature_array.include? 'all' )
		@companies_page.disabled_enabled_company_features('News feed (social_feed)', 'News feed (social_feed)', enable_disable)
	end

	if ( feature_array.include? 'social' ) || ( feature_array.include? 'all' )
		if eval(enable_disable)
			@companies_page.disabled_enabled_company_features('Social (social)', 'Social (social)', enable_disable)
			@companies_page.disabled_enabled_company_features('Social (social)', 'Colleague Directory (social_colleague_directory)', enable_disable)
			@companies_page.disabled_enabled_company_features('Social (social)', 'Recognition (social_recognition)', enable_disable)
			@companies_page.disabled_enabled_company_features('Social (social)', 'Recognition Leaderboard (social_recognition_leaderboard)', enable_disable)
		else
			@companies_page.disabled_enabled_company_features('Social (social)', 'Social (social)', enable_disable)
		end
	end

	if ( feature_array.include? 'life' ) || ( feature_array.include? 'all' )
		@companies_page.disabled_enabled_company_features('EAP & Wellness (eap)', 'EAP & Wellness (eap)', enable_disable)
	end

	if ( feature_array.include? 'all' )
		if eval(enable_disable)
			@companies_page.disabled_enabled_company_features('Wallet (wallet)', 'Wallet (wallet)', enable_disable)
			@companies_page.disabled_enabled_company_features('Wallet (wallet)', 'Wallet withdraw PayPal method (wallet_withdraw_method_paypal)', enable_disable)
			@companies_page.disabled_enabled_company_features('Admin Panel', 'Admin Posting (ap_feed_post)', enable_disable)
			@companies_page.disabled_enabled_company_features('Admin Panel', 'Admin Social Analytics (ap_dashboard_social)', enable_disable)
			@companies_page.disabled_enabled_company_features('Admin Panel', 'Admin Discount Analytics (ap_dashboard_benefits)', enable_disable)
			@companies_page.disabled_enabled_company_features('Admin Panel', 'Admin User Upload (ap_user_upload)', enable_disable)
			@companies_page.disabled_enabled_company_features('Spot Rewards (spot_rewarding)', 'Spot Rewards (spot_rewarding)', enable_disable)
			@companies_page.disabled_enabled_company_features('Admin Accounting (ap_accounting)', 'Admin Accounting (ap_accounting)', enable_disable)
		else
			@companies_page.disabled_enabled_company_features('Wallet (wallet)', 'Wallet (wallet)', enable_disable)
		end
	end

    @companies_page.click_button('Save')
end  

Given /^the Arch user "(.*?)" Grouping feature key and set it to be managed by "(.*?)"$/ do |state, managed_by|
	steps %Q{
		Given I am on Arch Login screen
		When I login to Arch
		Then I click on "Companies" from Left menu
		
		Given I am on Companies screen
		When I open the current user company
		Then I click "Features" from Companies screen
		And I "#{state}" Grouping feature key and I set it to be managed by "#{managed_by}"
		And I logout from Arch
	}
end

Given /^I "(.*?)" Grouping feature key and I set it to be managed by "(.*?)"$/ do |state, managed_by|
	@companies_page.set_grouping_feature_key(state, managed_by)
end

Given /^I set the dependant account invite limit for the "(.*?)" to "(.*?)" in Arch$/ do |company, invite_limit|
	if company == 'new company'
		company = "#{USER_PROFILE[:new_admin_user][:company_name]}" + " " + "#{@current_index}"
	elsif company == 'current company'
		company = ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]
	end

	steps %Q{
	    Given I am on Arch Login screen
	    When I login to Arch
	    Then I click on "Companies" from Left menu

	    Given I am on Companies screen
	    When I open company "#{company}"
	    Then I click "Details" from Companies screen
	    And I set the dependant account invite limit to "#{invite_limit}"
	    And I logout from Arch 
	}	
end

When /^the Arch user "(.*?)" "(.*?)" pounds as reward to this company$/ do |action, amount|
	steps %Q{
		Given I am on Arch Login screen
		When I login to Arch
		Then I click on "Companies" from Left menu
		Given I am on Companies screen
		When I open the current user company
		Then I click "Spot Rewarding" from Companies screen
		And I "#{action}" "#{amount}" pounds as reward to this company
		And I logout from Arch
	}
end

When /^I open company "(.*?)"$/ do |company_name|
	if company_name == 'latest_created_company'
		file_service = FileService.new
		company_index = file_service.get_from_file('admin_account_counter:')[0..-2]
		company_name = "#{USER_PROFILE[:new_admin_user][:company_name]}" + " " + "#{company_index}"
	end

	@companies_page.search_for_company(company_name)
	@companies_page.open_company_from_table(nil, company_name)
end

When /^I open the current user company$/ do
	company_name = ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]
	@companies_page.search_for_company(company_name)
	
	@companies_page.open_company_from_table(nil, company_name)
	
	@companies_page.validate_company_data
end

When /^the Arch user change the new company state to Active$/ do
	steps %Q{
		Given I am on Arch Login screen
		When I login to Arch
		Then I click on "Companies" from Left menu

		Given I am on Companies screen
		When I open company "#{$current_user_company_name}"
		And the Arch user change the company state to "Active"
	}

	if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "welcome_to_lifeworks_for"
            Then I recived an email with the subject "welcome_to_lifeworks"
        }
    end
end

When /^I set the dependant account invite limit to "(.*?)"$/ do |invite_limit|
	@companies_page.set_dependant_account_invite_limit(invite_limit)
end

Then /^I validate that the new user can login to admin panel and web app$/ do
	@browser_arch.goto  "#{URL[:hermes]}".gsub! '[company_wa_subdomain]' , "#{URL[:password]}" + "@" + "#{USER_PROFILE[:new_admin_user][:wa_subdomain]}" + "#{@current_index}"
	file_service = FileService.new
	new_admin_user_email = file_service.get_from_file('new_admin_email:')[0..-2]
	puts "new_admin_user_email:#{new_admin_user_email}"
	steps %Q{
		Given I am on the Web App Login screen
    	When I login to Web App with the next user "#{new_admin_user_email}"
    	Then I am login to Web App
    	And I validate empty state in the Web App
    	And I validate that all sections are visible in the Web App
    	And I click "Logout" from the "Global Action" menu
    	Given I am on the Admin Panel Login screen
		When I try to login with "#{new_admin_user_email}"
		Then I am login to Admin Panel
		And I logout from Admin Panel
	}
end

Then /^I add "(.*?)" new users using "(.*?)" csv upload$/ do |number_of_users, email_or_id| 
  @companies_page.click_button('Upload')
  @companies_page.add_users_by_csv_upload(number_of_users.to_i, email_or_id)
end

Then /^I remove "(.*?)" new users using "(.*?)" csv upload$/ do |number_of_users, email_or_id| 
  @companies_page.click_button('Upload')
  @companies_page.remove_users_by_csv_upload(number_of_users.to_i, email_or_id)
end

Then /^I add new badge$/ do
	steps %Q{
		Then I click "Badges" from Companies screen	
	}

	@companies_page.create_new_badge
	@companies_page.validate_new_badge_in_list
end

Then /^I remove the new badge$/ do
	steps %Q{
		Then I click "Badges" from Companies screen	
	}
	@companies_page.delete_new_badge("#{NEW_BADGE[:name]}")
end

Then /^I validate that "(.*?)" is "(.*?)" in the web app$/ do |feature, is_enabled|
	@news_feed_page = HermesNewsFeedPage.new @browser
	steps %Q{
			Given I am on the Web App Login screen
    		When I insert valid email and password
    		Then I am login to Web App
    	}
    if (feature == 'Social Recognition') || (feature == 'Like')
        steps %Q{
            When I click "News Feed" from the Hermes menu top bar
        }
        @news_feed_page.disabled_enabled_features(feature, is_enabled)
    
    elsif feature == 'News feed'
    	@menus_page = HermesMenusPage.new @browser
    	@menus_page.disabled_enabled_features(feature, is_enabled)
    
    elsif feature == 'Colleague Directory'
    	@menus_page = HermesMenusPage.new @browser
    	@menus_page.disabled_enabled_features(feature, is_enabled)
    end
end

Then /^I "(.*?)" "(.*?)" pounds as reward to this company$/ do |operation, amount|
	@companies_page.rewards_budget(operation, amount.to_f)
end

Then /^I match company details with company profile on Admin Panel$/ do
	company_profile = @companies_page.get_company_profile

	steps %Q{
		Given I am on the Admin Panel Login screen
		When I insert valid email and password from the Admin Panel screen
		Then I am login to Admin Panel
		And I click on "Menu" from Top Bar menu
		And I click on "Account" from Top Bar menu
		Given I am on the Account screen
  		Then I get company profile
  	}
  	puts "company_profile.size:#{company_profile.size}"
  	for i in 0..company_profile.size - 1
  		puts "company_profile[#{i}]=#{company_profile[i]} $company_profile_from_admin[#{i}]=#{$company_profile_from_admin[i]}"

  		if company_profile[i] != $company_profile_from_admin[i]
  			if (company_profile[i] != nil) && ($company_profile_from_admin[i] != '-') && i!=2
  				fail(msg = "Error. Company profile is not match, company_profile:#{company_profile[i]} $company_profile_from_admin:#{$company_profile_from_admin[i]}")
  			end
  		end
  	end
end

Then /^I "(.*?)" the "(.*?)" feature key in Arch$/ do |enable_or_disable, feature|
	enable_or_disable == 'enable' ? enable_or_disable = true : enable_or_disable = false
	
	steps %Q{
		Given I am on Arch Login screen
	    When I login to Arch
	    Then I click on "Companies" from Left menu
	    Given I am on Companies screen
	    When I open the current user company
	    Then I set the "#{feature}" feature key to "#{enable_or_disable}"
	    And I logout from Arch
	}
end

Then /^I set the "(.*?)" feature key to "(.*?)"$/ do |feature, state|
	if feature == 'Social Recognition'
		@companies_page.disabled_enabled_company_features('Social (social)', 'Recognition (social_recognition)', state)
	elsif feature == 'News feed (social_feed)'
		@companies_page.disabled_enabled_company_features('News feed (social_feed)','News feed (social_feed)', state)
	elsif feature == 'Colleague Directory'
		@companies_page.disabled_enabled_company_features('Social (social)', 'Colleague Directory (social_colleague_directory)', state)
	elsif feature == 'Hilife Dining Card'
		@companies_page.disabled_enabled_company_features('Discounts (benefit)', 'Hilife Dining Card (benefit_restaurant_hilife)', state)
	elsif feature == 'Like Functionality'
		@companies_page.disabled_enabled_company_features('News feed (social_feed)', 'Like Functionality (feed_actions_excluding_recognition)', state)
	elsif feature == 'Life'
		@companies_page.disabled_enabled_company_features('EAP & Wellness (eap)', 'EAP & Wellness (eap)', state)
	else 
		fail(msg = "Error. Feature is not supported by step definition. Check that the feature name is correct - '#{feature}'")
	end
	
	@companies_page.click_button('Save')
end

Then /^I match company snapshot with company snapshot on Admin Panel$/ do
	steps %Q{
		Given I click "Overview" from Companies screen
	}
	company_snapshot = @companies_page.get_company_snapshot

	steps %Q{
		Given I am on the Admin Panel Login screen
    	When I insert valid email and password from the Admin Panel screen
    	Then I am login to Admin Panel
		Given I am on the Dashboard
		When I click on "View Colleagues" from the "Colleagues" Zeus Top Bar menu
		Then I am on the Employees screen
		And I set Colleague Managment snapshot

  	}

  	for i in 0..company_snapshot.size - 1
  		puts "company_snapshot:#{company_snapshot[i]} $colleague_managment_snapshot:#{$colleague_managment_snapshot[i]}"
  		if company_snapshot[i] != $colleague_managment_snapshot[i]
  			fail(msg = "Error. Company snapshot is not match, company_profile:#{company_snapshot[i]} $colleague_managment_snapshot:#{$colleague_managment_snapshot[i]}")
  		end
  	end
end

Then /^I create new company using "(.*?)"$/ do |payment_mathod|
	@companies_page.click_button('Create Company')
	@current_index = @companies_page.create_company(payment_mathod)
end

Then /^I click "(.*?)" from Companies screen$/ do |button|
	@companies_page.click_button(button)
end

Then /^I select user "(.*?)"$/ do |user_name|
	steps %Q{
		Then I click "Users" from Companies screen
	}

	@companies_page.search_for_user(user_name)
end

Then /^I credit the user "(.*?)" "(.*?)"$/ do |amount, currency_name|
	@companies_page.cerdit_user(amount, currency_name)
end

Given /^I "(.*?)" the new shared account user in Arch$/ do |add_or_delete|
	if !@browser.div(:id, 'sidebar-container').present?
		steps %Q{
	    	Given I am on Arch Login screen
	    	And I login to Arch
	    }
	end
	steps %Q{
	  	When I click on "Companies" from Left menu
	   	And I am on Companies screen
	   	Then I open the current user company
	}
	@companies_page.add_or_delete_shared_account_user(add_or_delete)
end

Then /^I "(.*?)" "(.*?)" cms locales for my company in Arch$/ do |add_or_delete, locales_to_add|
	if !@browser.div(:id, 'sidebar-container').present?
		steps %Q{
    		Given I am on Arch Login screen
    		And I login to Arch
    	}
    end
    steps %Q{	
    	Given I click on "Companies" from Left menu
    	When I am on Companies screen
    	Then I open the current user company
    }
	@companies_page.add_delete_company_locales(add_or_delete,locales_to_add)
end

And /^I validate that the new badge is "(.*?)" in "(.*?)"$/ do |exists_or_not, platfrom|
	if exists_or_not == "exists"
		if platfrom == "Admin Panel"
			steps %Q{
				Given I am on the Admin Panel Login screen
	    		When I insert valid email and password from the Admin Panel screen
		    	Then I am login to Admin Panel
	    		And I click on "Performance" from Top Bar menu
	    		And I click on "Company" from Top Bar menu

	    		Given I am on the Company screen
				When I check if this badge "#{NEW_BADGE[:name]}" with this description "#{NEW_BADGE[:description]}" "#{exists_or_not}"
				Then I logout from Admin Panel
			}
		elsif platfrom == "Web App"
			# steps %Q{    
			#     Given I am on the Web App Login screen
	  #   		When I insert valid email and password
	  #   		Then I am login to Web App

	  #   		Given I am on the News Feed screen
	  #   		When I check that the next badge "#{NEW_BADGE[:name]}" "exists" in the list
	  #   		Then I click "Logout" from the "Global Action" menu
			# # }
		end
	elsif exists_or_not == "not exists"
		if platfrom == "Admin Panel"
			steps %Q{
				Given I am on the Admin Panel Login screen
	    		When I insert valid email and password from the Admin Panel screen
		    	Then I am login to Admin Panel
	    		And I click on "Performance" from Top Bar menu
	    		And I click on "Company" from Top Bar menu

	    		Given I am on the Company screen
				Then I check if this badge "#{NEW_BADGE[:name]}" with this description "#{NEW_BADGE[:description]}" "#{exists_or_not}"
				Then I logout from Admin Panel
			}
		end
	end
end

And /^the Arch user change the company state to "(.*?)"$/ do |state|
	steps %Q{
		Then I click "Details" from Companies screen
	}
	@companies_page.change_company_state(state)
end

And /^I validate that this data is in the first line of the table "(.*?)" "(.*?)" "(.*?)"$/ do |admin_name, user_name, amount|
	@companies_page.validate_transactions(admin_name, user_name, 'Issued', amount)
end


And /^the Arch user validate that this data is in the first line of the historic rewards table after update: "(.*?)" "(.*?)" "(.*?)" "(.*?)" "(.*?)"$/ do |admin_name, user_name, amount, retailer, provider|
	steps %Q{
		Given I am on Arch Login screen
		When I login to Arch
		Then I click on "Companies" from Left menu
		Given I am on Companies screen
		When I open the current user company
		Then I click "Spot Rewarding" from Companies screen
		And I click "Transactions" from Companies screen
	}

	@companies_page.validate_transactions(admin_name, user_name, 'Claimed', amount, retailer, provider)
	
	steps %Q{
		And I logout from Arch
	}
end

And /^the Arch user validate that this data is in the first line of the historic rewards table: "(.*?)" "(.*?)" "(.*?)"$/ do |admin_name, user_name, amount|
	steps %Q{
		Given I am on Arch Login screen
		When I login to Arch
		Then I click on "Companies" from Left menu
		Given I am on Companies screen
		When I open the current user company
		Then I click "Spot Rewarding" from Companies screen
		And I click "Transactions" from Companies screen
	}

	@companies_page.validate_transactions(admin_name, user_name, 'Issued', amount)
	
	steps %Q{		
		And I logout from Arch
	}
end

And /^I set Gift Cards section to be "(.*?)" the feed to be "(.*?)" and shipping to "(.*?)"$/ do |digrated_or_not, feed, shipping|
	@companies_page.set_gift_cards_feature_key(digrated_or_not, feed, shipping)
end

And /^I change account state to active for the "(.*?)"$/ do |company|
	if company == 'new company'
		company = "#{USER_PROFILE[:new_admin_user][:company_name]}" + " " + "#{@current_index}"
	elsif company == 'current company'
		company = ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]
	end

	steps %Q{
		Then I click on "Companies" from Left menu
		Given I am on Companies screen
		When I open company "#{company}"
    	Then I click "Details" from Companies screen
	    }

	@companies_page.change_company_state('Active')
end

And /^I upgrade the account from Limited to Personal$/ do
	@companies_page.upgrade_limited_user_to_personal_user
end

And /^I upgrade the latest Limited account user to Personal$/ do 
	steps %Q{
	    Given I am on Arch Login screen
	    When I login to Arch
	    Then I click on "Companies" from Left menu

	    Given I am on Companies screen
	    When I open the current user company
	    Then I select user "current limited user"
	    And I upgrade the account from Limited to Personal
	    And I logout from Arch 
	}
end