Given /^I am on the Manage Colleagues screen$/ do
    @manage_colleagues_page = ZeusManageColleaguesPage.new @browser
    @manage_colleagues_page.is_visible
end

Given /^I invite a friend from the Manage Colleague screen$/ do
	@manage_colleagues_page.invite
end