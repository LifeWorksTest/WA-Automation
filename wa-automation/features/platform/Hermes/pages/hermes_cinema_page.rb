class HermesCinemaPage
	def initialize (browser)
		@BROWSER = browser
    @file_service = FileService.new

		@LBL_BANNER_TITLE = @BROWSER.div(:class => 'title-velocity-hook', :text => HERMES_STRINGS["cinemas"]["banner_title"])
		@LBL_BANNER_SUBTITLE = @BROWSER.div(:class => 'subtitle-velocity-hook', :text => HERMES_STRINGS["cinemas"]["banner_subtitle"])
    # @LBL_CHOOSE_A_CINEMA = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["choose_cinema"])
    @LBL_AVAILABILITY = @BROWSER.div(:text, /#{HERMES_STRINGS["cinemas"]["tickets_subject_availability"]}/)
    @LBL_COMPLETE_YOUR_ORDER = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["complete_order_title"])
    @LBL_YOUR_ORDER = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["your_order"])
    @LBL_SAVE_CARD_DETAILS = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["save_details"])
    @LBL_ORDER_SUMMARY = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["order_summary"])
    @LBL_CC_EXPIRY_DATE =  @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["expiry_date"])
    @LBL_ORDER_SUCCESSFUL = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["successful_order_title"])
    @LBL_ORDER_NUMBER = @BROWSER.element(css: "span[style^='font-weight: 600;']")
    @LBL_DISCOUNT_CODES_SENT_TO = @BROWSER.div(:text, "#{HERMES_STRINGS["cinemas"]["discount_codes_sent"]}#{ACCOUNT[:"#{$account_index}"][:valid_account][:email]}")
    @LBL_CHANGE_CARD_INFO = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["change_card_info"])

    @LNK_VIEW_YOUR_CINEMA_CODES = @BROWSER.span(:text, "#{HERMES_STRINGS["cinemas"]["view"]} #{HERMES_STRINGS["cinemas"]["cinema_codes"]}")
    @LNK_READ_TERMS_AND_CONDITIONS = @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["read_tc"]) 

    @TXF_SELECT_A_CINEMA = @BROWSER.span(:text, HERMES_STRINGS["cinemas"]["please_select"])
    @TXF_EMAIL = @BROWSER.text_field(:placeholder, 'Email *')
    @TXF_CREDIT_CARD_NUMBER = @BROWSER.text_field(:placeholder, 'Credit Card number *')
    @TXF_CC_EXPIRY_YEAR =  @BROWSER.span(:text, HERMES_STRINGS["cinemas"]["YY"])
    @TXF_CC_SECURITY_CODE = @BROWSER.text_field(:placeholder, '123')

    # @BTN_BUY_NOW = @BROWSER.button(:text, HERMES_STRINGS["cinemas"]["buy_now"])
    @BTN_CONFIRM_PAYMENT = @BROWSER.button(:text, HERMES_STRINGS["cinemas"]["confirm_payment"])
    @BTN_REMOVE_SAVED_CARD = @BROWSER.a(:text, HERMES_STRINGS["cinemas"]["remove"].upcase)
    @BTN_REMOVE_SAVED_CARD_CONFIRM = @BROWSER.button(:text, HERMES_STRINGS["cinemas"]["remove"].upcase)
    @BTN_REMOVE_SAVED_CARD_CANCEL =  @BROWSER.a(:text, HERMES_STRINGS["cinemas"]["cancel"].upcase)
	end

	def is_visible(page)
  	case page
  	when 'main'
			@LBL_BANNER_TITLE.wait_until_present
  		@LBL_BANNER_SUBTITLE.wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["walkthrough"]["step_1"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["walkthrough"]["step_2"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["walkthrough"]["step_3"]).wait_until_present
    when 'cinema details'
      @BROWSER.div(:text, 'Buy your Codes').parent.div(:text, 'Choose a cinema*').wait_until_present
      @TXF_SELECT_A_CINEMA.wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["buy_your_tickets"]).parent.button(:text, HERMES_STRINGS["cinemas"]["buy_now"]).wait_until_present
      @LBL_AVAILABILITY.wait_until_present
      @LNK_READ_TERMS_AND_CONDITIONS.wait_until_present
  	when 'complete your order'
      @LBL_COMPLETE_YOUR_ORDER.wait_until_present
      @LBL_YOUR_ORDER.wait_until_present
      @TXF_EMAIL.wait_until_present
      @LBL_ORDER_SUMMARY.wait_until_present
      @TXF_EMAIL.wait_until_present
      
      Watir::Wait.until {
        @BTN_REMOVE_SAVED_CARD.present? ||
        @TXF_CREDIT_CARD_NUMBER.present?
      }

      if @BTN_REMOVE_SAVED_CARD.present?
        @LBL_CHANGE_CARD_INFO.wait_until_present
        @BTN_REMOVE_SAVED_CARD.wait_until_present
        @BTN_REMOVE_SAVED_CARD.click
        @BTN_REMOVE_SAVED_CARD_CANCEL.wait_until_present
        @BTN_REMOVE_SAVED_CARD_CONFIRM.wait_until_present
        @BTN_REMOVE_SAVED_CARD_CONFIRM.click
      end

      @TXF_CREDIT_CARD_NUMBER.wait_until_present
      @LBL_CC_EXPIRY_DATE.parent.i.wait_until_present
      @LBL_CC_EXPIRY_DATE.parent.i(:index, 1).wait_until_present
      @TXF_CC_EXPIRY_YEAR.wait_until_present
      @TXF_CC_SECURITY_CODE.wait_until_present
      @LBL_SAVE_CARD_DETAILS.wait_until_present
      @LBL_SAVE_CARD_DETAILS.wait_until_present
      @BTN_CONFIRM_PAYMENT.wait_until_present
      @LNK_READ_TERMS_AND_CONDITIONS.wait_until_present
    when 'order successful'  
      @LBL_ORDER_SUCCESSFUL.wait_until_present
      @LBL_DISCOUNT_CODES_SENT_TO.wait_until_present
      @LBL_ORDER_SUMMARY.wait_until_present
    when 'View your Cinema Codes'
      @CINEMA_NAME = @file_service.get_from_file("cinema_name:")[0..-2]
      @ORDER_NUMBER = @file_service.get_from_file("cinema_order_number:")[0..-2]
      
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).wait_until_present
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["cinemas"]["cinema_codes"]).wait_until_present
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, /#{@ORDER_NUMBER}/i).wait_until_present
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, /#{@ORDER_NUMBER}/i).parent.parent.parent.div(:text, CINEMAS[:"#{@CINEMA_NAME}"][:name]).wait_until_present
    else
      fail(msg = "Error. is_visible. The option #{page} is not defined in menu.")
    end
  end

  def click_button(button)
    case button
    when 'buy now'
      @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["buy_your_tickets"]).parent.button(:text, HERMES_STRINGS["cinemas"]["buy_now"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["cinemas"]["buy_your_tickets"]).parent.button(:text, HERMES_STRINGS["cinemas"]["buy_now"]).click
      is_visible('complete your order')
    when 'View your Cinema Codes'
      @LNK_VIEW_YOUR_CINEMA_CODES.wait_until_present
      @LNK_VIEW_YOUR_CINEMA_CODES.click
      is_visible('View your Cinema Codes')
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Search for cinema and click on it when found 
  #@param = cinema_name
  def search_for_and_open_cinema
    @CINEMA_NAME = @file_service.get_from_file("cinema_name:")[0..-2]
    i = 0

    while !@BROWSER.div(:text, CINEMAS[:"#{@CINEMA_NAME}"][:name]).present?
      
      if i == 10
        fail(msg = "Error. search_for_and_open_cinema. Cinema with the name '#{cinema_name}' cannot be found")
      else
        @BROWSER.send_keys :space
        sleep(1)
        i += 1
      end
    end

    @BROWSER.div(:text, CINEMAS[:"#{@CINEMA_NAME}"][:name]).parent.div(:text, HERMES_STRINGS["cinemas"]["exclusive_price"]).wait_until_present
    @BROWSER.div(:text, CINEMAS[:"#{@CINEMA_NAME}"][:name]).click
    is_visible('cinema details')
  end

  # Selects a cinema location from the drop down list.
  # @param = cinema_location
  def choose_a_cinema_location (cinema_location)
    @TXF_SELECT_A_CINEMA.wait_until_present
    @TXF_SELECT_A_CINEMA.click
    @BROWSER.div(:class, 'flag__body').div(:text, CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:name]).wait_until_present
    @BROWSER.div(:class, 'flag__body').div(:text, CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:name]).fire_event('click')
    @TXF_SELECT_A_CINEMA.wait_while_present
    @BROWSER.div(:text, /#{HERMES_STRINGS["cinemas"]["from"]} #{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}/).wait_while_present
  end

  # Verifies that the ticket type name/description is correctly displayed on the ticket selection page
  # Verifies that the correct price is shown (dependant on whick price tier the users company is using)
  # If ticket type is expected to be out of stock, then set param to 'true' and method will verify 'OUT OF STOCK' label is present
  # @param = verify_ticket_types
  def verify_ticket_types (out_of_stock = false, ticket_type)
    ticket_type.split(',').each do |ticket_type|
      # If user is on payment confirmation page (eg has just paid), then click 'back' link that takes user back to cinema details/ticket purchase page
      if @LBL_ORDER_SUCCESSFUL.present?
        @BROWSER.i(:class, 'icon-web_arrow_left').wait_until_present
        @BROWSER.i(:class, 'icon-web_arrow_left').click
        is_visible('cinema details')
      end

      @CINEMA_PRICING_TIER = $USER_FEATURE_LIST['benefit_cinema_pricing_tier']
    
      if !@BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]).present?
        fail(msg = "Error. verify_ticket_types. Ticket type #{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]} should be visible for cinema - #{CINEMAS[:"#{@CINEMA_NAME}"][:name]}")
      elsif !out_of_stock
        @BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]).parent.span(:text, "(#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:description]})").wait_until_present
        @BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]).parent.div(:text, "Price: #{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:"tier_#{@CINEMA_PRICING_TIER}_price"]}").wait_until_present
      else
        @BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]).parent.parent.div(:index, 2).div(:text, /#{HERMES_STRINGS["cinemas"]["out_of_stock"]}/i).wait_until_present
        puts "#{ticket_type} has been correctly verified as 'OUT OF STOCK"
      end

    end
  end

  # Calls the 'verify_ticket_method' to firstly verify the ticket names and prices are correctly displayed
  # Increments the number of each ticket to the amount specified in @param number_of_tickets. If stock < number_of_tickets then the test fails
  # @param = ticket_types
  # @param = amount_of_tickets
  def select_amount_of_tickets (ticket_types, amount_of_tickets)
    verify_ticket_types(ticket_types)

    i = 0
    @BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_types}"][:name]).wait_until_present

    until @BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_types}"][:name]).parent.parent.div(:index, 2).text == amount_of_tickets

      if i > amount_of_tickets.to_i
        fail(msg = "Error. select_amount_of_tickets. Unable to select #{amount_of_tickets} '#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_types}"][:name]}' ticket(s). Stock may be too low for this ticket type. Check stock levels in Arch.")
      end

      @BROWSER.span(:text, CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_types}"][:name]).parent.parent.img(:src, /plus/).click
      i += 1
    end

    # Calculates the expected total to pay and stores it in the external file. The formula is:- cinema_total_to_pay value from exernal file + (amount_of_tickets * price of single unit of ticket_type)
    @file_service.insert_to_file('cinema_total_to_pay:', "#{@TOTAL_TO_PAY_COUNTER = sprintf('%.2f', "#{@file_service.get_from_file('cinema_total_to_pay:').chomp.to_f + (CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_types}"][:"tier_#{@CINEMA_PRICING_TIER}_price"].to_f * amount_of_tickets.to_i)}")}")
    # Calculates the expected PRE-DISCOUNT total to pay and stores it in the external file. THis vlue is the verified on the ticket selection page each time a new ticket type is added to the basket.
    @file_service.insert_to_file('cinema_pre_discount_total_to_pay:', "#{@PRE_DISCOUNT_PRICE_TOTAL = sprintf('%.2f', "#{@file_service.get_from_file('cinema_pre_discount_total_to_pay:').chomp.to_f + (CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_types}"][:retail_price].to_f * amount_of_tickets.to_i)}")}")
    @BROWSER.button(:text, HERMES_STRINGS["cinemas"]["buy_now"]).parent.div(:text => /#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{@PRE_DISCOUNT_PRICE_TOTAL}/, :index => 1).wait_until_present
  end
  
  # On the complete your order page, the total to pay value is matched up with the expected total to pay that was stored earlier in the verify_buy_now_button_disabled_enabled method
  # If card is valiid, then method will check that order successful page is displayed after payment. Order number is stored for email confirmation checks
  # If card is invalid, then method will check that correct error messaging is displayed
  # @param = valid_invalid_card
  def cinema_payment (is_valid_card = true)
    @TOTAL_CINEMA_BALANCE_TO_PAY_SUMMARY = @LBL_ORDER_SUMMARY.parent.divs.last.span.text
    
    is_valid_card ? card_name = 'card_1' : card_card = 'card_2'

    # expected total to pay checked against total to pay displayed on 'complete your order' page
    if ("#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}" + @TOTAL_TO_PAY_COUNTER) != @TOTAL_CINEMA_BALANCE_TO_PAY_SUMMARY
      fail(msg = "Error. cinema_payment. The total to pay in the order summary should be '#{@TOTAL_TO_PAY_COUNTER}', but is actually #{@TOTAL_CINEMA_BALANCE_TO_PAY_SUMMARY}")
    end

    @TXF_EMAIL.when_present.to_subtype.clear
    @TXF_EMAIL.send_keys ACCOUNT[:"#{$account_index}"][:valid_account][:email]
    @TXF_CREDIT_CARD_NUMBER.send_keys CREDIT_CARD[:credit_card_for_cinema][:"#{card_name}"][:card_number]
    @LBL_CC_EXPIRY_DATE.parent.i.click
    @LBL_CC_EXPIRY_DATE.parent.div(:text, CREDIT_CARD[:credit_card_for_cinema][:"#{card_name}"][:card_expiry_month]).wait_until_present
    @LBL_CC_EXPIRY_DATE.parent.div(:text, CREDIT_CARD[:credit_card_for_cinema][:"#{card_name}"][:card_expiry_month]).fire_event('click')
    @LBL_CC_EXPIRY_DATE.parent.i(:index, 1).fire_event('click')
    @LBL_CC_EXPIRY_DATE.parent.i(:index, 1).parent.parent.parent.div(:text, CREDIT_CARD[:credit_card_for_cinema][:"#{card_name}"][:card_expiry_year]).wait_until_present
    @LBL_CC_EXPIRY_DATE.parent.i(:index, 1).parent.parent.parent.div(:text, CREDIT_CARD[:credit_card_for_cinema][:"#{card_name}"][:card_expiry_year]).click
    @TXF_CC_SECURITY_CODE.send_keys CREDIT_CARD[:credit_card_for_cinema][:"#{card_name}"][:card_cv2_value]

    @BTN_CONFIRM_PAYMENT.wait_until_present
    @BTN_CONFIRM_PAYMENT.click

    # add negative scenario expected behavior
    if is_valid_card
      is_visible('order successful')
      # Get order number and store in file 
      @file_service.insert_to_file('cinema_order_number:', "#{(/\w+/.match "#{@LBL_ORDER_NUMBER.text}").to_s}")
      @TOTAL_CINEMA_BALANCE_TO_PAY_SUMMARY = @LBL_ORDER_SUMMARY.parent.divs.last.span.text
    
      # expected total to pay checked against total to pay displayed on 'order successful' page
      if ("#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}" + @TOTAL_TO_PAY_COUNTER) != @TOTAL_CINEMA_BALANCE_TO_PAY_SUMMARY
        fail(msg = "Error. cinema_payment. The total to pay in the order summary should be '#{@TOTAL_TO_PAY_COUNTER}', but is actually #{@TOTAL_CINEMA_BALANCE_TO_PAY_SUMMARY}")
      end
    else
      @TXF_CREDIT_CARD_NUMBER.parent.div(:text, HERMES_STRINGS["cinemas"]["invalid_credit_card"]).wait_until_present
    end

  end

  # Verifies that the purchased ticket codes appear in the 'View cinema codes' modal window.
  def verify_ticket_codes_in_view_cinema_codes_link
    @ORDER_NUMBER = @file_service.get_from_file("cinema_order_number:")[0..-2].downcase
    click_button('View your Cinema Codes')
    # Verify that order number is 10 chars long
    Watir::Wait.until { @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).span(:text, @ORDER_NUMBER).text.length == 10 }
    
    # Ticket codes are contained in the $returned_value_from_email. We uses each value in the array and verify that it is visible in the veiw cinema code modal window
    $returned_value_from_email.each do |ticket_code_to_verify|
      if !@BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).span(:text, @ORDER_NUMBER).parent.parent.parent.div(:text, ticket_code_to_verify).present?
        fail(msg = "Error. verify_cinema_codes. #{ticket_code_to_verify} is not displayed in the confirmation email")
      end
    end

    # CLose modal window
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).button.wait_until_present
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).button.click
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).wait_while_present
  end
end
