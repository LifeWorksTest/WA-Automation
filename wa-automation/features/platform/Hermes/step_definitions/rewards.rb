# -*- encoding : utf-8 -*-
And /^"(.*?)" redeem the "(.*?)" pounds reward buying "(.*?)"$/ do |user_name, amount_expected, retailer|
	
	@rewards_page = WebAppRewardsPage.new @browser
	@rewards_page.is_visible('main')
    @rewards_page.available_rewards (true)
	@rewards_page.choose_reward(retailer, amount_expected)

	if VALIDATION[:check_notification]
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification "Congratulations! You've been rewarded £#{amount_expected}.00!" from the Web App
        }
    end

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "your_reward_confirmation"  
        }
    end
end

And /^the user validate that the following reward is visible in the redeemed list "(.*?)" pounds reward buying "(.*?)"$/ do |amount_expected, retailer|
    @rewards_page.validate_redeemed_reward(retailer, amount_expected)
end

