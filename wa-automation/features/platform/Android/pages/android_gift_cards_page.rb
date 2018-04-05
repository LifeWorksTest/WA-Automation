# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidGiftCardsPage < Calabash::ABase
  
  LBL_GIFT_CARDS = "AppCompatTextView marked:'Gift Cards'"

  BTN_CATEGORIES = "AppCompatTextView text:'Categories'"
  BTN_POPULAR = "AppCompatTextView text:'Popular'"
  BTN_SEARCH = "ActionMenuItemView id:'action_search'"
  BTN_BUY_NOW = "AppCompatButton text:'Buy Now'"
  BTN_DELIVERY_INFORMATION = "AppCompatTextView text:'Delivery Information'"
  BTN_ABOUT_THE_BRAND = "AppCompatTextView marked:'More about the Retailer'"
  BTN_TERMS_AND_CONDITIONS = "AppCompatButton marked:'TERMS & CONDITIONS'"
  BTN_ASK_US_A_QUESTION = "AppCompatButton text:'ASK A QUESTION'"
  BTN_BACK = "android.widget.ImageButton index:0"
  BTN_REMOVE = "AppCompatTextView id:'view_saved_card_remove_text_view' text:'Remove'"

  def trait
    LBL_GIFT_CARDS
  end

  def is_visible (page)
    if element_exists "* id:'view_one_time_hint_dismiss_button'"
      sleep(1)
      touch "* id:'view_one_time_hint_dismiss_button'"
      wait_for(:timeout => 30){element_does_not_exist("* id:'view_one_time_hint_dismiss_button'")}
    end

    case page
    when 'Main'
      wait_for(:timeout => 30){element_exists(BTN_CATEGORIES)}
      wait_for(:timeout => 30){element_exists(BTN_POPULAR)}
      wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
    when 'Gift Card Detail'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      wait_for(:timeout => 30){element_exists(BTN_BUY_NOW)}
    when 'Categories'
      wait_for(:timeout => 30){element_exists("* marked:'All'")}
      #wait_for(:timeout => 30){element_exists("* marked:'Children & Toys'")}
      wait_for(:timeout => 30){element_exists("* marked:'Department Stores'")}
      wait_for(:timeout => 30){element_exists("* marked:'Electrical'")}
      wait_for(:timeout => 30){element_exists("* marked:'Fashion'")}
      #wait_for(:timeout => 30){element_exists("* marked:'Grocery Stores'")}
      #wait_for(:timeout => 30){element_exists("* marked:'Health & Beauty'")}
      #wait_for(:timeout => 30){element_exists("* marked:'Jewellery'")}
      #wait_for(:timeout => 30){element_exists("* marked:'Leisure'")}
    end
  end

  def click_button (button)
    case button
    when 'Buy Now'
      wait_for(:timeout => 30){element_exists(BTN_BUY_NOW)}
      touch(BTN_BUY_NOW)
      wait_for(:timeout => 30){element_does_not_exist(BTN_BUY_NOW)}
    when 'Terms and Conditions'
      wait_for(:timeout => 30){element_exists(BTN_TERMS_AND_CONDITIONS)}
      touch(BTN_TERMS_AND_CONDITIONS)
      sleep(0.5)
      wait_for(:timeout => 30){element_exists("* marked:'Terms and Conditions'")}
    when 'About the Brand'
      wait_for(:timeout => 30){element_exists(BTN_ABOUT_THE_BRAND)}
      touch(BTN_ABOUT_THE_BRAND)
      sleep(1)
    when 'Back'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      sleep(0.5)
      touch(BTN_BACK)
      sleep(0.5)
    when 'Categories'
      wait_for(:timeout => 30){element_exists(BTN_CATEGORIES)}
      touch(BTN_CATEGORIES)
      is_visible('Categories')
    when 'Remove'
      wait_for(:timeout => 30){element_exists(BTN_REMOVE)}
      touch(BTN_REMOVE)
      wait_for(:timeout => 30){element_exists("DialogTitle id:'alertTitle' marked:'Remove card details'")}
      wait_for(:timeout => 30){element_exists("* id:'message' marked:'Are you sure you want to remove this payment method?'")}
      wait_for(:timeout => 30){element_exists("AppCompatButton id:'button1' marked:'Remove'")}
      touch("AppCompatButton id:'button1' marked:'Remove'")
      wait_for(:timeout => 30){element_does_not_exist("AppCompatButton id:'button1' marked:'Remove'")}
    else
      fail(msg = "Error. click_button. '#{button}' is not define")
    end
  end

  # Go over the 4 Gift Cards in the table and validate the data in the card's page
  def go_over_table

    if element_exists("* marked:'Got it'")
      touch("* marked:'Got it'")
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist("* marked:'Got it'")}
    end

    for i in 0..3
      wait_for(:timeout => 30){element_exists("cardView index:#{i} * id:'view_gift_card_item_retailer_name'")}
      wait_for(:timeout => 30){element_exists("cardView index:#{i} * id:'view_gift_card_item_card_type'")}
      wait_for(:timeout => 30){element_exists("cardView index:#{i} * id:'view_gift_card_item_discount'")}
      
      gift_card_name = query("cardView index:#{i} * id:'view_gift_card_item_retailer_name'")[0]['text']
      gift_card_discount = query("cardView index:#{i} * id:'view_gift_card_item_discount'")[0]['text']
      gift_card_type = query("cardView index:#{i} * id:'view_gift_card_item_card_type'")[0]['text']
      puts "#{i},#{gift_card_name},#{gift_card_discount},#{gift_card_type}"
      
      touch("cardView index:#{i}")
      sleep(1)
      validate_gift_card_page(gift_card_name, gift_card_discount, gift_card_type)
      click_button('Back')
    end
  end

  # Validate the data in the card's page
  def validate_gift_card_page (gift_card_name, gift_card_discount, gift_card_type)
    is_visible('Gift Card Details')
    wait_for(:timeout => 30){element_exists("* marked:'#{gift_card_name}'")}
    wait_for(:timeout => 30){element_exists("* marked:'#{gift_card_discount}'")}
    wait_for(:timeout => 30){element_exists("* marked:'#{gift_card_type}'")}

    cashback_value = (/\d+/.match gift_card_discount)[0].to_f
    @current_user_currency = ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]
    wait_for(:timeout => 30){element_exists("* id:'fragment_gift_card_details_total_amount_label'")}
    
    if element_exists("* id:'fragment_gift_card_price_view'") 
      if element_exists("CurrencyEditText id:'fragment_gift_card_details_currency_input_free_text'")
        price = (query "CurrencyEditText id:'fragment_gift_card_details_currency_input_free_text'")[0]['text'].to_f
      else
        price = (query "* id:'fragment_gift_card_details_currency_input_denominations'")[0]['text'][1..-1].to_f
      end

      amount = 1
    
      total_price_before_discount = price * amount
      total_price_after_discount = total_price_before_discount * ((100 - cashback_value) / 100)

      total_befor_and_after = "#{@current_user_currency}#{sprintf('%.2f', total_price_after_discount.to_s)} #{@current_user_currency}#{sprintf('%.2f', total_price_before_discount.to_s)}"
      wait_for(:timeout => 30){element_exists("* marked:'#{total_befor_and_after}'")}
    else
      # TODO: In case there is only one nomination  
    end
    
    i = 0

    while element_does_not_exist(BTN_TERMS_AND_CONDITIONS)
      perform_action('drag', 50, 50, 70, 40, 5)
      sleep(1)

      i += 1

      if i > 15
        fail (msg = "Error. validate_gift_card_page. Can't find button")
      end
    end

    sleep(2)
    click_button('Terms and Conditions')
    click_button('Back')

    click_button('About the Brand')
    wait_for(:timeout => 30){element_exists("* id:'description_text_view'")}
    click_button('About the Brand')
    wait_for(:timeout => 30){element_does_not_exist("* id:'description_text_view'")}
  end

  # Select Category
  # @param category to select
  def select_category (category)
    is_visible('Browse by Category')
    touch("* marked:'#{category}'")
    wait_for(:timeout => 30){element_exists("* marked:'#{category}'")}
  end

  # Select gift card
  # @param gift_card_name to select
  def select_gift_card (gift_card_name)
    @gift_card_name = gift_card_name
    i = 0

    wait_poll(:until_exists => "* marked:'#{gift_card_name}'", :timeout => 15) do 
      perform_action('drag', 50, 50, 70, 50, 5)
      sleep(1)
    end

    wait_for(:timeout => 30){element_exists("* marked:'#{@gift_card_name}' sibling * LinearLayout child * index:1")}
    @gift_card_discount = query("* marked:'#{@gift_card_name}' sibling * LinearLayout child * index:1")[0]['text']
    touch("* marked:'#{@gift_card_name}'")
    
    is_visible('Gift Card Detail') 
  end

  # Buy gift card
  # @param quantity
  # @param value
  def buy_gift_card (quantity, value)
    click_button('Buy Now')
    checkout(quantity, value)
    payment_successful(quantity, value)
  end

  # Checkout screen
  # @param quantity - gift card amount
  # @param value - gift card value
  def checkout (quantity, value)
    wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'Checkout'")}

    @current_user_currency = ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]
    @discount_value = (/\d+/.match @gift_card_discount)[0].to_i

    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_merchant_title_text_view' text:'#{@gift_card_name}'")}
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_order_summary_text_view' text:'#{@gift_card_discount}'")}
    total_price_after_discount = (quantity * value) * (100 - @discount_value.to_f)/100
    
    @price_to_display_after_discount = "#{@current_user_currency}#{sprintf('%.2f', total_price_after_discount.to_s)}"
    @price_to_display_befor_discount = "#{@current_user_currency}#{sprintf('%.2f', value.to_s)}"
    
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_price_discount_text_view' text:'#{@price_to_display_after_discount}'")}
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_price_full_text_view' text:'#{@price_to_display_befor_discount}'")} 
    
    wait_for(:timeout => 30){element_exists("AppCompatTextView text:'Enter the email address you would like your gift card to be sent to'")} 
    #wait_for(:timeout => 30){element_exists("AppCompatEditText text:'#{@current_user_email}'")}

    if element_exists(BTN_REMOVE)
      click_button('Remove')
    end

    wait_for(:timeout => 30){element_exists("AppCompatEditText id:'view_credit_card_layout_card_number_edit_text'")}
    enter_text("AppCompatEditText id:'view_credit_card_layout_card_number_edit_text'", '4242424242424242')
    hide_soft_keyboard()
    sleep(0.5)

    wait_for(:timeout => 30){element_exists("AppCompatEditText id:'view_credit_card_layout_card_month_edit_text'")}
    enter_text("AppCompatEditText id:'view_credit_card_layout_card_month_edit_text'", '10')
    hide_soft_keyboard()
    sleep(0.5)

    wait_for(:timeout => 30){element_exists("AppCompatEditText id:'view_credit_card_layout_card_year_edit_text'")}
    enter_text("AppCompatEditText id:'view_credit_card_layout_card_year_edit_text'", '19')
    hide_soft_keyboard()
    sleep(0.5)

    wait_for(:timeout => 30){element_exists("AppCompatEditText id:'view_credit_card_layout_card_year_edit_text'")}
    enter_text("AppCompatEditText id:'view_credit_card_layout_card_cvc_edit_text'", '123')
    hide_soft_keyboard()
    sleep(0.5)

    wait_for(:timeout => 30){element_exists("AppCompatButton id:'fragment_checkout_pay_button' marked:'Pay #{@price_to_display_after_discount}'")}
    touch("AppCompatButton id:'fragment_checkout_pay_button' marked:'Pay #{@price_to_display_after_discount}'")
    wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'Payment Successful'")}
  end

  # Gift card payment successful screen
  # @param quantity - gift card amount
  # @param value - gift card value
  def payment_successful(quantity, value)
    wait_for(:timeout => 30){element_exists("AppCompatTextView marked:'Payment Successful'")}
    #wait_for(:timeout => 30){element_exists("AppCompatTextView id:'fragment_confirmation_email_text_view' marked:'#{@current_user_email}'")}

    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_merchant_title_text_view' text:'#{@gift_card_name}'")}
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_order_summary_text_view' text:'#{@gift_card_discount}'")}
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_price_discount_text_view' text:'#{@price_to_display_after_discount}'")}
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'view_cinema_order_information_price_full_text_view' text:'#{@price_to_display_befor_discount}'")} 
    wait_for(:timeout => 30){element_exists("AppCompatImageButton")}
    touch("AppCompatImageButton")
    wait_for(:timeout => 30){element_does_not_exist("AppCompatTextView marked:'Payment Successful'")}
    touch("AppCompatImageButton")
  end
end
