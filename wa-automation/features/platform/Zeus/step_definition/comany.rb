# -*- encoding : utf-8 -*-
Given /^I am on the Company screen$/ do
    @company_page = ZeusCompanyPage.new @browser
end

Then /^I change all badges state to "(.*?)"$/ do |change_state_to|
    i = 0

    BADGES.each {|badge_name, badge_hashtag|
        
        # Must have at least one badge in the list and go over every second badge
        if (badge_name != BADGE_TO_KEEP[:badge_name]) && (i % 2 != 1) 
            @company_page.change_state_of_badge(change_state_to, badge_name)
        end

        i += 1
    }
end

Then /^I check if this badge "(.*?)" with this description "(.*?)" "(.*?)"$/ do |badge_name, badge_description, exists_or_not|
	@company_page.check_if_badge_exists(badge_name, badge_description, exists_or_not)
end
