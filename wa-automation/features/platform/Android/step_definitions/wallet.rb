# -*- encoding : utf-8 -*-
Given /^I am on the Android Wallet screen$/ do
    @wallet_page = page(AndroidWalletPage).await
    @api_page = Api.new  
    @file_service = FileService.new
    
    @wallet_page.is_visible('Withdraw')
    @wallet_page.set_current_balances
    $user_clicked = false

    @method = @file_service.get_from_file('method:')[0..-2]
    @retailer_id = @file_service.get_from_file('retailer_id:')[0..-2]
    @retailer_name = @file_service.get_from_file('retailer_name:')[0..-2]
    $withdraw_error_less_then_501 = false
end

Given /^I purchased product from the Android Shop Online using "(.*?)" for "(.*?)" pounds and I get "(.*?)" pounds cashback and I "(.*?)" to double cashback$/ do |provider, purchase, cashback, expect_or_not|
    @create_transaction_using_server = false
    @purchase = purchase.to_f
    @purchase_in_penny = @purchase * 100
    @cashback = cashback.to_f
    @cashback_in_penny = @cashback * 100
    @purchase_date_unix_string = @file_service.get_from_file('purchase_date_unix:')
    @file_service.insert_to_file('purchase_date_unix:', @purchase_date_unix_string.to_i + 10000000)

    if @purchase > 100
      up_to_100 = 100
    else
      up_to_100 = @purchase
    end

    if $user_clicked
        cash_back_multiplier = @cash_back_multiplier_after_click
    else
        comapany = @api_page.get_company($current_user_company_id)
        cash_back_multiplier = @api_page.get_cashback_value_from_feature_list(comapany, 'benefit_cashback_bonus_incentive_networks_multiple_proc').to_f
    end

    # create transcation
    result_json = @api_page.insert_transaction_cashback(provider, @retailer_id, $current_user_id, @purchase_date_unix_string, @purchase_in_penny, @cashback_in_penny)
    puts "result_json from wallet screen: #{result_json}"
    transaction_bonus_id = result_json['body']['transaction_bonus_id']
    @transaction_id = result_json['body']['transaction_id']

    if expect_or_not == 'expect'
        if @transaction_id == nil
            fail(msg = 'Error. Expected to double cashback')
        end

        @cashback_earned_after_multiplier = (@cashback.to_f + ((@cashback.to_f / @purchase) * cash_back_multiplier * up_to_100).round(2)).round(2)
        puts "User Should get double cashback: #{@cashback.to_f} => #{@cashback_earned_after_multiplier}"
   
    elsif expect_or_not == 'dont expect'
        if @transaction_id == nil
            fail(msg = 'Error. Expected not to have double cashback')
        end
   
        @cashback_earned_after_multiplier = @cashback.to_f
        puts "User Should not get double cashback: #{@cashback_earned} => #{@cashback_earned_after_multiplier}"
    end

    $tracked_cashback = ($tracked_cashback + @cashback_earned_after_multiplier).round(2)

    @wallet_page.validate_cashback_tracked(@purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)

    # validate change in 'Tracked cashback' state, only 'Tracked cashback' shlould change
    # Updated 'Tracked cashback' should be: tracked_cashback +  @cashback_earned_after_multiplier
    steps %Q{
        Given I am on the Android Menu screen
        Then I click from the Menu screen "Wallet"
    }

    @wallet_page.validate_changes_in_current_balances
        
    if VALIDATION[:check_notification]
        steps %Q{
            Given I am on the Android Menu screen
            When I open Notification from the Android menu
            Then I check that this user got the next notification "Your recent purchase at #{@retailer_name} has been successfully tracked"
        }
    end

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "We've tracked the cashback from your recent purchase at"  
        }
    end
end

