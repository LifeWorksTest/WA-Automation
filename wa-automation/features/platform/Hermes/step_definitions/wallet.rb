# -*- encoding : utf-8 -*-
Given /^I am on the Your Wallet screen$/ do 
    @wallet_page = HermesWalletPage.new (@browser)
    @api_page = Api.new  
    @file_service = FileService.new
    @wallet_page.is_visible('Withdraw')
    @wallet_page.set_current_balances
    $user_clicked = false

    @method = 'paypal'
    @retailer_id = "#{SHOP_ONLINE_RETAILERS[:retailer_1][:id]}"
    @retailer_name = "#{SHOP_ONLINE_RETAILERS[:retailer_1][:name]}"
    @wallet_page.validate_currency_over_the_page("#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}")
    @deal_id = "#{DAILY_DEAL_OFFERS[:offer_1][:id]}"
    @restaurant_id = "#{RESTAURATS_OFFERS[:restaurant_1][:id]}"
end

Given /^I create transaction through the server using "(.*?)" for "(.*?)" pounds and I get "(.*?)" pounds cashback and I "(.*?)" to double cashback$/ do |method, purchase, cashback, expect_or_not|
    @create_transaction_using_server = true
    @purchase = purchase.to_f
    @cashback = cashback.to_f
    @purchase_date_unix_string = @file_service.get_from_file('purchase_date_unix:')[0..-2]
    @purchase_date = DateTime.strptime(@purchase_date_unix_string,'%s').strftime("%Y-%m-%d")
    puts "@purchase_date:#{@purchase_date} @purchase_date_unix_string:#{@purchase_date_unix_string}"
    @file_service.insert_to_file('purchase_date_unix:', @purchase_date_unix_string.to_i + 10000000)
    @currency = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}"

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
        puts "cash_back_multiplier from ELSE: #{cash_back_multiplier}"
    end
    
    puts "#{$current_user_id}, #{@purchase.to_s}, #{@cashback.to_s}, #{@purchase_date}, #{@currency}, #{method}"
    
    # create transcation
    @order_id_from_server = @api_page.create_transaction("#{$current_user_id}",  @purchase.to_s, @cashback.to_s, @purchase_date, @currency, method)

    if expect_or_not == 'expect'
        puts "@cashback.to_f:#{@cashback.to_f} @purchase#{@purchase} cash_back_multiplier#{cash_back_multiplier} up_to_100#{up_to_100}"
        currency_namewith (@cashback.to_f + ((@cashback.to_f / @purchase) * cash_back_multiplier * up_to_100).round(2)).round(2)
        
        puts "User Should get double cashback: #{@cashback.to_f} => #{@cashback_earned_after_multiplier}"
   
    elsif expect_or_not == 'dont expect'
        @cashback_earned_after_multiplier = @cashback.to_f
        puts "User Should not get double cashback: #{@cashback_earned} => #{@cashback_earned_after_multiplier}"
    end

    @wallet_page.transactions_validation('Tracked', @description, 'cashback', @purchase_date_unix_string, nil, @purchase.to_f, @cashback_earned_after_multiplier)

    # @wallet_page.set_current_balances
    if method == 'loaded'
        
        # validate change in 'Tracked cashback' state, only 'Tracked cashback' shlould change
        # Updated 'Tracked cashback' should be: tracked_cashback +  @cashback_earned_after_multiplier
        $tracked_cashback = ($tracked_cashback + $cashback_earned_after_multiplier).round(2)
        @wallet_page.validate_changes_in_current_balances
    else
        $available_to_withdraw = ($available_to_withdraw.to_f + @cashback_earned_after_multiplier).round(2)
        @wallet_page.validate_changes_in_current_balances
    end

    if VALIDATION[:check_notification]
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification "Your recent purchase at #{@retailer_name} has been successfully tracked" from the Web App
            And I take snapshot of the screen
        }
    end

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "weve_tracked_the_cashback_from_your_recent_purchase_at"  
        }
    end
end

