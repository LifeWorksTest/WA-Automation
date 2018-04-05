# -*- encoding : utf-8 -*-
Given /^I am on Affiliates screen$/ do
    @affiliates_page = ArchAffiliatesPage.new @browser_arch
    @affiliates_page.is_visible('main')
end

When /^I create new affiliate$/ do
	@affiliates_page.create_new_affiliate
end

Then /^I create new campaign$/ do
	@affiliates_page.create_new_campaign
end
