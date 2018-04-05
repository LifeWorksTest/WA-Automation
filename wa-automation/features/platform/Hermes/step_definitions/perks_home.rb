Given /^I am on the Perks Homepage screen$/ do
    @perks_homepage_page = PerksHomePage.new @browser
    @perks_homepage_page.is_visible('main')
end

Given /^I validate that the Perks Homepage functionality is working correctly$/ do
	@perks_homepage_page.validate_perks_homepage
end