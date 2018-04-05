Given /^I am on the Zeus sales screen$/ do
	puts "@browser#{$browser}"
    @sales_page = ZeusSalesPage.new $browser
end

When /^I click on "(.*?)" from the Zeus sales screen$/ do |button|
	@sales_page.click_button(button)
end
When /^I signup for the 3 months trail$/ do
	
	@sales_page.signup
	if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "Your LifeWorks Free Trial"  
        }
    end
end