Given /^I make a transaction using "(.*?)" for "(.*?)" pounds and I get "(.*?)" pounds cashback and I "(.*?)" to double cashback$/ do |provider, purchase, cashback, expect_or_not|
    @create_transaction_using_server = false
    @purchase = purchase.to_f
    @purchase_in_penny = @purchase * 100
    @cashback = cashback.to_f
    @cashback_in_penny = @cashback * 100
    @purchase_date_unix_string = @file_service.get_from_file('purchase_date_unix:')
    @file_service.insert_to_file('purchase_date_unix:', @purchase_date_unix_string.to_i + 10000000)
    
    if provider == 'Incentive Networks'
        @description = 'Shop Online :'
    elsif provider == 'BAT'
        @description = 'Book A Table :'
    else
        @description = 'Bownty :'
    end
        
    if @purchase > 100
      up_to_100 = 100
    else
      up_to_100 = @purchase
    end
    if $user_clicked
        cash_back_multiplier = @cash_back_multiplier_after_click
    else
        comapany = @api_page.get_company($current_user_company_id)
        if provider == 'Incentive Networks'
            cash_back_multiplier = @api_page.get_cashback_value_from_feature_list(comapany, 'benefit_cashback_bonus_incentive_networks_multiple_proc').to_f
        elsif provider == 'bownty'
            cash_back_multiplier = @api_page.get_cashback_value_from_feature_list(comapany, 'benefit_cashback_bonus_bownty_multiple_proc').to_f
        end
    end

    # create transcation
    # If transaction is Book a table the given cashback is after calculation and for that reason calculate the original cashback
    if provider == 'BAT'
        @cashback_in_penny = 100 * @cashback / $base_value.to_f
        result_json = @api_page.insert_transaction_cashback(provider, @restaurant_id , $current_user_id, @purchase_date_unix_string, @purchase_in_penny, @cashback_in_penny)
    elsif provider == 'Bownty'
        result_json = @api_page.insert_transaction_cashback(provider, @deal_id, $current_user_id, @purchase_date_unix_string, @purchase_in_penny, @cashback_in_penny, @retailer_name)
    elsif provider == 'Incentive Networks'
        result_json = @api_page.insert_transaction_cashback(provider, @retailer_id, $current_user_id, @purchase_date_unix_string, @purchase_in_penny, @cashback_in_penny, @retailer_name)
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

    # sleep(30)
    puts "$tracked_cashback:#{$tracked_cashback} cashback_earned_after_multiplier:#{@cashback_earned_after_multiplier}"
    $tracked_cashback = ($tracked_cashback + @cashback_earned_after_multiplier).round(2)
 
    @wallet_page.transactions_validation('Tracked', @description ,'cashback', @purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)

    # validate change in 'Tracked cashback' state, only 'Tracked cashback' shlould change
    # Updated 'Tracked cashback' should be: tracked_cashback +  @cashback_earned_after_multiplier
    @wallet_page.validate_changes_in_current_balances
        
    if VALIDATION[:check_notification]
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification "Your recent purchase at #{@retailer_name} has been successfully tracked" from the Web App
            And I take snapshot of the screen
        }
    end

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "weve_tracked_the_cashback_from_your_recent_purchase_at"  
        }
    end
end

When /^I am back to the wallet screen$/ do
    @browser.goto $HERMES
    steps %Q{
        And I click "Wallet" from the "Global Action" menu
    }
end

When /^I ask for cashback and it was declined$/ do
    
    # After the next call to the API the cashback request will have Declined state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will not change their value.
    @api_page.update_transaction_cashback($current_user_id, @transaction_id, 4)
    
    $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)                      
    @wallet_page.transactions_validation('Declined', @description, 'cashback', @purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)
    @cashback_earned_after_multiplier = 0.0

    @wallet_page.validate_changes_in_current_balances
    if VALIDATION[:check_notification]
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification "Your recent purchaseat .* has unfortunatley been declined" from the Web App
            And I take snapshot of the screen
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "your_cashback_has_been_declined"  
    }
    end
end

