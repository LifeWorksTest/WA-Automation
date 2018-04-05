# -*- encoding : utf-8 -*-
Given /^I am on the Admin Panel Settings screen$/ do
  @setting_page = ZeusSettingsPage.new @browser
  @setting_page.is_visible
end

When /^I click on "(.*?)" from the Settings screen$/ do |button|
  @setting_page.click_button(button)
end

Then /^I change the state of "(.*?)" to "(.*?)"$/ do |row, change_state_to|
  if row == 'Social Recognition'
    index = 0
  elsif row == 'Company Feed'
    index = 1
  elsif row == 'Colleague Directory'
    index = 2
  end

  @setting_page.change_state(change_state_to, index)
end

Then /^I generate new invitation code$/ do
  @setting_page.create_new_invitation
end 

Then /^I validate that I can upload and delete all available images$/ do
  ['png', 'gif', 'jpg'].each do |image_format_to_upload|
    @setting_page.verify_image_upload_and_deletion(image_format_to_upload)
  end
end