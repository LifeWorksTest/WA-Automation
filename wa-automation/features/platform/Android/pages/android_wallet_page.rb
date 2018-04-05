# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidWalletPage < Calabash::ABase
	
	TXV_WITHDRAW = "* id:'psts_tab_title' marked:'Withdraw'"
	
	TXV_TRANSACTIONS = "* id:'psts_tab_title' marked:'Transactions'"

	TXV_DONE = "* id:'view_toolbar_wrapper_toolbar' android.widget.TextView marked:'Done'"

  BTN_DONE = "android.widget.Button marked:'Done'"

	def trait
		"* id:'view_toolbar_wrapper_root' TextView marked:'Wallet'"
  end

  def is_visible (page)
  	case page
  	when 'Withdraw'
  		wait_for(:timeout => 30){element_exists(TXV_WITHDRAW)}
  		wait_for(:timeout => 30){element_exists(TXV_TRANSACTIONS)}

  		scroll_up
  		sleep(0.5)

  		wait_for(:timeout => 30){element_exists("TextView marked:'Withdrawn to Date'")}
  		wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Tracked'")}
  		wait_for(:timeout => 30){element_exists("TextView marked:'Available to Withdraw'")}
  		
  		scroll_down
  		sleep(0.5)
  		wait_for(:timeout => 30){element_exists("TextView marked:'PayPal'")}
  		wait_for(:timeout => 30){element_exists("TextView marked:'Bank Account'")}
  		scroll_up 
  		sleep(0.5)
  	when 'Transactions'
      sleep(2)
  	end
  end

  def click_button (button)
  	case button
  	when 'Withdraw'
  		wait_for(:timeout => 30){element_exists(TXV_WITHDRAW)}
  		touch(TXV_WITHDRAW)
  		is_visible('WITHDRAW')
  	when 'Transactions'
  		wait_for(:timeout => 30){element_exists(TXV_TRANSACTIONS)}
  		touch(TXV_TRANSACTIONS)
  		sleep(0.5)
  		is_visible('Transactions')  		
  	when 'Refresh'
  		perform_action('drag', 50, 50, 40, 70, 5)
  		sleep(1)
  	when 'Withdraw money'
  		wait_for(:timeout => 30){element_exists(TXV_WITHDRAW)}
  		touch(TXV_WITHDRAW)
  		sleep(0.5)
  		wait_for(:timeout => 30){element_exists(TXV_DONE)}
  	when 'DONE'
  		wait_for(:timeout => 30){element_exists(TXV_DONE)}
  		touch(TXV_DONE)
  		sleep(1)
    when 'Done'
      wait_for(:timeout => 30){element_exists(BTN_DONE)}
      touch(BTN_DONE)
      sleep(1)
  	else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Set current balances accurding the WITHDRAWN screen
  def set_current_balances
  	$withdrawn_to_date = query("TextView marked:'Withdrawn to Date' sibling TextView")[0]['text'].delete('£$').delete(',').to_f
		$tracked_cashback = query("TextView marked:'Cashback Tracked' sibling TextView")[0]['text'].delete('£$').delete(',').to_f
		$available_to_withdraw = query("TextView marked:'Available to Withdraw' sibling TextView")[0]['text'].delete('£$').delete(',').to_f
		# @paypal_amount = query("* id:'layout_card_container' index:0 child * TextView")[0]['text'].delete('£$').delete(',').to_f
		# @bank_amount = query("* id:'layout_card_container' index:1 child * TextView")[0]['text'].delete('£$').delete(',').to_f
	end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user purchase
  # @param purchase_date_unix
  # @param purchase_amount
  # @param cashback_earned
  def validate_cashback_tracked (purchase_date_unix, purchase_amount, cashback_earned)
    click_button('Transactions')
    click_button('Refresh')

    touch("* id:'icon'")
    wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Tracked'")}
    puts "Unix Time #{purchase_date_unix.to_i}"
    puts "#{"TextView marked:'#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %B %Y").to_s}'"}"
    # wait_for(:timeout => 30){element_exists("TextView marked:'#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %B %Y").to_s}'")}

    purchase_amount_from_wallet = query("TextView marked:'Purchase amount' sibling *")[0]['text'].delete('£$').delete(',').to_f

    if purchase_amount_from_wallet != purchase_amount 
      fail(msg = "Error. validate_cashback_tracked. Purchase amount (#{purchase_amount}) is not equal to purchase amount from wallet (#{purchase_amount_from_wallet})")
    end
    
    cashback_earned_from_wallet = query("TextView index:6")[0]['text'].delete('£$').delete(',').to_f 

    if cashback_earned_from_wallet != cashback_earned
      fail(msg = "Error. validate_cashback_tracked. Cashback earned (#{cashback_earned}) is not equal to cashback earned from wallet (#{cashback_earned_from_wallet})")
    end

    # cashback_rate = @BROWSER.table.tbody.tr.td(:index, 4).text[0..-2].to_f
    # if ((cashback_earned_from_wallet.to_f / purchase_amount_from_wallet.to_f) * 100).round(2) != cashback_rate
    #   fail(msg = "Error. validate_cashback_confirmed. Cashback rate should be #{((cashback_earned_from_wallet.to_f / purchase_amount_from_wallet.to_f) * 100).round(2)} and not #{cashback_rate}")
    # end
    press_back_button
    sleep(0.5)
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user purchase was confiremd or declined
  # @param purchase_date_unix
  # @param purchase_amount
  # @param cashback_earned
  def validate_cashback_confirmed_or_declined (purchase_date_unix, purchase_amount, cashback_earned, status = 'approve')
   	click_button('Transactions')
    click_button('Refresh')

    touch("* id:'icon'")
    if status == 'decline'
    	wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Declined'")}
    else 
    	wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Confirmed'")}
    	# wait_for(:timeout => 30){element_exists("TextView marked:'#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %B %Y").to_s}'")}
    	purchase_amount_from_wallet = query("TextView marked:'Purchase amount' sibling *")[0]['text'].delete('£$').delete(',').to_f

    	if purchase_amount_from_wallet != purchase_amount 
      	fail(msg = "Error. validate_cashback_tracked. Purchase amount (#{purchase_amount}) is not equal to purchase amount from wallet (#{purchase_amount_from_wallet})")
    	end
    
   	 	cashback_earned_from_wallet = query("TextView index:6")[0]['text'].delete('£$').delete(',').to_f 
    
    	if cashback_earned_from_wallet != cashback_earned
      	fail(msg = "Error. validate_cashback_tracked. Cashback earned (#{cashback_earned}) is not equal to cashback earned from wallet (#{cashback_earned_from_wallet})")
    	end
    end
    
    press_back_button
    sleep(0.5)
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user requested to Withdraw and it was confirm or decline
  # @param method
  # @param cashback_earned
  def validate_withdraw_requsted (method, cashback_earned)
    click_button('Transactions')
    click_button('Refresh')

    if method == 'Paypal'
    	wait_for(:timeout => 30){element_exists("TextView marked:'Paypal withdraw'")}
    elsif method == 'Bacs'
    	wait_for(:timeout => 30){element_exists("TextView marked:'Bank withdraw'")}
    end
    
    touch("* id:'icon'")
	  wait_for(:timeout => 30){element_exists("TextView marked:'Withdraw Requested'")}
    wait_for(:timeout => 30){element_exists("TextView marked:'#{Time.new.strftime("%d %B %Y")}'")}
    withdraw_amount_from_wallet = query("TextView marked:'Withdraw amount' sibling *")[0]['text'].delete('£$').delete(',').to_f 
    if withdraw_amount_from_wallet != cashback_earned
      fail(msg = "Error. validate_Withdraw_requsted. Withdraw amount (#{cashback_earned}) is not equal to Withdraw amount from wallet (#{withdraw_amount_from_wallet})")
    end

    press_back_button
    sleep(0.5)
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user requested to Withdraw was confirm or decline
  # @param purchase_amount
  # @param cashback_earned
  # @param status - 'confirm' or 'decline'
  def validate_withdraw_confirm_or_decline (method, cashback_earned, status)
    click_button('Transactions')
    click_button('Refresh')

    if method == 'Paypal'
    	wait_for(:timeout => 30){element_exists("TextView marked:'Paypal withdraw'")}
    elsif method == 'Bacs'
    	wait_for(:timeout => 30){element_exists("TextView marked:'Bank withdraw'")}
    end
    
    touch("* id:'icon'")
    
    if status == 'approve'
      wait_for(:timeout => 30){element_exists("TextView marked:'Withdraw Confirmed'")}
    elsif status == 'decline'
      wait_for(:timeout => 30){element_exists("TextView marked:'Withdraw Failed'")}
    end
	  
    wait_for(:timeout => 30){element_exists("TextView marked:'#{Time.new.strftime("%d %B %Y")}'")}
    withdraw_amount_from_wallet = query("TextView marked:'Withdraw amount' sibling *")[0]['text'].delete('£$').delete(',').to_f 
    if withdraw_amount_from_wallet != cashback_earned
      fail(msg = "Error. validate_Withdraw_requsted. Withdraw amount (#{cashback_earned}) is not equal to Withdraw amount from wallet (#{withdraw_amount_from_wallet})")
    end

    press_back_button
    sleep(0.5)
  end

  

  # Validate the the current balances in the withdraw screen are update accourding to the given value
  # @param available_to_withdraw - if not null value was change and validate accouring this value
  # @param tracked_cashback - if not null value was change and validate accouring this value
  # @param withdrawn_to_date - if not null value was change and validate accouring this value
  def validate_changes_in_current_balances
    click_button('Withdraw')
    
    wait_for(:timeout => 30){element_exists("TextView marked:'Available to Withdraw' sibling TextView")}
    available_to_withdraw_from_balance = query("TextView marked:'Available to Withdraw' sibling TextView")[0]['text'].delete('£$').delete(',').to_f
    if $available_to_withdraw != available_to_withdraw_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Available to withdraw value in balance is #{available_to_withdraw_from_balance} and expected to #{$available_to_withdraw}")
    end

    wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Tracked' sibling TextView")}
    tracked_cashback_from_balance = query("TextView marked:'Cashback Tracked' sibling TextView")[0]['text'].delete('£$').delete(',').to_f
    if $tracked_cashback != tracked_cashback_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Tracked cashback value in balance is #{tracked_cashback_from_balance} and expected to #{$tracked_cashback}")
    end

    wait_for(:timeout => 30){element_exists("TextView marked:'Withdrawn to Date' sibling TextView")}
    withdrawn_to_date_from_balance = query("TextView marked:'Withdrawn to Date' sibling TextView")[0]['text'].delete('£$').delete(',').to_f
    if $withdrawn_to_date != withdrawn_to_date_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Withdrawn to date balance is #{withdrawn_to_date_from_balance} and expected to #{$withdrawn_to_date}")
    end
  end

  # Request withdrew using paypal account using the Android app
  def request_withdrew_paypal_android
  	is_visible('Withdraw')
  	scroll_down
  	sleep(0.5)

  	paypal_amount = query("* id:'layout_card_container' index:0 child * TextView")[0]['text'].delete('£$').delete(',').to_f
  	touch("TextView marked:'PayPal'")
  	sleep(0.5)

  	if paypal_amount < 5.01
  		wait_for(:timeout => 30){element_exists("* id:'buttonDefaultPositive'")}
  		touch("* id:'buttonDefaultPositive'")
  		wait_for_element_does_not_exist("* id:'buttonDefaultPositive'")
  		$withdraw_error_less_then_501 = true
  	else

  		wait_for(:timeout => 30){element_exists("TextView marked:'Check details and confirm'")}

	  	if query("TextView marked:'Total to Withdraw' sibling *")[0]['text'].delete('£$').delete(',').to_f < 5.1
	  		fail(msg = "Error. request_withdrew_paypal_web_app. User should not be able to withdraw amount that is less then 5.1")
	  	end

	  	enter_text("android.widget.EditText", ACCOUNT[:"#{$account_index}"][:valid_account][:password])
	  	sleep(0.5)

	  	click_button('DONE')
	  	wait_for(:timeout => 30){element_exists("* id:'alertTitle' marked:'PayPal Withdraw'")}
	  	click_button('Done')
	  end
  end

  # Request withdrew using bank account using the Android app
  def request_withdrew_bank_android
  	scroll_down
  	sleep(0.5)
  	touch("TextView marked:'Bank Account'")
  	sleep(0.5)
  	wait_for(:timeout => 30){element_exists("TextView marked:'Check details and confirm'")}

  	if query("TextView marked:'Total to Withdraw' sibling *")[0]['text'].delete('£$').delete(',').to_f < 5.1
  		fail(msg = "Error. request_withdrew_paypal_web_app. User should not be able to withdraw amount that is less then 5.1")
  	end

  	enter_text("android.widget.EditText", ACCOUNT[:"#{$account_index}"][:valid_account][:password])
  	sleep(0.5)

  	click_button('DONE')
  	wait_for(:timeout => 30){element_exists("* id:'alertTitle' marked:'Bank Account Withdraw'")}
  	click_button('Done')
  end

  # Raise clime
  def raise_clime
  	click_button('Transactions')
    click_button('Refresh')

    touch("* id:'icon'")
  	wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Declined'")}
  	touch("TextView marked:'Cashback Declined'")
  	wait_for(:timeout => 30){element_exists("button marked:'Raise Claim'")}
  	touch("button marked:'Raise Claim'")
  	enter_text("android.widget.EditText index:0", 'This is the my query')
  	wait_for(:timeout => 30){element_exists("TextView id:'actionbar_DONE_inner'")}
  	touch("TextView id:'actionbar_DONE_inner'")
  	wait_for_element_does_not_exist("TextView id:'actionbar_DONE_inner'")
  	click_button('Refresh')

  	touch("* id:'icon'")
  	wait_for(:timeout => 30){element_exists("TextView marked:'Cashback Claim Raised'")}
  end
end
