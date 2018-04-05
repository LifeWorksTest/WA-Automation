Given /^I am on the Cinemas screen$/ do
	@cinemas_page = ArchCinemasPage.new @browser_arch
	@cinemas_page.is_visible('Main')
end

Given /^I create a new Cinema with the name "(.*?)" with ticket types "(.*?)" and location "(.*?)"$/ do |cinema_name, ticket_types, cinema_locations|
	@cinemas_page = ArchCinemasPage.new @browser_arch
	@cinemas_page.click_button('Merchant')
	@cinemas_page.create_new_cinema(cinema_name,ticket_types,cinema_locations)
end

Given /^I select "(.*?)" from merchant screen$/ do |cinema_name|
	@cinemas_page = ArchCinemasPage.new @browser_arch
	@cinemas_page.click_button('Merchant')
	@cinemas_page.edit_or_delete_cinema(cinema_name)
end

Given /^I upload "(.*?)" "(.*?)" tickets to the code stock page$/ do |ticket_quantity, ticket_type|
	# @cinemas_page = ArchCinemasPage.new @browser_arch
	@cinemas_page.upload_cinema_stock_csv(ticket_type,ticket_quantity)
end

Given /^I verify the latest transaction is correctly displayed on the Arch Cinema transaction page$/ do 
	@cinemas_page.verify_cinema_transaction_order_details
end


And /^I verify the transaction is correctly displayed in Arch$/ do
    steps %Q{
		Given I am on Arch Login screen
		And I login to Arch
		And I click on "Cinemas" from Left menu
 		When I am on the Cinemas screen
 		And I verify the latest transaction is correctly displayed on the Arch Cinema transaction page
    }
end

And /^I delete "(.*?)" ticket types in Arch$/ do |ticket_types|	
	# @cinemas_page = ArchCinemasPage.new @browser_arch
	steps %Q{
		And I click on "Cinemas" from Left menu
 		When I am on the Cinemas screen
 	}

 	@cinemas_page.delete_ticket_types (ticket_types)
end

And /^I delete the newly created Cinema in Arch$/ do
	steps %Q{
		And I click on "Cinemas" from Left menu
 		When I am on the Cinemas screen
 	}
 	@cinemas_page.click_button('Merchant')
 	@cinemas_page.edit_or_delete_cinema($CINEMA_NAME,'Delete')
end