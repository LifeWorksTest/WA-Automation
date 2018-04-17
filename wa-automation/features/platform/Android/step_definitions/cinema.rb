Given /^I am on the Android Cinemas screen$/ do
	@cinemas_page = page(AndroidCinemasPage).await
end

Then /^I purchase "(.*?)" "(.*?)" and "(.*?)" "(.*?)" "(.*?)" tickets at "(.*?)" cinema branch$/ do |amount_1, ticket_type_1, amount_2, ticket_type_2, cinema_name, cinema_location|
	puts "cinema_name:#{cinema_name} ticket_type_1:#{ticket_type_1} ticket_type_2:#{ticket_type_2}"
	purchase_order_array = [[amount_1.to_i, CINEMAS[:"#{cinema_name}"][:ticket_types][:"#{ticket_type_1}"][:name]],[amount_2.to_i, CINEMAS[:"#{cinema_name}"][:ticket_types][:"#{ticket_type_2}"][:name]]]
	@cinemas_page.purchase_ticket(CINEMAS[:"#{cinema_name}"][:name], CINEMAS[:"#{cinema_name}"][:locations][:"#{cinema_location}"][:name], purchase_order_array)
end