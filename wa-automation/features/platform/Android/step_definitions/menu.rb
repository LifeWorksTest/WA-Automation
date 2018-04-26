# -*- encoding : utf-8 -*-
Given /^I am on the Android Menu screen$/ do
  steps %Q{
    Given I am on the Android Get Started screen and not logged in to the app
  }

	@menu_page = page(AndroidMenuPage).await

  if $current_user_company_id == nil
    @file_service = FileService.new
    $current_user_name = @file_service.get_from_file('current_user_name:')[0..-2]
    $current_user_company_id = @file_service.get_from_file('current_user_company_id:')[0..-2]
    $current_user_id = @file_service.get_from_file('current_user_id:')[0..-2]
  end
end

Given /^I am on the Android Get Started screen and not logged in to the app$/ do
  sleep 2
  if element_exists("AppCompatTextView id:'activity_prelogin_button_invitation_code'")

    steps %Q{
      Given I am on the Android Get Started screen
      Then I click from the Android Get Started screen "Login"

      Given I am on the Android Login screen
      Then I insert valid email and password from the Android app
      Then I am on the Android Menu screen
    }
    puts "The user was not logged in and therefor login scenario was executed"
  end
end

Given /^the user is logged to the Android app and not logged out$/ do
  sleep(2)

  if element_exists("android.widget.TextView marked:'More'")
    @menu_page = page(AndroidMenuPage).await
    @menu_page.logout('Yes')
  end
end

When /^I click from the Menu screen "(.*?)"$/ do |button|
	@menu_page.click_button(button)
end

When /^I scroll "(.*?)"$/ do |direction|
	@menu_page.scroll(direction)
end

When /^I open Notification from the Android menu$/ do
    @menu_page.click_button('Notification')
end

Then /^I go over the entire options$/ do
	@menu_page.loop_menu
end

And /^I logout "(.*?)"$/ do |yes_no|
    @menu_page.logout(yes_no)

    steps %Q{
      Given I am on the Android Get Started screen
    }
end

And /^I logout from the Android app$/ do
    @menu_page.logout('Yes')

    steps %Q{
      Given I am on the Android Get Started screen
    }
end

Then /^I navigate back to more$/ do
	 @menu_page.navigate_back_to_more
end

And /^I check that this user got the next notification "(.*?)"$/ do |notification|
    @menu_page.check_for_notification(notification)
end
