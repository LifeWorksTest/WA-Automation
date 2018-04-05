Given /^I am on Web App Settings screen$/ do
  	@settings_page = HermesSettingsPage.new @browser
  	@settings_page.is_visible('main')
end

When /^I change the user language settings to "(.*?)"$/ do |language|
  	@settings_page.set_user_lanuage(language)
end

When /^I click "(.*?)" from the Settings Screen$/ do |button|
	@settings_page.click_button(button)
end

When /^I change password to "(.*?)" and both password fields "(.*?)" and the current password is "(.*?)"$/ do |change_password_to, passwords_match, current_password_correct|
	@settings_page.change_password(eval(current_password_correct),change_password_to,eval(passwords_match))
end