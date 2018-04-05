# -*- encoding : utf-8 -*-
Given /^the admin set the remaining rewards budget$/ do
	steps %Q{
		Given I am on the Admin Panel Login screen
    	When I insert valid email and password from the Admin Panel screen
    	Then I am login to Admin Panel
    	And I click on "Rewards" from Top Bar menu
    	And I set the remaining rewards budget
    	And I logout from Admin Panel
	}
end

Then /^the admin give "(.*?)" pounds reward to "(.*?)"$/ do |amount, user_name|
	steps %Q{
		Given I am on the Admin Panel Login screen
	    When I insert valid email and password from the Admin Panel screen
	    Then I am login to Admin Panel
	    And I click on "Rewards" from Top Bar menu
	    And I give "#{amount}" pounds reward to "#{user_name}"
	    And I logout from Admin Panel
	}
end

Then /^I validate empty state in the rewards screen$/ do
	@rewards_page = ZeusRewardPage.new @browser
	@rewards_page.validate_empty_state
end

And /^I set the remaining rewards budget$/ do
	puts "BROWSER_ARCH #{@browser_arch}"
	puts "BROWSER #{@browser}"
	@rewards_page = ZeusRewardPage.new @browser
    @rewards_page.is_visible('main')
end

And /^I give "(.*?)" pounds reward to "(.*?)"$/ do |amount, user_name|
	@rewards_page = ZeusRewardPage.new @browser
	@rewards_page.select_user_to_reward(user_name)
	@rewards_page.reward_colleague(user_name, amount)
	
	steps %Q{
        Then I recived an email with the subject "Congratulations!_You've_been_rewarded"  
    }
end

And /^the admin validate that this data is in the first line of the historic rewards table: "(.*?)" "(.*?)" "(.*?)" "(.*?)"$/ do |user_name, admin_name, amount, reward_state|
	steps %Q{
		Given I am on the Admin Panel Login screen
	    When I insert valid email and password from the Admin Panel screen
	    Then I am login to Admin Panel
	    And I click on "Rewards" from Top Bar menu
	}

	@rewards_page = ZeusRewardPage.new @browser
	@rewards_page.validate_date_in_historic_rewards(user_name, admin_name, amount, reward_state)
	
	steps %Q{
		And I logout from Admin Panel
	}
end
