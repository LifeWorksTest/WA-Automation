Given /^I am on Offers screen$/ do
    @offers_page = ArchOffersPage.new @browser_arch
    @offers_page.is_visible('Main')
end

When /^I create a new "(.*?)" offer in Arch$/ do |offer_type|
	@offers_page.click_button(offer_type.gsub(' Offers', '').gsub('Exclusive', 'Colleague'))
	@offers_page.create_offer(offer_type)
end