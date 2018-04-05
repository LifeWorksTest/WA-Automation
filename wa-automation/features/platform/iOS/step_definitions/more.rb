Given /^I am on the iOS More screen$/ do
    @more_page = page(IOSMorePage).await
end

Then /^I click from the iOS More screen "(.*?)"$/ do |button|
   @more_page.click_button(button) 
end

Then /^I navigate to iOS Snackable Topics screen$/ do
  @more_page.naviagte_to_snackable
end

And /^I logout from the iOS app$/ do
  steps %Q{
    When I click "More" from the iOS Menu Tab
    Then I am on the iOS More screen
  }
  @more_page.logout
end