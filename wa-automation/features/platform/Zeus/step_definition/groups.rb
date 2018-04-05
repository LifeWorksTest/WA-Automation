# -*- encoding : utf-8 -*-
Given /^I am on the Admin Panel Groups screen$/ do 
    @groups_page = ZeusGroupsPage.new @browser
    @groups_page.is_visible
end

When /^I create new group$/ do
	@groups_page.create_new_group
end

When /^I "(.*?)" the lestest group$/ do |action|
	@groups_page.edit_archive_delete_group(action)
end

Then /^I "(.*?)" the lateset group name$/ do |action|
	steps %Q{
		When I "#{action}" the lestest group
	}
end

