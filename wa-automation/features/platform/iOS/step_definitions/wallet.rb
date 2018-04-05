# -*- encoding : utf-8 -*-
Given /^I am on the iOS Wallet screen$/ do
    @wallet_page = page(IOSWalletPage).await
    @api_page = Api.new  
    @file_service = FileService.new
    
    @wallet_page.is_visible('Withdraw')
    @wallet_page.set_current_balances
    $user_clicked = false

    @method = @file_service.get_from_file('wallet_withdrew_method:')[0..-2]
    #@retailer_id = @file_service.get_from_file('retailer_id:')[0..-2]
    #@retailer_name = @file_service.get_from_file('retailer_name:')[0..-2]
    $withdraw_error_less_then_501 = false

    if $current_user_email == nil
        $current_user_email = @file_service.get_from_file('current_user_email:')[0..-2]
    end

    if $current_user_id == nil
        $current_user_name = @file_service.get_from_file('current_user_name:')[0..-2]
        $current_user_company_id = @file_service.get_from_file('current_user_company_id:')[0..-2]
        $current_user_id = @file_service.get_from_file('current_user_id:')[0..-2]
        $current_user_email = @file_service.get_from_file('current_user_email:')[0..-2]
    end 

end

And /^I validate that "(.*?)" "(.*?)" are in available to withdraw in the iOS app$/ do |amount,currency_name|
    puts "$available_to_withdraw:#{$available_to_withdraw}"
    $available_to_withdraw = $available_to_withdraw + amount.to_i
    puts "$available_to_withdraw:#{$available_to_withdraw}"
    @wallet_page.validate_changes_in_current_balances
    @cashback_earned_after_multiplier = amount
end


Given /^I purchased product from the iOS Shop Online using "(.*?)" for "(.*?)" pounds and I get "(.*?)" pounds cashback and I "(.*?)" to double cashback$/ do |provider, purchase, cashback, expect_or_not|
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

        if provider == 'incentive networks'
            cash_back_multiplier = @api_page.get_cashback_value_from_feature_list(comapany, 'benefit_cashback_bonus_incentive_networks_multiple_proc').to_f
        elsif provider == 'bownty'
            cash_back_multiplier = @api_page.get_cashback_value_from_feature_list(comapany, 'benefit_cashback_bonus_bownty_multiple_proc').to_f
        end
    end

    # create transcation
    # If transaction is Book a table the given cashback is after calculation and for that reason calculate the original cashback
    if provider == 'bat'
        @cashback_in_penny = 100 * @cashback / $base_value.to_f
        result_json = @api_page.insert_transaction_cashback(provider, @retailer_id, $current_user_id, @purchase_date_unix_string, @purchase_in_penny, @cashback_in_penny)
    else
        result_json = @api_page.insert_transaction_cashback(provider, @retailer_id, $current_user_id, @purchase_date_unix_string, @purchase_in_penny, @cashback_in_penny)
    end

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

    steps %Q{
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Colleague Offers"
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Wallet"
    }

    puts "$tracked_cashback:#{$tracked_cashback} cashback_earned_after_multiplier:#{@cashback_earned_after_multiplier}"
    $tracked_cashback = ($tracked_cashback + @cashback_earned_after_multiplier).round(2)
 
    @wallet_page.validate_cashback_tracked(@purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)

    # validate change in 'Tracked cashback' state, only 'Tracked cashback' shlould change
    # Updated 'Tracked cashback' should be: tracked_cashback +  @cashback_earned_after_multiplier
    @wallet_page.validate_changes_in_current_balances
        
    if VALIDATION[:check_notification]
        steps %Q{
            When I open iOS Notification from the menu
            Then I check that this user got the next notification "Your recent purchase at #{@retailer_name} has been successfully tracked" from the iOS app
        }
    end

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "We've tracked the cashback from your recent purchase at"  
        }
    end
end

