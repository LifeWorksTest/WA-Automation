Given /^I am on the iOS Employee Assistance screen$/ do
	@life_page = page(IOSLifePage).await
end

Then /^I validate that all the categories have sub-categories$/ do
  @life_page.eap_screen_validate_categories
end

Then /^I open one of the articles by following the links$/ do
  @life_page.open_an_article
end
