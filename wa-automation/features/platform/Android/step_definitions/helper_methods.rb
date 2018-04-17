
And /^I am logged into the Android App as a user that has not used the Android App before$/ do
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