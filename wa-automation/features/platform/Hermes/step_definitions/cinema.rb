Given /^I am on the Cinema screen$/ do
  @cinema_page = HermesCinemaPage.new @browser
  @cinema_page.is_visible('main')
end

Given /^I log into Arch and navigate to the Cinema screen$/ do
  steps %Q{
    Given I am on Arch Login screen
    When I login to Arch
    Then I click on "Cinemas" from Left menu
    Given I am on the Cinemas screen
  }
end

Given /^I navigate to the Web App Cinema screen using a "(.*?)" account and select the new Cinema$/ do |user_type|
  steps %Q{
    Given I am on the Web App Login screen
    And I log into the Web App as a valid "#{user_type}" user
  	When I click "Cinemas" from the "Perks" menu
  	And I am on the Cinema screen
    Then I select the new Cinema from the select Cinema page
  }
end

Then /^I select the new Cinema from the select Cinema page$/ do
	@cinema_page.search_for_and_open_cinema
end

Then /^I successfully pay for the Cinema tickets I have selected and verify the confirmation email$/ do 
	@cinema_page.click_button('buy now')
	@cinema_page.cinema_payment
  steps %Q{
    When I recived an email with the subject "your_lifeWorks_cinema_discount_codes"
  }
end

And /^I select "(.*?)" from the select Cinema ticket page$/ do |cinema_location|
	@cinema_page.choose_a_cinema_location(cinema_location)
end

And /^I verify that "(.*?)" is displayed on the Cinema page$/ do |ticket_types|
	@cinema_page.verify_ticket_types(ticket_types)
end

And /^I add "(.*?)" "(.*?)" Cinema tickets to my order$/ do |amount_to_select, ticket_types|
	@cinema_page.select_amount_of_tickets(ticket_types,amount_to_select)
end

And /^I verify that I cannot purchase tickets for "(.*?)" as they are out of stock$/ do |ticket_type|
	@cinema_page.verify_ticket_types(true,ticket_type)
end

And /^I verify that the View your Cinema Codes link contains the purchased ticket codes$/ do
  steps %Q{
    Given I click "Cinemas" from the "Perks" menu
    And I am on the Cinema screen
  }

  @cinema_page.verify_ticket_codes_in_view_cinema_codes_link
end