Then /^the cashback request "(.*?)" was approved using the server$/ do |method|
    
    # After the next call to the API the cashback request will have Confiremd state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will change their value.
    @api_page.create_transaction("#{$current_user_id}",  @purchase.to_s, @cashback.to_s, @purchase_date, @currency, method)
    
    @wallet_page.transactions_validation('Confirmed', @description, 'cashback', @purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)
    # validate change in 'Tracked cashback' and 'Available to withdraw' state
    # Updated 'Tracked Cashback' should be: tracked_cashback - @cashback_earned_after_multiplier
    # Updated 'Available to withdraw' should be: tracked_cashback + @cashback_earned_after_multiplier
    
    $available_to_withdraw = ($available_to_withdraw + @cashback_earned_after_multiplier).round(2)
    $tracked_cashback = ($tracked_cashback - @cashback_earned_after_multiplier).round(2)
    
    @wallet_page.validate_changes_in_current_balance
    
    if VALIDATION[:check_notification]
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification ".#{sprintf('%.2f', @cashback_earned_after_multiplier)} cashback from #{@retailer_name} has been approved and is now in your wallet" from the Web App
            And I take snapshot of the screen
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "Your cashback from [retailer_name] has been confirmed"   
        }
    end
end

Then /^I ask for cashback$/ do
    # After the next call to the API the cashback request will have Confiremd state, therefor 'Available to withdraw' and 'Tracked cashback'
    # will change their value.
    
    @api_page.update_transaction_cashback($current_user_id, @transaction_id)

    @wallet_page.transactions_validation('Confirmed', @description, 'cashback', @purchase_date_unix_string, @purchase.to_f, @cashback_earned_after_multiplier)

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
            When I open Notification from the Web App menu
            Then I check that this user got the next notification ".#{sprintf('%.2f', @cashback_earned_after_multiplier)} cashback from #{@retailer_name} has been approved and is now in your wallet" from the Web App
            And I take snapshot of the screen
        }
    end

    if VALIDATION[:check_email]
        steps %Q{                                     
            Then I recived an email with the subject "Your cashback from [retailer_name] has been confirmed"   
        }
    end
end

Then /^I raise claim$/ do
    @wallet_page.raise_clime

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "cashback_query_received"
        }
    end
end

And /^I request to withdrew to my "(.*?)" using the API$/ do |paypal_or_bank|
    user_token = @api_page.get_user_token($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password])
    @withdrew_transaction_id = @api_page.create_user_withdrawal($current_user_email, ACCOUNT[:"#{$account_index}"][:valid_account][:password], @method, user_token)
    @paypal_or_bank = paypal_or_bank

    @temp_available_to_withdraw = $available_to_withdraw
    puts "@temp_available_to_withdraw:#{@temp_available_to_withdraw}"

    if (/An error occurred; Cannot withdraw available amount. Below minimum amount authorized./.match @withdrew_transaction_id) != nil
        @withdraw_error_less_then_501 = true
    else
        @wallet_page.transactions_validation('Requested', @description, 'withdrawal', nil, nil, $available_to_withdraw, @paypal_or_bank)
        $available_to_withdraw = 0.0
    end
    
    if VALIDATION[:check_notification]
        puts "Your cashback withdrawal has been received and will be tansferred via your chosen payment method shortly"
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification "Your cashback withdrawal has been received and will be tansferred via your chosen payment method shortly" from the Web App
            And I take snapshot of the screen
        }
    
    elsif VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "cashback_withdrawal_received"     
        }
    end
    
    @wallet_page.validate_changes_in_current_balances
end

And /^I validate that "(.*?)" "(.*?)" are in available to withdraw$/ do |amount,currency_name|
    puts "$available_to_withdraw:#{$available_to_withdraw}"
    $available_to_withdraw = $available_to_withdraw + amount.to_i
    puts "$available_to_withdraw:#{$available_to_withdraw}"
    @wallet_page.validate_changes_in_current_balances
    @cashback_earned_after_multiplier = amount
end

