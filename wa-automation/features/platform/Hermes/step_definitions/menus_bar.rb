# -*- encoding : utf-8 -*-
When /^I search for "(.*?)" colleague "(.*?)"$/ do |state, user_name|
    $SEARCH_TEXT = user_name
    @menu_bar.search(state, user_name)
end

When /^I open Notification from the Web App menu$/ do
    @menu_bar = HermesMenusPage.new @browser
    @menu_bar.click_button('Notification')
end

And /^the new user click "(.*?)" from the "(.*?)" menu$/ do |button, menu|
    steps %Q{
        Then I click "#{button}" from the "#{menu}" menu
    }
end

Then /^I click "(.*?)" from the Hermes menu top bar$/ do |button|
    if !eval(ENV['LOGOUT_AFTER_SCENARIO']) && button == 'Logout'
        puts 'No logout'
    else
        @menu_bar = HermesMenusPage.new @browser
        @menu_bar.click_button(button)
    end
end

Then /^I click "(.*?)" from the "(.*?)" menu$/ do |button, menu|
    if !eval(ENV['LOGOUT_AFTER_SCENARIO']) && button == 'Logout'
        puts 'No logout'
    else
        @menu_bar = HermesMenusPage.new @browser
        @menu_bar.click_button(menu)
        @menu_bar.click_button(button)
    end
end

Then /^I logout from Web App$/ do
    steps %Q{
        Then I click "Logout" from the "Global Action" menu
    }
end

And /^I validate that "(.*?)" features are "(.*?)" on the Web App$/ do |state, is_visible|
    if state == 'disabled'
        steps %Q{
            Given I am on the Web App Login screen
            When I insert valid email and password
            Then I am login to Web App
            And I validate that the features are "visible" accourding Admin settings
            And I click "Logout" from the "Global Action" menu
        }
    elsif state == 'enabled'
        steps %Q{
            Given I am on the Web App Login screen
            When I insert valid email and password
            Then I am login to Web App
            And I validate that the features are "not visible" accourding Admin settings
            And I click "Logout" from the "Global Action" menu
        }
    end
end

And /^I validate that the features are "(.*?)" accourding Admin settings$/ do |state|
    @menu_bar = HermesMenusPage.new @browser
    @menu_bar.validate_features_accourding_admin_setting(state)
end

And /^I check that this user got the next notification "(.*?)" from the Web App$/ do |notification|
    @menu_bar.check_for_notification(notification)
end

And /^I take snapshot of the screen$/ do
    Dir::mkdir('screenshots') if not File.directory?('screenshots')
    @browser.browser.screenshot.save './screenshots/screenshot'+ Time.now.to_s + '.png'
end

And /^I validate empty state in the Web App$/ do
    steps %Q{
        Given I click "News Feed" from the "Work" menu
        When I am on the News Feed screen
        Then I validate empty state in the News Feed screen
        
        Given I click "Colleague Directory" from the "Work" menu
        When I am on the Colleague Directory screen
        Then I validate empty state in the Colleague Directory screen
    }
end

