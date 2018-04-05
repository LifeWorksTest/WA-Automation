Given /^I see the iOS Menu Tab$/ do
    @menu_tab_page = page(IOSMenuTabPage).await
end

When /^I click "(.*?)" from the iOS Menu Tab$/ do |button|
    @menu_tab_page = page(IOSMenuTabPage).await
    @menu_tab_page.click_button(button)
end