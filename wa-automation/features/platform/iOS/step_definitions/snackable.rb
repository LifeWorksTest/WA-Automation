# -*- encoding : utf-8 -*-
Given /^I am on the iOS Snackable Topics screen$/ do
    @snackable_page = page(IOSSnackablePage).await
    @snackable_page.is_visible('Main')
end

Then /^I select "(.*?)" categories and "(.*?)" Snackable sub topics on iOS Snackable Topics screen$/ do |categories_to_select, topics_to_select|
  @snackable_page.select_wellness_categories(categories_to_select,topics_to_select)
end