And /^I validate that all sections are visible in the Web App$/ do

    if $USER_FEATURE_LIST['social_feed']
        steps %Q{
            Given I click "News Feed" from the Hermes menu top bar
            Then I am on the News Feed screen
        }
    else
        Watir::Wait.until { !@browser.div(:id, 'feed').present? }
    end
       
    if $USER_FEATURE_LIST['social_colleague_directory']
        steps %Q{
            Given I click "Colleague Directory" from the "Work" menu
            Then I am on the Colleague Directory screen
        }
    elsif @browser.div(:id, 'company').present?
        @browser.div(:id, 'company').click
        Watir::Wait.until { !@browser.div(:id, 'directory').present? }
    end
           
    if $USER_FEATURE_LIST['social_recognition_leaderboard']
        steps %Q{
            Given I click "Leaderboard" from the "Work" menu
            Then I am on the Leaderboard screen
        }
    elsif @browser.div(:id, 'company').present?
        @browser.div(:id, 'company').click
        Watir::Wait.until { !@browser.div(:id, 'leaderboard').present? }
    end
    
    steps %{
        Given I click "Perks" from the Hermes menu top bar
    }

    if ($USER_FEATURE_LIST['benefit_online_shop'] && ($ACCOUNT_TYPE != 'shared'))
        steps %Q{
            Given I click "Shop Online" from the "Perks" menu
            Then I am on the Shop Online screen
        }   
    else
        Watir::Wait.until { !@browser.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS["components"]["main_menu"]["shop_online"]).present? }
    end

    if ($USER_FEATURE_LIST['benefit_restaurant'] && ($ACCOUNT_TYPE != 'shared'))
        steps %Q{
            Given I click "Restaurant" from the "Perks" menu
            Then I am on the Restaurant screen
        }   
    else
        Watir::Wait.until { !@browser.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS["components"]["main_menu"]["restaurants"]).present? }
    end


    if ($USER_FEATURE_LIST['benefit_cinema'] && ($ACCOUNT_TYPE != 'shared'))
        steps %Q{
            Given I click "Cinemas" from the "Perks" menu
            Then I am on the Cinema screen
        }
    else
        Watir::Wait.until { !@browser.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS["components"]["main_menu"]["cinemas"]).present? }
    end


    if (($USER_FEATURE_LIST['benefit_global_gift_cards'] > 0) && ($ACCOUNT_TYPE != 'shared'))
        steps %Q{
            Given I click "Gift Cards" from the "Perks" menu
            Then I am on the Gift Cards Offers screen
        }
    else
        Watir::Wait.until { !@browser.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS["components"]["main_menu"]["gift_cards"]).present? }
    end

    if ($USER_FEATURE_LIST['benefit_in_store_offer'] && ($ACCOUNT_TYPE != 'shared'))
        steps %Q{
            Given I click "In-Store Offers" from the "Perks" menu
            Then I am on the "In-Store Offers" offers screen
        }
    else
        Watir::Wait.until { !@browser.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS["components"]["main_menu"]["instore_offers"]).present? }
    end

    if ($USER_FEATURE_LIST['benefit_colleague_offer'] && ($ACCOUNT_TYPE != 'shared'))
        steps %Q{
            Given I click "Exclusive Offers" from the "Perks" menu
            Then I am on the "Exclusive Offers" offers screen
        }
    else
        Watir::Wait.until { !@browser.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS["components"]["main_menu"]["colleague_offers"]).present? }
    end 

    # Wallet should only be displayed in the global action menu if the Wallet feature key is enabled AND either one of 'Local' or 'ShopOnline' is enabled         
    if $USER_FEATURE_LIST['wallet'] && $USER_FEATURE_LIST['benefit_online_shop']
        steps %Q{
            Given I click "Wallet" from the "Global Action" menu
        }

        if $ACCOUNT_TYPE == 'shared'
            steps %Q{
                When I am on the Limited Account screen
                Then I skip the Limited Account page
            }
        else
            steps %Q{
                Then I am on the Your Wallet screen
            }
        end
    else
        @browser.div(:id, 'profile').hover
        Watir::Wait.until { !@browser.div(:id, 'wallet').present? }
    end
           
    if $USER_FEATURE_LIST['eap_assistance'] && !$IS_VAGRANT_ENV
        steps %Q{
            Given I click "Employee Assitance" from the "Life" menu
            Then I am on the "Employee Assitance" screen
        }
    elsif @browser.div(:id, 'life').present?
        @browser.div(:id, 'life').click
        Watir::Wait.until { !@browser.div(:id, 'employeeAssistance').present? }
    end

    if $USER_FEATURE_LIST['eap_chat'] && !$IS_VAGRANT_ENV
        steps %Q{
            Given I click "Chat" from the "Life" menu
        }

        if $ACCOUNT_TYPE == 'shared'
            steps %Q{
                Given I am on the Limited Account screen
                Then I skip the Limited Account page
            }
        else
            steps %Q{
                Then I am on the "Chat" screen
            }
        end  
    elsif @browser.div(:id, 'life').present?
        @browser.div(:id, 'life').click
        Watir::Wait.until { !@browser.div(:id, 'chat').present? }
    end

    if $ACCOUNT_TYPE != 'shared'
        steps %Q{      
            Given I click "Profile" from the "Global Action" menu
            Then I am on Web App User Profile screen
        }
    end
        steps %Q{  
            Given I click "Settings" from the "Global Action" menu
            Then I am on Web App Settings screen
        }
end