

Given /^I am on the iOS Perks Home page$/ do
	@perks_home_page = page(IOSPerksHomePage).await
end 

Given /^I navigate to iOS "(.*?)" screen from iOS Perks Home page$/ do |page|
	@perks_home_page.navigate_to_a_page(page)
end