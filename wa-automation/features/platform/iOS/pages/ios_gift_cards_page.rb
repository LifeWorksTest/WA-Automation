# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSGiftCardsPage < Calabash::IBase
  LBL_GIFT_CARDS = "label marked:'#{IOS_STRINGS["WAMMenuItemGiftCardsTitle"]}'"
  LBL_AMOUNT_BETWEEN_TEXT = IOS_STRINGS["WAMGiftCardsDetailBuyPriceRange"][0..-9]

  BTN_ASK_US_A_QUESTION = "button marked:'#{IOS_STRINGS["WAMGCAskQuestionButtonText"]}'"
  BTN_BROWSE_BY_CATEGORY = "button marked:'#{IOS_STRINGS["WAMGCBrowseByCategory"]}'"
  BTN_BACK = "UINavigationBar descendant * index:6"
  BTN_CLOSE = "button marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'"
  BTN_BUY_NOW = "button marked:'#{IOS_STRINGS["WAMGiftCardsDetailBuyNow"]}'"
  BTN_TERMS_AND_CONDITIONS = "button marked:'#{IOS_STRINGS["WAMGiftCardsDetailTermsAndConditions"]}'"
  BTN_ABOUT_THE_BRAND = "button marked:'#{IOS_STRINGS["WAMGiftCardsDetailAboutTheBrand"]}'"
  BTN_SEND = "button marked:'#{IOS_STRINGS["WAMFoundationSendKey"]}'"

  def trait
    LBL_GIFT_CARDS
  end

  def is_visible (page)
    wait_for_none_animating

    case page
    when 'Main'
      wait_for(:timeout => 30){element_exists(BTN_BROWSE_BY_CATEGORY)}
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMGCPopularGiftCards"]}'")}
      wait_for(:timout => 10){element_exists("UITableViewCellContentView")}
    when 'Gift Card Detail'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMGiftCardsDetailTitle"]}'")}
      wait_for(:timeout => 30){element_exists(BTN_BUY_NOW)}
    when 'Browse by Category'
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMGCCategoryAll"]}'")}
      #wait_for(:timeout => 30){element_exists("label marked:'Children & Toys'")}
      wait_for(:timeout => 30){element_exists("label marked:'Department Stores'")}
      wait_for(:timeout => 30){element_exists("label marked:'Electrical'")}
      wait_for(:timeout => 30){element_exists("label marked:'Fashion'")}
      #wait_for(:timeout => 30){element_exists("label marked:'Health & Beauty'")}
      #wait_for(:timeout => 30){element_exists("label marked:'Leisure'")}
    end
  end

  def click_button (button)
    case button
    when 'Buy Now'
      wait_for(:timeout => 30){element_exists(BTN_BUY_NOW)}
      sleep(1)
      touch(BTN_BUY_NOW)
      wait_for(:timeout => 30){element_does_not_exist(BTN_BUY_NOW)}
    when 'Terms and Conditions'
      wait_for(:timeout => 30){element_exists(BTN_TERMS_AND_CONDITIONS)}
      touch(BTN_TERMS_AND_CONDITIONS)
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMFoundationGenericTermsAndConditions"]}'")}
    when 'About the Brand'
      wait_for(:timeout => 30){element_exists(BTN_ABOUT_THE_BRAND)}
      touch(BTN_ABOUT_THE_BRAND)
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMGiftCardsDetailAboutTheBrand"]}'")}
    when 'Back'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      sleep(0.5)
      touch(BTN_BACK)
      sleep(0.5)
    when 'Close'
      wait_for(:timeout => 30){element_exists(BTN_CLOSE)}
      touch(BTN_CLOSE)
      wait_for_none_animating
    when 'Browse by Category'
      wait_for(:timeout => 30){element_exists(BTN_BROWSE_BY_CATEGORY)}
      touch(BTN_BROWSE_BY_CATEGORY)
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMShopOnlineBrowseCategoryText"]}'")}
    end
  end

  # Go over the 4 Gift Cards in the table and validate the data in the card's page
  def go_over_table
    for i in 0..2
      wait_for_none_animating
      wait_for(:timeout => 30){element_exists("WAMGCCardTableViewCell index:#{i} label index:0")}
      wait_for(:timeout => 30){element_exists("WAMGCCardTableViewCell index:#{i} label index:1")}
      wait_for(:timeout => 30){element_exists("WAMGCCardTableViewCell index:#{i} label index:2")}
      
      gift_card_name = query("WAMGCCardTableViewCell index:#{i} label index:0")[0]['text']
      gift_card_discount = query("WAMGCCardTableViewCell index:#{i} label index:1")[0]['text']
      gift_card_type = query("WAMGCCardTableViewCell index:#{i} label index:2")[0]['text']
      puts "#{i},#{gift_card_name},#{gift_card_discount},#{gift_card_type}"
      
      wait_for(:timeout => 30){element_exists("WAMGCCardTableViewCell index:#{i}")}
      touch("WAMGCCardTableViewCell index:#{i}")
      validate_gift_card_page(gift_card_name, gift_card_discount, gift_card_type)
      click_button('Back')
    end
  end

  # Validate the data in the card's page
  def validate_gift_card_page (gift_card_name, gift_card_discount, gift_card_type)
    is_visible('Gift Card Details')
    wait_for(:timeout => 30){element_exists("label marked:'#{gift_card_name}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{gift_card_discount}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{gift_card_type.upcase}'")}
    wait_for(:timeout => 30){element_exists("WAMGCBuyView child * index:1")}

    discount = (/\d+/.match gift_card_discount)[0].to_f
    currency = ACCOUNT[:"#{$account_index}"][:valid_ios_account][:currency_sign]
    
    # if there is more then one value to the current gift card
    if element_exists("label {text BEGINSWITH '#{LBL_AMOUNT_BETWEEN_TEXT}'")
      # if denomination type is value type 
      if element_exists("WAMLateralButton")       
        price = (/\d+/.match (query("WAMLateralButton")[0]['label']))[0].to_f
      else # if denomination type is range type
        price = query("UILabel marked:'#{IOS_STRINGS["WAMGiftCardsDetailBuyYouPay"]}' sibling * index:1")[0]['value'][1..-1].to_f
      end
    else
      price = (/\d+/.match ((query "label marked:'#{IOS_STRINGS["WAMGiftCardsDetailBuyYouPay"]}' sibling * index:2")[0]['value']))[0].to_f
    end
    
    amount = 1
    total_price_before_discount = price * amount
    total_price_after_discount = total_price_before_discount * ((100 - discount) / 100)
    puts "total_price_after_discount:#{total_price_after_discount} total_price_before_discount:#{total_price_before_discount}"
    wait_for(:timeout => 30){element_exists( "label {text CONTAINS '#{currency}#{sprintf('%.2f', total_price_after_discount.to_s)}'")}

    wait_poll(:retry_frequency => 0.5, :until_exists => BTN_ASK_US_A_QUESTION) do
      scroll("scrollView", :down)
      sleep(0.5)
    end

    click_button('Terms and Conditions')
    click_button('Back')

    click_button('About the Brand')
    click_button('Back')
  end

  # Select Category
  # @param category to select
  def select_category (category)
    wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMGCBrowseByCategory"]}'")}
    is_visible('Browse by Category')
    wait_for_none_animating
    touch("label marked:'#{category}'")
    wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{category}'")}
  end

  # Select gift card
  # @param gift_card_name to select
  def select_gift_card (gift_card_name)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists( "label marked:'All'")}
    wait_poll(:retry_frequency => 0.5, :until_exists => "label marked:'#{gift_card_name}'", :post_timeout => 1) do
      scroll("scrollView", :down)
    end

    @gift_card_discount = query("label marked:'#{gift_card_name}' sibling *")[0]['value']
    touch("label marked:'#{gift_card_name}'")
    
    is_visible('Gift Card Detail') 
  end

  # Buy gift card
  # @param quantity
  # @param value
  def buy_gift_card (gift_card_name, quantity, value = nil)
    
    if value == nil
      # if there is more then one value to the current gift card    
      if element_exists("label {text BEGINSWITH '#{LBL_AMOUNT_BETWEEN_TEXT}'")
        # if denomination type is value type 
        if element_exists("WAMLateralButton")
          value = (/\d+/.match (query("WAMLateralButton")[0]['label']))[0].to_f
        else # if denomination type is range type
          value = (/\d+/.match (query("UITextFieldLabel")[0]['label']))[0].to_f
        end
      else
        value = (/\d+/.match ((query "label marked:'#{IOS_STRINGS["WAMGiftCardsDetailBuyYouPay"]}' sibling * index:2")[0]['value']))[0].to_f
      end
    end

    discount = (/\d+/.match @gift_card_discount)[0].to_i
    
    current_user_currency = ACCOUNT[:"#{$account_index}"][:valid_ios_account][:currency_sign]
    total_price_before_discount = "#{current_user_currency}#{value.to_i * quantity.to_i}.00"
    total_price_after_discount = "#{current_user_currency}#{sprintf('%.2f', (value * ((100 - discount.to_f) / 100)))}"
    puts "total_price_before_discount#{total_price_before_discount}  total_price_after_discount#{total_price_after_discount}"
    
    click_button('Buy Now')
    checkout(gift_card_name, quantity, total_price_before_discount, total_price_after_discount, discount)
    payment_successful(gift_card_name, quantity, total_price_before_discount, total_price_after_discount, discount)
  end

  # Review stage in the buying process
  # @param quantity
  # @param value
  def checkout(gift_card_name, quantity, total_price_before_discount, total_price_after_discount, discount)
    wait_for(:timeout => 30){element_exists("label marked:'#{gift_card_name}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{discount}% Discount'")}
    wait_for(:timeout => 30){element_exists("label { text CONTAINS #{total_price_after_discount} #{total_price_before_discount}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMGCDeliveryEmailTitle"]}'")}
    wait_for(:timeout => 30){query("JVFloatLabeledTextField")[0]['text'] == "#{ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email]}"}
    wait_for_none_animating

    if element_exists("button marked:'#{IOS_STRINGS["WAMSavedCardRemove"]}'")
      touch("button marked:'#{IOS_STRINGS["WAMSavedCardRemove"]}'")
      wait_for_none_animating
    end

    wait_for(:timeout => 30){element_exists("button marked:'ApplePayBTN 44pt  whiteLine lo'")}
    wait_for(:timeout => 30){element_exists("button marked:'#{IOS_STRINGS["WAMCheckoutCardButton"]}'")}
    touch("button marked:'#{IOS_STRINGS["WAMCheckoutCardButton"]}'")
    wait_for_none_animating

    wait_for(:timeout => 30){element_exists("UITextField index:0")}
    touch("UITextField index:0")
    wait_for_keyboard
    keyboard_enter_text('4242424242424242')
    touch("UITextField index:1")
    wait_for_keyboard
    keyboard_enter_text('11')
    touch("UITextField index:2")
    wait_for_keyboard
    keyboard_enter_text('20')
    touch("UITextField index:3")
    wait_for_keyboard
    keyboard_enter_text('123')
    current_user_currency = ACCOUNT[:"#{$account_index}"][:valid_ios_account][:currency_sign]
    query("view isFirstResponder:1", :resignFirstResponder)
    scroll("scrollView", :down)
    wait_for(:timeout => 60){"button {text marked:'Pay' '#{current_user_currency}''#{total_price_after_discount}'"}
    touch("button {text marked:'Pay' '#{current_user_currency}''#{total_price_after_discount}'")
    wait_for(:timeout => 60){element_does_not_exist("button marked:'Pay #{total_price_after_discount}'")}
  end

  # Return to the main page
  def return_to_main_page
    if element_exists(BTN_CLOSE)
      click_button('Close')
    end

    if element_exists(BTN_BACK)
      click_button('Back')
    end
    
    if element_exists(BTN_BACK)
      click_button('Back')
    end
    
    if element_exists(BTN_CLOSE)
      click_button('Close')
    end
  end

  # Payment Successful
  def payment_successful(gift_card_name, quantity, total_price_before_discount, total_price_after_discount, discount)
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMCheckoutPaymentSuccessfulTitle"]}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{ACCOUNT[:"#{$account_index}"][:valid_ios_account][:email]}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{gift_card_name}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{discount}% Discount'")}
    wait_for(:timeout => 30){element_exists("label { text CONTAINS #{total_price_after_discount} #{total_price_before_discount}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMCIHowToRedeemTitle"]}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMCIThingsToKnowTitle"]}'")}
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMConfirmationNoteViewTitle"]}'")}
    wait_for(:timeout => 30,:post_timeout => 1){element_exists("button marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'")}
    touch("button marked:'Close'")
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMRWDetailTitle"]}'")}
  end
end