And /^the withdrew request was "(.*?)" using the API$/ do |approve_or_decline|
    @api_page.approve_or_decline_withdraw(@withdrew_transaction_id, approve_or_decline)
    @temp_available_to_withdraw = $available_to_withdraw

    # validate change in 'Withdrawn to date' and 'Available to withdraw' state
    if approve_or_decline == 'approve'
        @wallet_page.transactions_validation('Confirmed', @description, 'withdrawal', nil, nil, @temp_available_to_withdraw, @paypal_or_bank)

        # Updated 'Withdrawn to date' should be: withdrawn_to_date + @cashback_earned_after_multiplier
        # Updated 'Available to withdraw' should be: 0
        $withdrawn_to_date = ($withdrawn_to_date + @temp_available_to_withdraw).round(2)
       
        if VALIDATION[:check_notification]
            puts "Your cashback withdrawal has been confirmed and will be available shortly"
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
        
    # 'Withdrawn to date' and 'Available to withdraw' should not change
    elsif approve_or_decline == 'decline'
        $available_to_withdraw = @temp_available_to_withdraw
        @wallet_page.transactions_validation('state state-9', @description, 'withdrawal', nil, nil, $available_to_withdraw, @paypal_or_bank)
         $available_to_withdraw = @temp_available_to_withdraw
    
        if VALIDATION[:check_email]
            puts "Your cashback withdrawal has been decline .*"
            steps %Q{
                Then I recived an email with the subject "cashback_withdrawal_failed"
            }
        end
    end

    @wallet_page.validate_changes_in_current_balances
end

And /^I request to withdrew to the "(.*?)" account using the Web App$/ do |paypal_or_bank|
    @browser.div(:class, 'page').send_keys :space
    sleep(0.2)
    @browser.div(:class, 'page').send_keys :space
    sleep(0.2)
    
    @paypal_or_bank = paypal_or_bank
    
    if @paypal_or_bank == 'Paypal'
        @wallet_page.request_withdrew_paypal_web_app
    elsif @paypal_or_bank == 'Bacs'
        @wallet_page.request_withdrew_bank_web_app
    end

    if VALIDATION[:check_notification]
        puts 'Your cashback withdrawal has been received and will be tansferred via your chosen payment method shortly'
        steps %Q{
            When I open Notification from the Web App menu
            Then I check that this user got the next notification "Your cashback withdrawal has been received and will be tansferred via your chosen payment method shortly" from the Web App
            And I take snapshot of the screen
        }
    end

    if VALIDATION[:check_email]
        steps %Q{
            Then I recived an email with the subject "cashback_withdrawal_received"
        }
    end

    @browser.div(:class, 'page').send_keys [:command, :up]
    sleep(0.2)
end

And /^the withdrew request was "(.*?)" by Arch user$/ do |approve_or_decline|
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
        And I get back to wallet
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
        @wallet_page.transactions_validation('Confirmed', @description, 'withdrawal', nil, $available_to_withdraw, @cashback_earned_after_multiplier, @paypal_or_bank)

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

And /^I get back to wallet$/ do
    @browser.goto $HERMES
    sleep(2)
    steps %Q{
        Then I click "Wallet" from the "Global Action" menu
        #And I am on the Your Wallet screen
    }
end

And /^the withdrew request was decline$/ do
    if @withdraw_error_less_then_501
        puts "Available to withdraw is less then 5 pounds can't withdraw"
    else
        fail(msg = 'Error. Withdraw request was needed to fail because the Available to withdraw should be less then 5 pounds')
    end
end

And /^I reset time to be as before the change$/ do
    @purchase_date_unix_string = @file_service.get_from_file('purchase_date_unix:')
    @file_service.insert_to_file('purchase_date_unix:', @purchase_date_unix_string.to_i - 10000000)
end

And /^the user make a purchase in "(.*?)" of "(.*?)"$/ do |platform, purchase_amount|
    $purchase_amount_incentive_networks = 0
    $purchase_amount_bownty = 0

    steps %Q{
        Given I am on the Web App Login screen
        When I insert valid email and password
        Then I am login to Web App
        And I click "Wallet" from the "Global Action" menu
        And I am on the Your Wallet screen
        And the company feature for "base Incentive Networks" changed to "1"
        And the company feature for "bonus Incentive Networks" changed to "1"
    }
    $purchase_amount_bownty = 0
    $purchase_amount_incentive_networks = 0

    if platform == 'Daily Deals'
        @description = 'Daily Deals'
        $purchase_amount_bownty = purchase_amount.to_f
        steps %Q{
            And I click on the "deal" link
            Given I make a transaction using "bownty" for "#{$purchase_amount_bownty}" pounds and I get "5" pounds cashback and I "expect" to double cashback
        }
    elsif platform == 'Shop Online'
        puts "SHOP ONLINE: purchase_amount-#{purchase_amount}"
        @description = 'Shop Online :'
        $purchase_amount_incentive_networks = purchase_amount.to_f
        steps %Q{
            When I click on the "retailer" link
            Given I make a transaction using "Incentive Networks" for "#{$purchase_amount_incentive_networks}" pounds and I get "5" pounds cashback and I "expect" to double cashback
        }
    end

    steps %Q{
        When I ask for cashback
        Then I request to withdrew to the "Paypal" account using the Web App
        And the withdrew request was "approve" by Arch user
        And I click "Logout" from the "Global Action" menu
    }