When /^I ask for cashback from the Android app and it was declined$/ do
    
    # After the next call to the API the cashback request will have Declined state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will not change their value.
    @api_page.update_transaction_cashback($current_user_id, @transaction_id, 4)
    
    @wallet_page.validate_cashback_confirmed_or_declined(@purchase_date_unix_string, @purchase.to_f,  @cashback_earned_after_multiplier, 'decline')
    $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)

    steps %Q{
        Given I am on the Android Menu screen
        Then I click from the Menu screen "Wallet"
    }

    @wallet_page.validate_changes_in_current_balances
    
    if VALIDATION[:check_notification]
        steps %Q{
            Given I am on the Android Menu screen
            When I open Notification from the Android menu
            Then I check that this user got the next notification "Your recent purchase at .* has unfortunately been declined"
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "Your cashback has been declined"  
    }
    end
end

Then /^I ask for cashback from the Android app$/ do
    # After the next call to the API the cashback request will have Confiremd state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will change their value.
    
    @api_page.update_transaction_cashback($current_user_id, @transaction_id)

    @wallet_page.validate_cashback_confirmed_or_declined(@purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)
    
    # validate change in 'Tracked cashback' and 'Available to withdraw' state
    # Updated 'Tracked Cashback' should be: tracked_cashback - @cashback_earned_after_multiplier
    # Updated 'Available to withdraw' should be: tracked_cashback + @cashback_earned_after_multiplier
    steps %Q{
        Given I am on the Android Menu screen
        Then I click from the Menu screen "Wallet"
    }
    if !@create_transaction_using_server
        $available_to_withdraw = ($available_to_withdraw + @cashback_earned_after_multiplier).round(2)
        $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)
        
        steps %Q{
            Given I am on the Android Menu screen
            Then I click from the Menu screen "Wallet"
        }
        @wallet_page.validate_changes_in_current_balances
    else
        steps %Q{
            Given I am on the Android Menu screen
            Then I click from the Menu screen "Wallet"
        }
        @wallet_page.validate_changes_in_current_balances
    end

    if VALIDATION[:check_notification]
        steps %Q{
            Given I am on the Android Menu screen
            When I open Notification from the Android menu
            Then I check that this user got the next notification "#{sprintf('%.2f', @cashback_earned_after_multiplier)} cashback from #{@retailer_name} has been approved and is now in your wallet"
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "Your cashback from [retailer_name] has been confirmed"   
        }
    end
end

Then /^I raise claim from the Android app$/ do
    @wallet_page.raise_clime

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "Cashback query received"
        }
    end
end

And /^I request to withdrew from the Android app to my "(.*?)" using the API$/ do |paypal_or_bank|
    user_token = @api_page.get_user_token(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password])
    @withdrew_transaction_id = @api_page.create_user_withdrawal(ACCOUNT[:"#{$account_index}"][:valid_account][:email], ACCOUNT[:"#{$account_index}"][:valid_account][:password], @method, user_token)
    @paypal_or_bank = paypal_or_bank

    if (/An error occurred; Cannot withdraw available amount. Below minimum amount authorized./.match @withdrew_transaction_id) != nil
        $withdraw_error_less_then_501 = true
    else
        @wallet_page.validate_withdraw_requsted(@method, $available_to_withdraw)
    end
    
    if VALIDATION[:check_notification]
        puts "Your cashback withdrawal has been received and will be transferred via your chosen payment method shortly"
        steps %Q{
            Given I am on the Android Menu screen
            When I open Notification from the Android menu
            Then I check that this user got the next notification "Your cashback withdrawal has been received and will be transferred via your chosen payment method shortly"
        }
    
    elsif VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "Cashback withdrawal received"     
        }
    end
end