When /^I ask for cashback from the iOS app and it was declined$/ do
    
    # After the next call to the API the cashback request will have Declined state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will not change their value.
    @api_page.update_transaction_cashback($current_user_id, @transaction_id, 4)
    
    steps %Q{
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Colleague Offers"
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Wallet"
    }

    @wallet_page.validate_cashback_confirmed_or_declined(@purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier, 'decline')
    $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)

    @wallet_page.validate_changes_in_current_balances

    if VALIDATION[:check_notification]
        steps %Q{
            When I open iOS Notification from the menu
            Then I check that this user got the next notification "Your recent purchase at #{@retailer_name} has unfortunatley been declined" from the iOS app
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "Your cashback has been declined"  
    }
    end
end

Then /^I ask for cashback from the iOS app$/ do
    # After the next call to the API the cashback request will have Confiremd state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will change their value.
    
    @api_page.update_transaction_cashback($current_user_id, @transaction_id)

    steps %Q{
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Colleague Offers"
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Wallet"
    }

    @wallet_page.validate_cashback_confirmed_or_declined(@purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)
    
    # validate change in 'Tracked cashback' and 'Available to withdraw' state
    # Updated 'Tracked Cashback' should be: tracked_cashback - @cashback_earned_after_multiplier
    # Updated 'Available to withdraw' should be: tracked_cashback + @cashback_earned_after_multiplier
    if !@create_transaction_using_server
        $available_to_withdraw = ($available_to_withdraw + @cashback_earned_after_multiplier).round(2)
        $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)
        @wallet_page.validate_changes_in_current_balances
    else
        # $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)

        @wallet_page.validate_changes_in_current_balances
    end

    if VALIDATION[:check_notification]
        steps %Q{
            When I open iOS Notification from the menu
            Then I check that this user got the next notification "£#{sprintf('%.2f', @cashback_earned_after_multiplier)} cashback from #{@retailer_name} has been approved and is now in your wallet" from the iOS app
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "Your cashback from [retailer_name] has been confirmed"   
        }
    end
end

Then /^I raise claim from the iOS app$/ do
    @wallet_page.raise_clime

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "Cashback query received"
        }
    end
end

And /^I request to withdrew from the iOS app to my "(.*?)" using the API$/ do |paypal_or_bank|
    @user_token = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])
    @withdrew_transaction_id = @api_page.create_user_withdrawal($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password], @method, @user_token)
    @paypal_or_bank = paypal_or_bank

    @temp_available_to_withdraw = $available_to_withdraw

    @wallet_page.click_button('Transactions')
    @wallet_page.click_button('Withdraw')

    if (/An error occurred; Cannot withdraw available amount. Below minimum amount authorized./.match @withdrew_transaction_id) != nil
        $withdraw_error_less_then_501 = true
    else
        @wallet_page.validate_withdraw_requsted(@method, $available_to_withdraw)
    end
    
    if VALIDATION[:check_notification]
        puts "Your cashback withdrawal has been received and will be tansferred via your chosen payment method shortly"
        steps %Q{
            When I open iOS Notification from the menu
            Then I check that this user got the next notification "Your cashback withdrawal has been received and will be tansferred via your chosen payment method shortly" from the iOS app
        }
    
    elsif VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "cashback_withdrawal_received"     
        }
    end
end

And /^the withdrew request from the iOS app "(.*?)" by Arch user$/ do |approve_or_decline|
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
        puts "$withdrawn_to_date:#{$withdrawn_to_date}"
        puts "$available_to_withdraw:#{$available_to_withdraw}"
        $withdrawn_to_date = ($withdrawn_to_date + @temp_available_to_withdraw).round(2)
        puts "$withdrawn_to_date:#{ $withdrawn_to_date}"
        $available_to_withdraw = 0.0

        @wallet_page.validate_changes_in_current_balances
        puts "@cashback_earned_after_multiplier:#{@cashback_earned_after_multiplier}"
        puts "$available_to_withdraw:#{$available_to_withdraw}"
        @wallet_page.validate_withdraw_confirm_or_decline(@method, @temp_available_to_withdraw, approve_or_decline)

        if VALIDATION[:check_notification]
            steps %Q{
                When I open Notification from the Web App menu
                Then I check that this user got the next notification "Your cashback withdrawal has been confirmed and will be available shortly" from the Web App
                And I take snapshot of the screen
            }
        end

        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "wallet_withdrawal_request_confirmed"
            }
        end
    elsif approve_or_decline == 'decline'
        
        @wallet_page.transactions_validation('Declined', @description, 'withdrawal', nil,  nil, $available_to_withdraw, @paypal_or_bank)
        @wallet_page.validate_changes_in_current_balances


        if VALIDATION[:check_email]
            steps %Q{
                Then I recived an email with the subject "cashback_withdrawal_failed"
            }
        end
    end