end

And /^the company feature for "(.*?)" changed to "(.*?)"$/ do |benefit, rate|
    perks_cashback_value_array = {
        'benefit_cashback_bonus_incentive_networks_multiple_proc' => 1,
        'benefit_cashback_base_incentive_networks_multiple_proc' => 1,
        'benefit_cashback_base_bownty_multiple_proc' => 1,
        'benefit_cashback_bonus_bownty_multiple_proc' => 1,
        'benefit_cashback_base_book_a_table_multiple_proc' => 1
    }

    case benefit
    when 'Base Incentive Networks'
        perks_cashback_value_array['benefit_cashback_base_incentive_networks_multiple_proc'] = rate
    when 'Bonus Incentive Networks'
        puts "Bonus Incentive Networks:#{rate}"
        perks_cashback_value_array['benefit_cashback_bonus_incentive_networks_multiple_proc'] = rate
    when 'Base Bownty'
        perks_cashback_value_array['benefit_cashback_base_bownty_multiple_proc'] = rate
    when 'Bonus Bownty'
        perks_cashback_value_array['benefit_cashback_bonus_bownty_multiple_proc'] = rate
    when 'Base Book A Table'
        perks_cashback_value_array['benefit_cashback_base_book_a_table_multiple_proc'] = rate
        $base_value = rate.to_f
    else
      fail(msg = "change_company_feature. Unvalid ket. Key value is:#{benefit}")
    end

    @api_page.set_all_company_features($current_user_company_id, $COMPANY_PACKAGE_ID, true, perks_cashback_value_array)
end

And /^I click on the "(.*?)" link$/ do |provider|
    @api_page = Api.new  
    @file_service = FileService.new

    if provider == 'deal'
        @api_page.click_on_retailer_offer($current_user_id, @deal_id, 'bownty')
    elsif provider == 'retailer'
        @api_page.click_on_retailer_offer($current_user_id, @retailer_id, 'Incentive Networks')
    end

    comapany = @api_page.get_company($current_user_company_id)
    @cash_back_multiplier_after_click = @api_page.get_cashback_value_from_feature_list(comapany, 'benefit_cashback_bonus_incentive_networks_multiple_proc').to_f
    $user_clicked = true
end

And /^the money was withdrew automatically$/ do
    @withdrew_automatically = true
    @method = 'bacs'
    @api_page.automatic_withdrew
    $available_to_withdraw_befor_withdrew_automatically = $available_to_withdraw 
    $available_to_withdraw = 0.0
    @wallet_page.validate_changes_in_current_balances
end


Then /^I return a product worth "(.*?)" pounds that was related to my previous purchase$/ do |return_value|
    @api_page = Api.new 
    @api_page.create_transaction("#{$current_user_id}", '-5', '-2', @purchase_date, @currency, 'payment_completed', @order_id_from_server)
end

And /^I make "(.*?)" purchase in Shop Online$/ do |counter|
    for i in 1..counter.to_i
        steps %Q{
            And I click "Wallet" from the "Global Action" menu
            And I am on the Your Wallet screen
            And the company feature for "base Incentive Networks" changed to "1"
            And the company feature for "bonus Incentive Networks" changed to "1"
            And I click on the "retailer" link

            Given I make a transaction using "Incentive Networks" for "100" pounds and I get "10" pounds cashback and I "expect" to double cashback
            When I ask for cashback
            Then I request to withdrew to my "Paypal" using the API
            And the withdrew request was "approve" using the API
            And I click "Withdraw" from the Wallet screen
        }
    end
end

And /^I click "(.*?)" from the Wallet screen$/ do |button|
    @wallet_page.click_button(button)
end