Given /^I am on the "(.*?)" offers screen$/ do |offer_type|
	@instore_colleauge_offers_page = HermesInstoreColleagueOffersPage.new @browser
	@instore_colleauge_offers_page.is_visible(offer_type)
end

Given /^I log into the Web App as a "(.*?)" user and navigate to the "(.*?)" offers screen$/ do |user_type, offer_type|
    steps %Q{
	    Given I am on the Web App Login screen
	    And I log into the Web App as a valid "#{user_type}" user
	    Then I click "#{offer_type}" from the "Perks" menu
	    And I am on the "#{offer_type}" offers screen
    }
end

When /^I validate the data of "(.*?)" offers$/ do |amount_of_offers_to_validate|
	@instore_colleauge_offers_page.validate_offers_data(amount_of_offers_to_validate.to_i)
end

Then /^I open an offer retailers external website$/ do
	@instore_colleauge_offers_page.open_offer
	@instore_colleauge_offers_page.click_button('View Website')
end