And /^the withdrew request from the Android app was "(.*?)" by Arch user$/ do |approve_or_decline|
    if @withdrew_automatically
        available_to_withdraw = @available_to_withdraw_befor_withdrew_automatically
    else
        available_to_withdraw = $available_to_withdraw
    end

    steps %Q{
        Given I am on Arch Login screen
        When I login to Arch
        Then I click on "Withdrawals" from Left menu
        Given I am on Arch Withdrawls screen
        When I "#{approve_or_decline}" withdrew request to "#{@paypal_or_bank}" that belong to User: "#{$current_user_name}" ID: "#{$current_user_id}" with amount of "#{available_to_withdraw}"
        Then I logout from Arch
    }

    if approve_or_decline == 'approve'
        $withdrawn_to_date = ($withdrawn_to_date + $available_to_withdraw).round(2)
        $available_to_withdraw = 0.0
        
        steps %Q{
            Given I am on the Android Menu screen
            Then I click from the Menu screen "Wallet"
        }   
        @wallet_page.validate_changes_in_current_balances

        if VALIDATION[:check_notification]
            steps %Q{
                When I open Notification from the Android menu
                Then I check that this user got the next notification "Your cashback withdrawal has been confirmed and will be available shortly"
            }
        end

        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "Cashback withdrawal confirmed"
            }
        end
    elsif approve_or_decline == 'decline'
        steps %Q{
            Given I am on the Android Menu screen
            Then I click from the Menu screen "Wallet"
        }
        @wallet_page.validate_changes_in_current_balances

        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "Cashback withdrawal failed"
            }
        end
    end
end


And /^the withdrew request from the Android app was "(.*?)" using the API$/ do |approve_or_decline|
    @api_page.approve_or_decline_withdraw(@withdrew_transaction_id, approve_or_decline)
    
    @wallet_page.validate_withdraw_confirm_or_decline(@method, $available_to_withdraw, approve_or_decline)
    
    # validate change in 'Withdrawn to date' and 'Available to withdraw' state
    if approve_or_decline == 'approve'
        # Updated 'Withdrawn to date' should be: withdrawn_to_date + @cashback_earned_after_multiplier
        # Updated 'Available to withdraw' should be: 0
        $withdrawn_to_date = ($withdrawn_to_date + $available_to_withdraw).round(2)
        $available_to_withdraw = 0.0

        if VALIDATION[:check_notification]
            puts "Your cashback withdrawal has been confirmed and will be available shortly"
            steps %Q{
                Given I am on the Android Menu screen
                When I open Notification from the Android menu
                Then I check that this user got the next notification "Your cashback withdrawal has been confirmed and will be available shortly"
            }
        end

        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "Cashback withdrawal confirmed"
            }
        end
        
    # 'Withdrawn to date' and 'Available to withdraw' should not change
    elsif approve_or_decline == 'decline'

        if VALIDATION[:check_email]
            puts "Your cashback withdrawal has been decline .*"
            steps %Q{
                Then I recived an email with the subject "Cashback withdrawal failed"
            }
        end
    end
end

And /^I request to withdrew from the Android app to the "(.*?)" account$/ do |paypal_or_bank|
    @paypal_or_bank = paypal_or_bank
    
    if @paypal_or_bank == 'Paypal'
        @wallet_page.request_withdrew_paypal_android
    elsif @paypal_or_bank == 'Bacs'
        @wallet_page.request_withdrew_bank_android
    end

    if VALIDATION[:check_notification] && !$withdraw_error_less_then_501
        puts 'Your cashback withdrawal has been received and will be transferred via your chosen payment method shortly'
        steps %Q{
            Given I am on the Android Menu screen
            When I open Notification from the Android menu
            Then I check that this user got the next notification "Your cashback withdrawal has been received and will be transferred via your chosen payment method shortly"
        }
    end

    if VALIDATION[:check_email] && !$withdraw_error_less_then_501
        steps %Q{
            Then I recived an email with the subject "Cashback withdrawal received"
        }
    end
end

And /^the withdrew request from the Android app was decline$/ do
    if $withdraw_error_less_then_501
        puts "Available to withdraw is less then 5 pounds can't withdraw"
    else
        fail(msg = 'Error. Withdraw request was needed to fail because the Available to withdraw should be less then 5 pounds')
    end
end

And /^I reset time to be as before the change in the Android app$/ do
    @purchase_date_unix_string = @file_service.get_from_file('purchase_date_unix:')
    @file_service.insert_to_file('purchase_date_unix:', @purchase_date_unix_string.to_i - 10000000)
end

And /^the money was withdrew automatically to the Android app$/ do
    @withdrew_automatically = true
    @method = 'bacs'
    @api_page.automatic_withdrew
    $available_to_withdraw_befor_withdrew_automatically = $available_to_withdraw 
    $available_to_withdraw = 0.0
    @wallet_page.validate_changes_in_current_balances
end
