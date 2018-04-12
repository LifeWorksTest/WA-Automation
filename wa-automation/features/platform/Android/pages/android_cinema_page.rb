# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidLifePage < Calabash::ABase
  LBL_CINEMAS = "label marked:'#{IOS_STRINGS["WAMMenuItemCinemasTitle"]}'"
  LBL_HOW_DOES_IT_WORK = "label marked:'#{IOS_STRINGS["WAMCIHelpNavigationBarTitle"]}'"

  BTN_INFO = "button marked:'icn info'"
  BTN_T_AND_C = "label marked:'#{IOS_STRINGS["WAMCITermsAndConditionsTitle"]}'"
  BTN_CANCEL = "button marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'"
  BTN_BUY_NOW = "button marked:'#{IOS_STRINGS["WAMCIBuyButtonTitle"]}'"
  BTN_REMOVE = "button marked:'#{IOS_STRINGS["WAMSavedCardRemove"]}'"
  BTN_PAY_WITH_CARD = "button marked:'#{IOS_STRINGS["WAMCheckoutCardButton"]}'"
  BTN_CLOSE = "button marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'"
  BTN_BACK = "UINavigationBar child * index:1 descendant * index:4"

  LBL_ORDER_ID = ("#{IOS_STRINGS["WAMConfirmationEmailViewSubtitle"]}"[0,9])

  def trait
    LBL_CINEMAS
  end

  # Purchase cinema tickets
  # @param cinema_name
  # @param cinema_location
  # @param purchase_order_array - 2 dimension array of tickets to purchase and amounts
  def purchase_ticket (cinema_name, cinema_location, purchase_order_array)
    @CINEMA_NAME = cinema_name
    wait_for_none_animating

    wait_poll(:retry_frequency => 0.5,:until_exists => "label marked:'#{cinema_name}'", :timeout => 15) do
      scroll("scrollView index:0", :down)
    end

    touch "WAMCIMerchantCell descendant * label marked:'#{cinema_name}'"
    wait_for_elements_exist("UINavigationBar id:'#{cinema_name}'")
    wait_for_elements_exist("WAMRetailerInfoView descendant * label marked:'#{cinema_name}'")
    wait_for_elements_exist("WAMCIOfferTableViewCell")

    choose_cinema_location(cinema_name)
    select_ticket(purchase_order_array)
    touch(BTN_BUY_NOW)
    checkout(cinema_name, cinema_location,purchase_order_array)
    conformation(cinema_name, cinema_location,purchase_order_array)
  end

  # Choose location screen
  # @param cinema_location
  def choose_cinema_location(cinema_location)
    wait_for_none_animating
    wait_for_elements_exist("UITextFieldLabel")
    touch("UITextFieldLabel")
    wait_for_none_animating
    wait_for_elements_exist(BTN_CANCEL)
    wait_for_elements_exist("WAMOptionToggleView")
    touch("WAMOptionToggleView")
    element_does_not_exist(BTN_CANCEL)
  end

  # Select tickets and amount
  # @param purchase_order_array - holds the ticket type and the quantity
  def select_ticket(purchase_order_array)
    scroll("scrollView index:0", :down)
    wait_for_none_animating

    wait_for_elements_exist("WAMCIOfferTableViewCell")
    purchase_order_array.each do |amount,ticket_type|
      puts "amount:#{amount}  ticket_type:#{ticket_type}"

      wait_poll(:retry_frequency => 0.5, :until_exists => "label marked:'#{ticket_type}'", :timeout => 30) do
        scroll("scrollView", :down)
      end

      touch("label marked:'#{ticket_type}' parent * index:0 descendant * button marked:'ic quantity minus'")

      for i in 0..amount
        touch("label marked:'#{ticket_type}' parent * index:0 descendant * button marked:'ic quantity plus'")
      end
    end
  end

  # Validate that "About This Offer" "How to redeem?" "Important things to know" and "Terms and Condition" are visible and not empty
  def validate_cinema_page
    #Important things to know
    #How to redeem?
    #About This Offer
    #Please select
    #Choose your cinema location
  end

  # Complete conformation screen
  # @param cinema_name
  # @param cinema_location
  # @param purchase_order_array
  def checkout(cinema_name, cinema_location, purchase_order_array)
    wait_for_elements_exist("label marked:'#{cinema_name} (#{cinema_location})'")
    wait_for_elements_exist("label marked:'#{IOS_STRINGS["WAMCIDeliveryEmailTitle"]}'")
    @user_email = query("JVFloatLabeledTextField")[0]['value']

    if @user_email == ''
      fail('Error. checkout. User email is blank')
    end

    wait_for_none_animating

    if element_exists("label marked:'#{IOS_STRINGS["WAMSavedCardTitle"]}'")
      wait_for_elements_exist(BTN_REMOVE)
      touch(BTN_REMOVE)
      wait_for_none_animating
    end

    wait_for_elements_exist(BTN_PAY_WITH_CARD)
    touch(BTN_PAY_WITH_CARD)
    insert_card_details
    scroll("scrollView index:0", :down)
    sleep(1)
    touch("UIButtonLabel") #to add amount to the button label
    wait_for_none_animating
  end

  # Insert card details
  def insert_card_details
    wait_for_none_animating
    wait_for_elements_exist("label marked:'#{IOS_STRINGS["WAMPaymentEnterCardInformation"]}'")

    wait_for_elements_exist("label marked:'#{IOS_STRINGS["WAMPaymentNumberPlaceholder"]}'")
    touch("label marked:'#{IOS_STRINGS["WAMPaymentNumberPlaceholder"]}'")
    wait_for_keyboard
    keyboard_enter_text('4242424242424242')

    touch("label marked:'#{IOS_STRINGS["WAMPaymentExpiryMonthPlaceholder"]}'")
    keyboard_enter_text('11')

    touch("label marked:'#{IOS_STRINGS["WAMPaymentExpiryYearPlaceholder"]}'")
    keyboard_enter_text('20')

    touch("label marked:'#{IOS_STRINGS["WAMPaymentSecurityPlaceholder"]}'")
    keyboard_enter_text('123')
  end

  # Complete conformation screen
  # @param cinema_name
  # @param cinema_location
  # @param purchase_order_array
  def conformation(cinema_name, cinema_location,purchase_order_array)
    wait_for_elements_exist("UINavigationBar marked:'#{IOS_STRINGS["WAMCheckoutPaymentSuccessfulTitle"]}'")
    wait_for_elements_exist("label {text BEGINSWITH '#{LBL_ORDER_ID}'}")

    order_id_label = query("label {text BEGINSWITH '#{LBL_ORDER_ID}'}")[0]['label']
    order_id_label = (/[^.]*/.match order_id_label)[0].sub('#{LBL_ORDER_ID} ','')

    if order_id_label == ""
      fail(msg = 'Error. confirmation. Order ID was empty')
    end

    wait_for_elements_exist("label marked:'#{cinema_name} (#{cinema_location})'")
    wait_for_elements_exist("label {text CONTAINS 'A confirmation email has been sent to'}")
    wait_for_elements_exist("label marked:'#{@user_email}'")

    touch(BTN_CLOSE)
    wait_for_elements_exist("UINavigationBar marked:'#{cinema_name}'")
  end
end
