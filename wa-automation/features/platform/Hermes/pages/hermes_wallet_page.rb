# -*- encoding : utf-8 -*-
class HermesWalletPage

  def initialize (browser)
    @BROWSER = browser
    
    @BTN_WALLET = @BROWSER.div(:text, HERMES_STRINGS["wallet"]["title"])
    @BTN_TRANSACTIONS = @BROWSER.div(:text, HERMES_STRINGS["wallet"]["tx_title"])
    @BTN_WITHDRAWALS =  @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"])
    @BTN_DONE = @BROWSER.a(:text, HERMES_STRINGS["wallet"]["modal"]["withdrawal_common"]["done"])
  end

  def is_visible (page)
    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["available"]).parent.div(:text, HERMES_STRINGS["wallet"]["title"]).wait_until_present
    
    Watir::Wait.until {
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions_count_s"]).parent.div(:text, HERMES_STRINGS["wallet"]["tx_title"]).present? ||
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions_count"]).parent.div(:text, HERMES_STRINGS["wallet"]["tx_title"]).present?
    }

    Watir::Wait.until {
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_count_s"]).parent.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"]).present? ||
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_count"]).parent.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"]).present?
    }
    
    @BROWSER.div(:class => 'page', :text => /#{HERMES_STRINGS["wallet"]["earned"]}/).wait_until_present

    case page
    when 'Wallet'
      @BROWSER.div(:class => 'page', :text => /#{HERMES_STRINGS["wallet"]["wallet"]["title_1"]}/).wait_until_present
      @BROWSER.div(:class => 'page', :text => /#{HERMES_STRINGS["wallet"]["wallet"]["title_2"]}/).wait_until_present
      @BROWSER.div(:class => 'page', :text => /#{HERMES_STRINGS["wallet"]["wallet"]["tracking"]}/).wait_until_present
      @BROWSER.div(:class => 'page', :text => /#{HERMES_STRINGS["wallet"]["wallet"]["toDate"]}/).wait_until_present

      @BROWSER.div(:class => 'page',:text => /#{HERMES_STRINGS["wallet"]["wallet"]["options"]}/).wait_until_present
    
      withdraw_amount_available = @BROWSER.div(:text, HERMES_STRINGS["wallet"]["title"]).parent.div(:index, 1).text.to_f
      available_to_withdraw = @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["title_2"]).parent.parent.div(:index, 3).text.to_f

      if withdraw_amount_available != available_to_withdraw
        fail(msg = "Error. is_visible. Available to Withdraw amount is not equal: withdraw_amount_available #{withdraw_amount_available}, available_to_withdraw #{available_to_withdraw}")
      end

      youve_earned = (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["earned"]).parent.div(:index, 1).text).match(/(\d+\.\d+)/)[0].to_f
      withdrawn_to_date = (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["toDate"]).parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f
      available_to_withdraw_from_balance = (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["title_2"]).parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f

      if youve_earned != withdrawn_to_date + available_to_withdraw_from_balance
        #Need to remove comment when Cathleen will fix the bug 
        #fail(msg = "Error. is_visible. Withdraw To Date and earned amount is not equal: youve_earned #{youve_earned}, withdrawn_to_date #{withdrawn_to_date}")
      end
    when 'Withdrawals'
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"]).wait_until_present

      if @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"]).parent.div(:index, 1).text.to_i == 0
        @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions"]["title_1"]).wait_until_present
        
        @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions"]["empty_restaurants"]["title_1"]).wait_until_present
        @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions"]["empty_deals"]["title_1"]).wait_until_present
        @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions"]["empty_shop"]["title_1"]).wait_until_present
      else
        @BROWSER.table.thead(:text, /Withdraw Date Description Withdraw Amount Status/).wait_until_present
      end
    when 'Transactions'
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["tx_title"]).wait_until_present
      if @BROWSER.div(:text, HERMES_STRINGS["wallet"]["tx_title"]).parent.div(:index, 1).text.to_i == 0
        @BROWSER.div(:class, %w(wallet-transactions ng-scope)).section.h3(:text, ).wait_until_present

        @BROWSER.div(:class, %w(wallet-transactions ng-scope)).section.div(:class => 'item', :index => 0).div(:class => 'copy', :text => /#{HERMES_STRINGS["wallet"]["transactions"]["empty_shop"]["title_1"]}/).wait_until_present
        @BROWSER.div(:class, %w(wallet-transactions ng-scope)).section.div(:class => 'item', :index => 1).div(:class => 'copy', :text => /#{HERMES_STRINGS["wallet"]["transactions"]["empty_restaurants"]["title_1"]}/).wait_until_present
        @BROWSER.div(:class, %w(wallet-transactions ng-scope)).section.div(:class => 'item', :index => 2).div(:class => 'copy', :text => /#{HERMES_STRINGS["wallet"]["transactions"]["title_1"]}/).wait_until_present
      else                                                                          
        if ! @BROWSER.table.thead(:text, /Transaction Date Description Transaction Amount Cashback Earned Cashback Status/).exists?
          for i in 0..10
            @BTN_TRANSACTIONS.click
          end
        end
      end
    end
  end

  def click_button (button)
    case button
    when 'Wallet'
      @BROWSER.refresh
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["available"]).parent.div(:text, HERMES_STRINGS["wallet"]["title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["available"]).parent.div(:text, HERMES_STRINGS["wallet"]["title"]).click
      is_visible('Wallet')
    when 'Transactions'
      @BROWSER.refresh
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions_count_s"]).parent.div(:text, HERMES_STRINGS["wallet"]["tx_title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["transactions_count_s"]).parent.div(:text, HERMES_STRINGS["wallet"]["tx_title"]).click
      is_visible('Transactions')
    when 'Withdrawals'
      @BROWSER.refresh
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_count_s"]).parent.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["wallet"]["withdraws_count_s"]).parent.div(:text, HERMES_STRINGS["wallet"]["withdraws_title"]).click
      is_visible('Withdrawals')
    when 'Done'
      @BTN_DONE.wait_until_present
      @BTN_DONE.fire_event('click')
      @BTN_DONE.wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Validate that the currency in the page is uniform accurding to the given currency
  # @param currency
  def validate_currency_over_the_page (currency)
    (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["earned"]).parent.div(:index, 1).text).match(/(^[#{currency}])/)
    (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["toDate"]).parent.parent.div(:index, 3).text).match(/(^[#{currency}])/)
    (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["title_2"]).parent.parent.div(:index, 3).text).match(/(^[#{currency}])/)
  end

  # Validate the existing of the elements in 'What is my wallet'
  def validate_what_is_my_wallet
    @BROWSER.div(:class, %w(widget widget--aside ng-scope)).a(:class => 'link', :text => 'What is My Wallet?').wait_until_present
    @BROWSER.div(:class, %w(widget widget--aside ng-scope)).a(:class => 'link', :text => 'What is My Wallet?').click
    
    @BROWSER.div(:class, 'modal-dialog').div(:class, %w(item text-center ng-isolate-scope active)).h3(:text => /What is My Wallet?/).wait_until_present
    @BROWSER.div(:class, 'modal-dialog').div(:class, %w(item text-center ng-isolate-scope active)).p(:text, /Your wallet is where all your Cashback from online shopping and dining is/).wait_until_present

    @BROWSER.div(:class, 'modal-dialog').ol.li(:index, 1).click

    @BROWSER.div(:class, 'modal-dialog').div(:class, %w(item text-center ng-isolate-scope active)).h3(:text => /How do I withdraw my Cashback?/).wait_until_present
    @BROWSER.div(:class, 'modal-dialog').div(:class, %w(item text-center ng-isolate-scope active)).p(:text, /You can withdraw your Cashback from your wallet to your bank account or PayPal account./).wait_until_present

    @BROWSER.div(:class, 'modal-dialog').ol.li(:index, 2).click
    @BROWSER.div(:class, 'modal-dialog').div(:class, %w(item text-center ng-isolate-scope active)).h3(:text => /What is my transaction history?/).wait_until_present
    @BROWSER.div(:class, 'modal-dialog').div(:class, %w(item text-center ng-isolate-scope active)).p(:text, /Your transaction history displays all your purchases we've tracked and their state. Secure and easy to understand./).wait_until_present

    @BROWSER.a(:class, %w(modal__btn-close ng-scope)).wait_until_present
    @BROWSER.a(:class, %w(modal__btn-close ng-scope)).click
    @BROWSER.a(:class, %w(modal__btn-close ng-scope)).wait_while_present
  end

  def transactions_validation(state, description, cashback_or_withdrawl, purchase_date_unix, purchase_amount, cashback_earned, method = nil)
    curreny = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}"
    
    #Currently there is a bug in the logic we need the API team to fix the transaction date issue. 
    #Until then I will use the transaction date as today's date
    #purchase_date = Time.at(purchase_date_unix.to_i).to_date.strftime("%d/%m/%Y").to_s
    purchase_date = Time.new.strftime("%d/%m/%Y")
    cashback_earned = sprintf('%.2f', cashback_earned)
    
    index = 0
    row_was_found = false

    if cashback_or_withdrawl == 'cashback'
      cashback_rate = ((cashback_earned.to_f / purchase_amount.to_f) * 100).round(2)
      purchase_amount = sprintf('%.2f', purchase_amount)
      cashback_rate = sprintf("%g", cashback_rate)

      click_button('Transactions')
      
      if state == 'Declined'
        # row_to_match_with = "#{purchase_date}" + '\n' + "#{description}" + '\n' + "#{curreny}0.00" + '\n' + "#{curreny}#{purchase_amount}" + '\n' + "#{curreny}0.00" + '\n' + "#{curreny}#{cashback_earned}" + '\n' + "#{state}"
        row_to_match_with = "#{description}" + '\n' + "#{curreny}0.00" + '\n' + "#{curreny}#{purchase_amount}" + '\n' + "#{curreny}0.00" + '\n' + "#{curreny}#{cashback_earned}" + '\n' + "#{state}"
      else 
        #row_to_match_with = "#{purchase_date}" + '\n' + "#{description}" + '\n' + "#{curreny}#{purchase_amount}" + '\n' + "#{curreny}#{cashback_earned}" + '\n' + "#{state}"
        row_to_match_with = "#{description}" + '\n' + "#{curreny}#{purchase_amount}" + '\n' + "#{curreny}#{cashback_earned}" + '\n' + "#{state}"
      end
     
      while @BROWSER.table.tbody(:index, index).exists? && !row_was_found
        
        if @BROWSER.table.tbody.tr(:text, /#{row_to_match_with}/).present?
          row_was_found = true
        end

        if !row_was_found
          @BROWSER.div(:class, 'page').send_keys :space
          sleep(0.2)
          index += 3
        end
      end
      
      if !row_was_found
        fail(msg = "Error. transactions_validation. The following row was not found in Transactions table: #{row_to_match_with}")
      end

    elsif cashback_or_withdrawl == 'withdrawal'
      click_button('Withdrawals')
      
      today_date = Time.new.strftime("%d/%m/%Y")
      #row_to_match_with = "#{today_date} Paid via: #{method} #{curreny}#{cashback_earned}" +'\n' + "#{state}"
      row_to_match_with = "Paid via: #{method} #{curreny}#{cashback_earned}" +'\n' + "#{state}"
      
      while @BROWSER.table.tbody.tr(:index, index).exists? && !row_was_found
        
        if @BROWSER.table.tbody.tr(:text => /#{row_to_match_with}/).present?
          row_was_found = true
        end

        if !row_was_found
          @BROWSER.div(:class, 'page').wait_until_present
          @BROWSER.div(:class, 'page').send_keys :space
          sleep(0.2)
          index += 3
        end
      end

      if !row_was_found
        fail(msg = "Error. transactions_validation. The following row was not found in Withdrawals table: #{row_to_match_with}")
      end
    else
      fail(msg = "Error. transactions_validation. Option '#{cashback_or_withdrawl}' is not existing")
    end
  end

  # Set current balances from withdraw screen
  def set_current_balances
    click_button('Wallet')

    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["title_2"]).wait_until_present
    $available_to_withdraw = (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["title_2"]).parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f
  
    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["tracking"]).wait_until_present
    $tracked_cashback = (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["tracking"]).parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f
    
    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["toDate"])
    $withdrawn_to_date = (@BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["toDate"]).parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f

    puts "$available_to_withdraw#{$available_to_withdraw} $tracked_cashback#{$tracked_cashback} $withdrawn_to_date#{$withdrawn_to_date}"
  end

  # Validate the the current balances in the withdraw screen are update accourding to the given value
  # @param available_to_withdraw - if not null value was change and validate accouring this value
  # @param tracked_cashback - if not null value was change and validate accouring this value
  # @param withdrawn_to_date - if not null value was change and validate accouring this value
  def validate_changes_in_current_balances
    click_button('Wallet')
    is_visible('Wallet')

    available_to_withdraw_from_balance = (@BROWSER.div(:text, 'Available to withdraw').parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f
    if $available_to_withdraw != available_to_withdraw_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Available to withdraw value in balance is #{available_to_withdraw_from_balance} and expected to #{$available_to_withdraw}")
    end

    tracked_cashback_from_balance = (@BROWSER.div(:text, 'Tracked cashback').parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f
    if $tracked_cashback != tracked_cashback_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Tracked cashback value in balance is #{tracked_cashback_from_balance} and expected to #{$tracked_cashback}")
    end

    withdrawn_to_date_from_balance = (@BROWSER.div(:text, 'Withdrawn to date').parent.parent.div(:index, 3).text).match(/(\d+\.\d+)/)[1].to_f
    if $withdrawn_to_date != withdrawn_to_date_from_balance
      fail(msg = "Error. validate_changes_in_current_balances. Withdrawn to date balance is #{withdrawn_to_date_from_balance} and expected to #{$withdrawn_to_date}")
    end
  end

  # Request withdrew using paypal account using the webapp
  def request_withdrew_paypal_web_app
    
  end

  # Request withdrew using bank account using the web app
  def request_withdrew_bank_web_app

    puts "$available_to_withdraw_amount:#{$available_to_withdraw}"

    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["label_4"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["label_4"]).parent.parent.div(:text, "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{sprintf('%.2f', $available_to_withdraw)}").text
    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["label_4"]).parent.parent.button(:text, 'Continue').click
    @BROWSER.div(:text, HERMES_STRINGS["wallet"]["wallet"]["label_4"]).parent.parent.button(:text, 'Continue')

    @BROWSER.div(:text,  HERMES_STRINGS["wallet"]["modal"]["bacs"]["title"]).wait_until_present
    @BROWSER.div(:text, "Available to withdraw: #{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{sprintf('%.2f', $available_to_withdraw)}").wait_until_present

    @BROWSER.input(:placeholder, 'Name on Account').wait_until_present
    @BROWSER.input(:placeholder, 'Name on Account').send_keys 'admin'
    @BROWSER.input(:placeholder, 'Name on Account').click

    @BROWSER.input(:type => 'tel', :index => 0).wait_until_present
    @BROWSER.input(:type => 'tel', :index => 1).wait_until_present
    @BROWSER.input(:type => 'tel', :index => 2).wait_until_present

    @BROWSER.input(:type => 'tel', :index => 0).click
    @BROWSER.input(:type => 'tel', :index => 0).send_keys '11'

    @BROWSER.input(:type => 'tel', :index => 1).click
    @BROWSER.input(:type => 'tel', :index => 1).send_keys '12'

    @BROWSER.input(:type => 'tel', :index => 2).click
    @BROWSER.input(:type => 'tel', :index => 2).send_keys '13'

    @BROWSER.input(:placeholder, 'Account number').wait_until_present
    @BROWSER.input(:placeholder, 'Account number').send_keys '12345678'

    @BROWSER.button(:text, 'Confirm').wait_until_present
    @BROWSER.button(:text, 'Confirm').click

    @BROWSER.div(:text, 'Account Name: admin').wait_until_present
    @BROWSER.div(:text, 'Account Sort Code: 11-12-13').wait_until_present
    @BROWSER.div(:text, 'Account Number: 12345678').wait_until_present
    @BROWSER.div(:text, 'Confirm Withdrawal').wait_until_present
    @BROWSER.input(:placeholder, 'LifeWorks Password').wait_until_present
    @BROWSER.input(:placeholder, 'LifeWorks Password').send_keys ACCOUNT[:"#{$account_index}"][:valid_account][:password]
    @BROWSER.button(:text, 'Withdraw').wait_until_present
    @BROWSER.button(:text, 'Withdraw').click  
    @BROWSER.button(:text, 'Withdraw').wait_while_present
  end

  # User raise clime for declined cashback
  def raise_clime
    click_button('Transactions')
    
    @BROWSER.div(:text, 'Declined').wait_until_present
    @BROWSER.div(:text, 'Declined').click
    
    @BROWSER.div(:text, 'Cashback: Declined').wait_until_present
    @BROWSER.div(:text, 'Unfortunately your cashback has been declined. You can raise a claim and we will investigate the issue for you.').wait_until_present
    @BROWSER.button(:text, 'Query').wait_until_present
    @BROWSER.button(:text, 'Query').click
    
    @BROWSER.textarea.wait_until_present
    @BROWSER.textarea.send_keys 'Rasing a claim'
    @BROWSER.button(:text, 'Send').click

    @BROWSER.div(:text, 'A claim has been raised regarding your cashback. We will investigate the issue for you and will get back to you ASAP.').wait_until_present
    @BROWSER.div(:text, 'Claim Raised').wait_until_present
    @BROWSER.div(:text, 'Claim Raised').parent.img.click
    @BROWSER.div(:text, 'Claim Raised').wait_until_present
  end
  
end
