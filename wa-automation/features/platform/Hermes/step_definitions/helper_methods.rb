And /^I am successfully redirected to the external website$/ do
    @helper_methods_page = HermesHelperMethodsPage.new @browser
    @helper_methods_page.verify_external_redirection
end

And /^I am logged into the Web App as a user that has not used the Web App before$/ do
    
    if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Headless'
        steps %Q{
            Given I am on the Web App Login screen
            And I insert valid email and password
            When I am login to Web App
            Then I am on the News Feed screen
        } 
    else
        steps %Q{
            Given I am on the Admin Panel Login screen
            When I insert valid email and password from the Admin Panel screen
            Then I am login to Admin Panel
        
            Given I am on the Dashboard
            When I click on "Menu" from Top Bar menu
            Then I click on "Settings" from Top Bar menu
            
            Given I am on the Admin Panel Settings screen
            When I click on "Invitations" from the Settings screen
            Then I generate new invitation code 
            And I logout from Admin Panel
        
            Given I am on the Web App Login screen
            And  I click "Signup" from the Web App Login screen
            When I sign up to the Web App using "Company Code" with a "matching" company email domain
            And I am on the Web App Login screen
            Then I login to the Web App with the latest new "user" account
        }
    end
end