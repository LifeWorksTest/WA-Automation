# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSWalletPage < Calabash::IBase
  LBL_WALLET = "UINavigationBar marked:'#{IOS_STRINGS["WAMMenuItemWalletTitle"]}'"
  LBL_WITHDRAW = "label marked:'#{IOS_STRINGS["WAMWalletContainerWithdrawTitle"]}'"
  LBL_TRANSACTIONS = "label marked:'#{IOS_STRINGS["WAMWalletContainerTransactionsTitle"]}'"

  BTN_DONE = "button marked:'#{IOS_STRINGS["WAMFoundationDoneKey"]}'"
  BTN_CONTINUE = "button marked:'#{IOS_STRINGS["WAMFoundationContinueKey"]}'"
  BTN_WITHDRAW = "button marked:'#{IOS_STRINGS["WAMWalletContainerWithdrawTitle"]}'"

  def trait
    LBL_WALLET
  end

  def is_visible (page)
    case page
    when 'Withdraw'
      wait_for(:timeout => 30){element_exists(LBL_WITHDRAW)}
      wait_for(:timeout => 30){element_exists(LBL_TRANSACTIONS)}

      scroll("scrollView index:0", :up)
      sleep(0.5)

      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletWithdrawWithdrawnTitle"]}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletWithdrawTrackedTitle"]}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletWithdrawAvailableTitle"]}'")}
      
      scroll("scrollView index:0", :down)
      sleep(0.5)
      wait_for(:timeout => 30){element_exists("imageView id:'illu_paypal_logo'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletBACSTitle"]}'")}
      scroll("scrollView index:0", :up) 
      sleep(0.5)
    when 'Transactions'
      sleep(2)
    end
  end

  def click_button (button)
    case button
    when 'Withdraw button'
      wait_for(:timeout => 30){element_exists(BTN_WITHDRAW)}
      touch(BTN_WITHDRAW)
      wait_for(:timeout => 30){element_does_not_exist(BTN_WITHDRAW)}
    when 'Continue'
      wait_for(:timeout => 30){element_exists(BTN_CONTINUE)}
      touch(BTN_CONTINUE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_CONTINUE)}
    when 'Withdraw'
      wait_for(:timeout => 30){element_exists(LBL_WITHDRAW)}
      touch(LBL_WITHDRAW)
      is_visible('WITHDRAW')
    when 'Transactions'
      wait_for(:timeout => 30){element_exists(LBL_TRANSACTIONS)}
      touch(LBL_TRANSACTIONS)
      is_visible('Transactions')
      flick("scrollView", {x:0, y:50})
      sleep(2)
    when 'Done'
      sleep(3)
      wait_for(:timeout => 30){element_exists(BTN_DONE)}
      touch(BTN_DONE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_DONE)}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # set current balance
  def set_current_balances
    $withdrawn_to_date = query("label marked:'#{IOS_STRINGS["WAMWalletWithdrawWithdrawnTitle"]}' sibling label")[0]['text'].delete('£$').delete(',').to_f
    $tracked_cashback = query("label marked:'#{IOS_STRINGS["WAMWalletWithdrawTrackedTitle"]}' sibling label")[0]['text'].delete('£$').delete(',').to_f
    $available_to_withdraw = query("label marked:'#{IOS_STRINGS["WAMWalletWithdrawAvailableTitle"]}' sibling label")[0]['text'].delete('£$').delete(',').to_f
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user purchase
  # @param purchase_date_unix
  # @param purchase_amount
  # @param cashback_earned
  def validate_cashback_tracked (purchase_date_unix, purchase_amount, cashback_earned)
    click_button('Transactions')

    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * imageView index:0")}
    touch("UITableViewCellContentView index:0 * imageView index:0")
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsTrackedUnderDaysStateTitle"]}' ")}
    touch("button marked:'bt close white'")
    wait_for(:timeout => 30){element_does_not_exist("button marked:'bt close white'")}

    touch("UITableViewCellContentView index:0 * imageView index:1")
    puts "Unix Time #{purchase_date_unix.to_i}"
    puts "#{"label marked:'#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %b %Y").to_s}'"}"
    wait_for(:timeout => 30){element_exists("label marked:'#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %b %Y").to_s}'")}

    purchase_amount_from_wallet = query("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailPurchaseAmount"]}' sibling *")[0]['text'].delete('£$').delete(',').to_f

    if purchase_amount_from_wallet != purchase_amount 
      fail(msg = "Error. validate_cashback_tracked. Purchase amount (#{purchase_amount}) is not equal to purchase amount from wallet (#{purchase_amount_from_wallet})")
    end
    
    cashback_earned_from_wallet = query("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailCashbackEarned"]}' sibling *")[0]['text'].delete('£$').delete(',').to_f

    if cashback_earned_from_wallet != cashback_earned
      fail(msg = "Error. validate_cashback_tracked. Cashback earned (#{cashback_earned}) is not equal to cashback earned from wallet (#{cashback_earned_from_wallet})")
    end

    # cashback_rate = @BROWSER.table.tbody.tr.td(:index, 4).text[0..-2].to_f
    # if ((cashback_earned_from_wallet.to_f / purchase_amount_from_wallet.to_f) * 100).round(2) != cashback_rate
    #   fail(msg = "Error. validate_cashback_confirmed. Cashback rate should be #{((cashback_earned_from_wallet.to_f / purchase_amount_from_wallet.to_f) * 100).round(2)} and not #{cashback_rate}")
    # end
    
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user purchase was confiremd or declined
  # @param purchase_date_unix
  # @param purchase_amount
  # @param cashback_earned
  def validate_cashback_confirmed_or_declined (purchase_date_unix, purchase_amount, cashback_earned, status = 'approve')
    click_button('Transactions')

    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * imageView index:0")}
    touch("UITableViewCellContentView index:0 * imageView index:0")
    wait_for(:timeout => 30){element_exists("button marked:'bt close white'")}
    
    if status == 'decline'
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsDeclinedTitle"]}'")}
      touch("button marked:'bt close white'")
      wait_for(:timeout => 30){element_does_not_exist("button marked:'bt close white'")}
    else 
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionStateConfirmed"]}'")}
      touch("button marked:'bt close white'")
      wait_for(:timeout => 30){element_does_not_exist("button marked:'bt close white'")}

      wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * imageView index:1")}
      touch("UITableViewCellContentView index:0 * imageView index:1")
      puts "TIME:#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %b %Y").to_s}}"
      wait_for(:timeout => 30){element_exists("label marked:'#{Time.at(purchase_date_unix.to_i).to_date.strftime("%d %b %Y").to_s}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailPurchaseAmount"]}'")}
      purchase_amount_from_wallet = query("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailPurchaseAmount"]}' sibling *")[0]['text'].delete('£$').delete(',').to_f

      if purchase_amount_from_wallet != purchase_amount 
        fail(msg = "Error. validate_cashback_tracked. Purchase amount (#{purchase_amount}) is not equal to purchase amount from wallet (#{purchase_amount_from_wallet})")
      end
    
      cashback_earned_from_wallet = query("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailCashbackEarned"]}' sibling *")[0]['text'].delete('£$').delete(',').to_f
    
      if cashback_earned_from_wallet != cashback_earned
        fail(msg = "Error. validate_cashback_tracked. Cashback earned (#{cashback_earned}) is not equal to cashback earned from wallet (#{cashback_earned_from_wallet})")
      end
    end
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user requested to Withdraw and it was confirm or decline
  # @param method
  # @param cashback_earned
  def validate_withdraw_requsted (method, cashback_earned)
    click_button('Transactions')

    if method == 'Paypal'
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionWithdrawPaypal"]}'")}
    elsif method == 'Bacs'
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionWithdrawBank"]}'")}
    end
    
    touch("UITableViewCellContentView index:0 * imageView index:0")
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsWithdrawRequestedStateTitle"]}'")}
    wait_for(:timeout => 30){element_exists("button marked:'bt close white'")}
    touch("button marked:'bt close white'")
    wait_for(:timeout => 30){element_does_not_exist("button marked:'bt close white'")}

    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * imageView index:1")}
    touch("UITableViewCellContentView index:0 * imageView index:1")

    #TODO: To add date format
    #wait_for(:timeout => 30){element_exists("label marked:'#{Time.new.strftime("%d %b %Y")}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailWithdrawAmount"]}'")}
    withdraw_amount_from_wallet = query("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailWithdrawAmount"]}' sibling *")[0]['text'].delete('£$').delete(',').to_f 
    if withdraw_amount_from_wallet != cashback_earned
      fail(msg = "Error. validate_Withdraw_requsted. Withdraw amount (#{cashback_earned}) is not equal to Withdraw amount from wallet (#{withdraw_amount_from_wallet})")
    end
  end

  # Validate that all the currect date (Withdraw and Transaction screen) is in wallet after user requested to Withdraw was confirm or decline
  # @param purchase_amount
  # @param cashback_earned
  # @param status - 'confirm' or 'decline'
  def validate_withdraw_confirm_or_decline (method, cashback_earned, status)
    click_button('Transactions')

    if method == 'Paypal'
      wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * label marked:'#{IOS_STRINGS["WAMWalletTransactionWithdrawPaypal"]}' ")}
    elsif method == 'Bacs'
      wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * label marked:'#{IOS_STRINGS["WAMWalletTransactionWithdrawBank"]}' index:0")}
    end
    
    touch("UITableViewCellContentView index:0 * imageView index:0")
    
    if status == 'approve'
      if  method == 'Paypal'
        wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionWithdrawPaypal"]}'")}
      else 
        wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsWithdrawConfirmedStateTitle"]}'")}
      end
    elsif status == 'decline'
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsWithdrawFailedStateTitle"]}'")}
    end
    
    wait_for(:timeout => 30){element_exists("button marked:'bt close white'")}
    touch("button marked:'bt close white'")
    wait_for(:timeout => 30){element_does_not_exist("button marked:'bt close white'")}

    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:0 * imageView index:1")}
    touch("UITableViewCellContentView index:0 * imageView index:1")
    
    wait_for(:timeout => 30){element_exists("label marked:'#{Time.new.strftime("%m/%d/%Y")}'")}
    withdraw_amount_from_wallet = query("label marked:'#{IOS_STRINGS["WAMWalletTransactionDetailWithdrawAmount"]}' sibling *")[0]['text'].delete('£$').delete(',').to_f 
    
    if withdraw_amount_from_wallet != cashback_earned
      fail(msg = "Error. validate_Withdraw_requsted. Withdraw amount (#{cashback_earned}) is not equal to Withdraw amount from wallet (#{withdraw_amount_from_wallet})")
    end
  end

  # Validate the the current balances in the withdraw screen are update accourding to the given value
  # @param available_to_withdraw - if not null value was change and validate accouring this value
  # @param tracked_cashback - if not null value was change and validate accouring this value
  # @param withdrawn_to_date - if not null value was change and validate accouring this value
  def validate_changes_in_current_balances
    click_button('Transactions')
    click_button('Withdraw')
    sleep(2)

    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletWithdrawAvailableTitle"]}' sibling label")}
    available_to_withdraw_from_balance = query("label marked:'#{IOS_STRINGS["WAMWalletWithdrawAvailableTitle"]}' sibling label")[0]['text'].delete('£$').delete(',').to_f
    
    if $available_to_withdraw != available_to_withdraw_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Available to withdraw value in balance is #{available_to_withdraw_from_balance} and expected to #{$available_to_withdraw}")
    end

    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletWithdrawTrackedTitle"]}' sibling label")}
    tracked_cashback_from_balance = query("label marked:'#{IOS_STRINGS["WAMWalletWithdrawTrackedTitle"]}' sibling label")[0]['text'].delete('£$').delete(',').to_f
    
    if $tracked_cashback != tracked_cashback_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Tracked cashback value in balance is #{tracked_cashback_from_balance} and expected to #{$tracked_cashback}")
    end

    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletWithdrawWithdrawnTitle"]}' sibling label")}
    withdrawn_to_date_from_balance = query("label marked:'#{IOS_STRINGS["WAMWalletWithdrawWithdrawnTitle"]}' sibling label")[0]['text'].delete('£$').delete(',').to_f
    
    if $withdrawn_to_date != withdrawn_to_date_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Withdrawn to date balance is #{withdrawn_to_date_from_balance} and expected to #{$withdrawn_to_date}")
    end
  end

  # Request withdraw
  # @param option 'Withdraw'
  def request_withdraw (option)
    is_visible('Withdraw')
    scroll("scrollView index:0", :down)
    sleep(0.5)

    if option == 'Paypal'
      amount = query("imageView id:'illu_paypal_logo' parent * index:1 child label index:0")[0]['text'].delete('£$').delete(',').to_f
      touch("imageView id:'illu_paypal_logo'")
      sleep(0.5)
    else
      amount = query("imageView id:'illu_paypal_logo' parent * index:1 child label index:0")[0]['text'].delete('£$').delete(',').to_f
      touch("label marked:'#{IOS_STRINGS["WAMWalletBACSTitle"]}'")
      sleep(0.5)
    end

    if amount < 5.01
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")}
      touch("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")
      wait_for_element_does_not_exist("label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'")
      $withdraw_error_less_then_501 = true
    else

      wait_for(:timeout => 30){element_exists("UINavigationBar label marked:'#{IOS_STRINGS["WAMWalletContainerWithdrawTitle"]}'")}

      if query("label index:0")[0]['text'].delete('Amount to withdraw £$').delete(',').to_f < 5.1
        fail(msg = "Error. request_withdraw. User should not be able to withdraw amount that is less then 5.1")
      end

      click_button('Continue')
      wait_for(:timeout => 30){element_exists("button marked:'#{IOS_STRINGS["WAMWalletWithdrawReviewForgotPasswordButtonTitle"]}'")}
      wait_for(:timeout => 30){element_exists("textField")}
      sleep(2)
      touch("textField")
      wait_for_keyboard
      puts "PASSWORD: #{(ACCOUNT[:"#{$account_index}"][:valid_ios_account][:password])[0..-1]}."
      keyboard_enter_text("testtest456")
      tap_keyboard_action_key     
      sleep(0.5)

      click_button('Withdraw button')
      click_button('Done')
    end
  end

  # Raise clime
  def raise_clime
    click_button('Transactions')

    touch("UITableViewCellContentView index:0 * imageView index:0")
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsDeclinedTitle"]}'")}
    wait_for(:timeout => 30){element_exists("button marked:'#{IOS_STRINGS["WAMWalletTransactionsDeclinedButtonTitle"]}'")}
    sleep(1)
    touch("button marked:'#{IOS_STRINGS["WAMWalletTransactionsDeclinedButtonTitle"]}'")

    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionsDeclinedButtonTitle"]}'")}
    sleep(1)
    touch("label marked:'#{IOS_STRINGS["WAMWalletTransactionsDeclinedButtonTitle"]}'")

    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMWalletTransactionClaimRaisedTitle"]}'")}
    wait_for(:timeout => 30){element_exists("button marked:'bt close white'")}
    sleep(1)
    touch("button marked:'bt close white'")
    wait_for(:timeout => 30){element_does_not_exist("button marked:'bt close white'")}
  end
end