end

And /^the withdrew request from the iOS app was "(.*?)" using the API$/ do |approve_or_decline|
    if @withdrew_transaction_id == nil
        @user_token = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])
        @withdrew_transaction_id = @api_page.get_user_transaction(@user_token, true)
    end
    
    puts "@withdrew_transaction_id:#{@withdrew_transaction_id}"
    @api_page.approve_or_decline_withdraw(@withdrew_transaction_id, approve_or_decline)
    
    @wallet_page.click_button('Transactions')
    @wallet_page.click_button('Withdraw')

    if @withdrew_automatically
        @wallet_page.validate_withdraw_confirm_or_decline(@method, $available_to_withdraw_befor_withdrew_automatically, approve_or_decline)
    else 
        @wallet_page.validate_withdraw_confirm_or_decline(@method, $available_to_withdraw, approve_or_decline)
    end
    
    # validate change in 'Withdrawn to date' and 'Available to withdraw' state
    if approve_or_decline == 'approve'
        # Updated 'Withdrawn to date' should be: withdrawn_to_date + @cashback_earned_after_multiplier
        # Updated 'Available to withdraw' should be: 0
        $withdrawn_to_date = ($withdrawn_to_date + $available_to_withdraw).round(2)
        $available_to_withdraw = 0.0

        if VALIDATION[:check_notification]
            puts "Your cashback withdrawal has been confirmed and will be available shortly"
            steps %Q{
                When I open iOS Notification from the menu
                Then I check that this user got the next notification "Your cashback withdrawal has been confirmed and will be available shortly" from the iOS app
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

And /^I request to withdrew from the iOS app to the "(.*?)" account$/ do |paypal_or_bank|
    @paypal_or_bank = paypal_or_bank
    
    @wallet_page.request_withdraw(paypal_or_bank)

    if VALIDATION[:check_notification] && !$withdraw_error_less_then_501
        puts 'Your cashback withdrawal has been received and will be transferred via your chosen payment method shortly'
        steps %Q{
            Given I am on the Menu screen
            When I open iOS Notification from the menu
            Then I check that this user got the next notification "Your cashback withdrawal has been received and will be transferred via your chosen payment method shortly" from the iOS app
        }
    end

    if VALIDATION[:check_email] && !$withdraw_error_less_then_501
        steps %Q{
            Then I recived an email with the subject "Cashback withdrawal received"
        }
    end
end

And /^the withdrew request from the iOS app was decline$/ do
    if $withdraw_error_less_then_501 == nil
        wait_for(:timeout => 30){element_exists("label marked:'You need at least £5.01 available in your account to withdraw and your network needs to be at least 28 days old.'")}
        wait_for(:timeout => 30){element_exists("label marked:'OK'")}
        touch("label marked:'OK'")
        wait_for(:timeout => 30){element_does_not_exist("label marked:'OK'")}

        $withdraw_error_less_then_501 = true
    end

    if $withdraw_error_less_then_501
        puts "Available to withdraw is less then 5 pounds can't withdraw"
    else
        fail(msg = 'Error. Withdraw request was needed to fail because the Available to withdraw should be less then 5 pounds')
    end
end

And /^I reset time to be as before the change in the iOS app$/ do
    @purchase_date_unix_string = @file_service.get_from_file('purchase_date_unix:')
    @file_service.insert_to_file('purchase_date_unix:', @purchase_date_unix_string.to_i - 10000000)
end

And /^the money was withdrew automatically to the iOS app$/ do
    @withdrew_automatically = true
    @method = 'bacs'
    @api_page.automatic_withdrew

    steps %Q{
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Colleague Offers"
        Given I am on the iOS Menu screen
        When I click from the iOS Menu screen "Wallet"
    }

    $available_to_withdraw_befor_withdrew_automatically = $available_to_withdraw 
    $available_to_withdraw = 0.0
    @wallet_page.validate_changes_in_current_balances
end
