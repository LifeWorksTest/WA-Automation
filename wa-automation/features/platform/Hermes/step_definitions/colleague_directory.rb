# -*- encoding : utf-8 -*-
Then /^I am on the Colleague Directory screen$/ do
    @colleague_directory_page = HermesColleagueDirectoryPage.new @browser
    @colleague_directory_page.is_visible
end

Then /^I validate that the total number of colleagues is correct$/ do
    @colleague_directory_page.validate_total_number_of_colleagues
end

Then /^I search for "(.*?)" colleague with the name "(.*?)" and I verify the results$/ do |state, user_name|
    @colleague_directory_page.search_user(user_name,state)
end

And /^I check that the list is sorted$/ do
    @colleague_directory_page.check_list_is_sorted
end

And /^I validate empty state in the Colleague Directory screen$/ do
	@colleague_directory_page.validate_empty_state
end

And /^I validate that grouping fuctionalty is "(.*?)" in Colleague Directory screen$/ do |enabled_disabled|
	@colleague_directory_page.grouping_is_valid (enabled_disabled)
end