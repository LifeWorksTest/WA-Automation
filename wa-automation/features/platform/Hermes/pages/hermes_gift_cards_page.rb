# -*- encoding : utf-8 -*-
class HermesGiftCardsPage
  def initialize (browser)
    @BROWSER = browser
    @BTN_BUY_NOW = @BROWSER.button(:text, HERMES_STRINGS["giftcards"]["buy_now"])
    @BTN_CONFIRM_PAYMENT = @BROWSER.button(:text, HERMES_STRINGS["giftcards"]["confirm_payment"])

    @VIEW_GIFT_CARDS_WINDOW = "div[style^='padding: 15px 30px; margin-bottom: 15px; background-color: white; text-align: left; border-bottom: 1px solid rgb(222, 222, 222);']"
    @BTN_GIFTCARD_BOX = "div[style^='position: relative; overflow: hidden; width: initial; height: 200px; display: block; text-align: center;']"
  end

  def is_visible (page)
    case page
    when 'Home'
      @BROWSER.h2(:text, HERMES_STRINGS["giftcards"]["home"]).wait_until_present
      @BROWSER.h2(:text, HERMES_STRINGS["giftcards"]["home"]).parent.img.wait_until_present
      @BROWSER.a(:text, HERMES_STRINGS["giftcards"]["ask_question"].upcase).wait_until_present
      Watir::Wait.until { @BROWSER.lis(:id => /item-/).count > 0}
    when 'Popular'
      @BROWSER.div(:text, HERMES_STRINGS["components"]["main_menu"]["gift_cards"]).wait_until_present
      @BROWSER.h2(:text, HERMES_STRINGS["constants"]["categories"]["popular"]).wait_until_present
    when 'Buy this Gift Card'
      @BROWSER.div(:text, /Enter Gift Card Value/).wait_until_present
      @BROWSER.div(:text, /#{HERMES_STRINGS["giftcards"]["buy_this_giftcard"]}/i).wait_until_present
      @BROWSER.a(:text, HERMES_STRINGS["giftcards"]["ask_question"].upcase).wait_until_present 
      Watir::Wait.until {
        @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["buy_this_giftcard"]).parent.div(:index, 1).text != ''
        @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["terms_conditions_title"]).parent.div(:index, 1).text != ''
        @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["about_retailer_title"]).parent.div(:index, 1).text != ''
      }
    when 'Complete your Order'
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["complete_order_title"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["your_order"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["email_main_label"][0..-2]).wait_until_present
    when 'Confirmation'
      @BROWSER.div(:text, /Your Order has been placed successfully/).wait_until_present
      Watir::Wait.until {
        @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["how_to_redeem_title"]).parent.div(:index, 1).text != ''
        @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["important_things_to_know"]).parent.div(:index, 1).text != ''
        @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["note"]).parent.div(:index, 1).text != ''
        @BROWSER.element(css: "div[style^='font-size: 14px; vertical-align: bottom;']").strong.text.length > 3
      }

      @ORDER_ID = (/\w+/.match @BROWSER.element(css: "div[style^='font-size: 14px; vertical-align: bottom;']").strong.text).to_s
    when 'View your Gift Card Codes'
      @BROWSER.div(:class, 'ReactModal__Content ReactModal__Content--after-open').div(:text, 'Gift Card Codes').wait_until_present
      @BROWSER.element(css: @VIEW_GIFT_CARDS_WINDOW).div(:text, "#{FileService.new.get_from_file("current_gift_card:")[0..-2]}").wait_until_present
      @BROWSER.element(css: @VIEW_GIFT_CARDS_WINDOW).div(:text, "#{@CURRENT_USER_CURRENCY}#{sprintf("%.2f", @VALUE)}").wait_until_present
      @BROWSER.element(css: @VIEW_GIFT_CARDS_WINDOW).div(:text, /#{@ORDER_ID}/).wait_until_present
      @BROWSER.element(css: @VIEW_GIFT_CARDS_WINDOW).button(:text, 'GET MY GIFT CARD').wait_until_present
    when 'GET MY GIFT CARD'
      Watir::Wait.until { @BROWSER.windows.count == 2 }
      @BROWSER.windows.last.use 
      Watir::Wait.until { 
        @BROWSER.form(:id, 'reCaptchaForm').present? ||
        @BROWSER.h1(:text, /Your .* eGift card/).present?
      }
      
      @BROWSER.window.close
      Watir::Wait.until { @BROWSER.windows.count == 1 }
    end
  end

  def click_button (button)
    case button
    when 'BUY NOW'
      @BTN_BUY_NOW.wait_until_present
      @BTN_BUY_NOW.click
      is_visible('Complete your Order')
    when 'CONFIRM PAYMENT'
      @BTN_CONFIRM_PAYMENT.wait_until_present
      @BTN_CONFIRM_PAYMENT.click
      is_visible('Confirmation')
    when 'View your Gift Card Codes'
      @BROWSER.span(:text, 'View your Gift Card Codes').wait_until_present
      @BROWSER.span(:text, 'View your Gift Card Codes').click
      is_visible('View your Gift Card Codes')
    when 'Close View your Gift Card Codes'
      @BROWSER.div(:class, 'ReactModal__Content ReactModal__Content--after-open').i(:class, 'icon-web_close').wait_until_present
      @BROWSER.div(:class, 'ReactModal__Content ReactModal__Content--after-open').i(:class, 'icon-web_close').click
      @BROWSER.div(:class, 'ReactModal__Content ReactModal__Content--after-open').wait_while_present
    when 'GET MY GIFT CARD'
      @BROWSER.element(css: @VIEW_GIFT_CARDS_WINDOW).button(:text, 'GET MY GIFT CARD').wait_until_present
      @BROWSER.element(css: @VIEW_GIFT_CARDS_WINDOW).button(:text, 'GET MY GIFT CARD').click
      is_visible('GET MY GIFT CARD')
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in the menu.")
    end
  end

  # Open category
  # @param category
  def open_category (category)
    @BROWSER.li(:id, /item-/).wait_until_present

    if category == 'random'
      category = @BROWSER.li(:id => /item-/, :index => rand(@BROWSER.lis(:id, /item-/).count - 1)).text
    end

    puts "category:#{category}"
    @CATEGORY = category
    @BROWSER.li(:id => /item-/, :text => category).wait_until_present
    @BROWSER.li(:id => /item-/, :text => category).click
    @BROWSER.li(:id => /item-/, :text => category).wait_until_present
  end

  # Validate data of gift cards in the current screen
  def validate_data_of_cards
    @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present
    number_of_cards = @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count
     
    for i in 0..number_of_cards - 1 
      @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present
      gift_card_cashback = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 9).text
      gift_card_name = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 10).text
      @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 10).fire_event('click')
      is_visible('Buy this Gift Card')
      @BROWSER.div(:text, /#{gift_card_name}/).wait_until_present

      @BROWSER.back
      @BROWSER.h2(:text, @CATEGORY).wait_until_present

      i % 5 == 0 ? (@BROWSER.div(:id, 'view').send_keys :space) : nil
    end
  end

  # Open gift card page according the given name
  # @param card_name
  def open_gift_card_page (card_name)
    @card_name = card_name
    short_card_name = card_name.length > 17 ? card_name[0,17] : card_name
   
    i = 0

    while !@BROWSER.div(:text, /#{short_card_name}/).present?
      @BROWSER.div(:id, 'view').send_keys :space
      sleep(0.5)
      i += 1
      
      if i == 5
        fail(msg = "Error. open_gift_card_page. Couldn't find #{short_card_name} in the Gift Card list.")
      end
    end
    
    @BROWSER.div(:text, /#{short_card_name}/).fire_event 'mouseover'
    @BROWSER.div(:text, card_name).wait_until_present
    @BROWSER.div(:text, card_name).click
    is_visible('gift card page')
  end

  # Buy gift card
  # @parem value - of each card
  # @parem quantity - of cards
  def buy_gift_card (quantity, gift_card_name, value = nil)$USER_FEATURE_LIST['social_colleague_directory']
    company_discount_tier = "tier_#{$USER_FEATURE_LIST['benefit_global_gift_cards']}"
    @BROWSER.div(:text, gift_card_name).wait_until_present
    cashback_value = ((@BROWSER.div(:text, gift_card_name).parent.parent.text).match /\d+/)[0].to_f
    cashback_value.to_i != $GIFT_CARD_HASH[:"#{company_discount_tier}"] ? fail(msg = "Error. buy_gift_card. Cashback value is #{cashback_value} but it should be #{$GIFT_CARD_HASH[:"#{company_discount_tier}"]}") : nil

    open_gift_card_page(gift_card_name)

    @BROWSER.div(:text, gift_card_name).parent.div(:class => 'info-with-links', :text => $GIFT_CARD_HASH[:description]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS['giftcards']['terms_conditions_title']).parent.div(:class => 'info-with-links', :text => $GIFT_CARD_HASH[:terms_and_conditions]).wait_until_present
    @CURRENT_USER_CURRENCY = ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]

    Watir::Wait.until {
      @BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["gift_card_amount"]).present? ||
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["enter_value"]).present?
    }

    # if amount is value type
    if @BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["gift_card_amount"]).exists?
      if value == nil
        value = 25
      end

      @BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["gift_card_amount"]).send_keys value
      Watir::Wait.until {@BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["gift_card_amount"]).value != value}
    else
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["enter_value"]).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["enter_value"]).parent.i(:class, 'icon-web_arrow_down').wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["enter_value"]).parent.i(:class, 'icon-web_arrow_down').click
      
      if value == nil
        @BROWSER.div(:class, 'flag__body').wait_until_present
        sleep(2)
        value = (@BROWSER.div(:class, 'flag__body').text.match /\d+/)[0]
      end

      @BROWSER.div(:class => 'flag__body', :text => /#{@CURRENT_USER_CURRENCY}#{value}.00/).wait_until_present
      @BROWSER.div(:class => 'flag__body', :text => /#{@CURRENT_USER_CURRENCY}#{value}.00/).fire_event :click
      @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["enter_value"]).parent.div(:text, /#{@CURRENT_USER_CURRENCY}#{value}.00/).wait_until_present

    end     
    
    total_price_before_discount = value.to_i * quantity.to_i
    total_price_after_discount = total_price_before_discount * ((100 - cashback_value) / 100)
    puts "total_price_before_discount:#{total_price_before_discount}                  total_price_after_discount:#{total_price_after_discount}           cashback_value:#{cashback_value}"
    price_before_and_after_discount = "#{@CURRENT_USER_CURRENCY}#{sprintf('%.2f', total_price_after_discount.to_s)}#{@CURRENT_USER_CURRENCY}#{sprintf('%.2f', total_price_before_discount.to_s)}"
    Watir::Wait.until{ @BROWSER.element(css:"div[style^='display: inline-block; vertical-align: middle; width: calc(100% - 125px);'").text.include? "#{price_before_and_after_discount}" }
    
    click_button('BUY NOW')

    complete_order(gift_card_name, total_price_before_discount, total_price_after_discount)
    confirmation(gift_card_name, total_price_before_discount, total_price_after_discount)
    @VALUE = value
  end

  # Complete user gift card order
  # @parem total_price_before_discount
  # @parem total_price_after_discount
  def complete_order (card_name, total_price_before_discount, total_price_after_discount)
    is_visible('Complete your Order')
    @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["order_summary"]).parent.parent.div(:text, /#{card_name}\n#{@CURRENT_USER_CURRENCY}#{total_price_before_discount}.00/).present?
    @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["order_summary"]).parent.span(:index => 1, :text => "#{@CURRENT_USER_CURRENCY}#{total_price_after_discount}#{@CURRENT_USER_CURRENCY}#{total_price_before_discount}")
    @BROWSER.input(:value, $current_user_email).wait_until_present
    
    Watir::Wait.until {
      @BROWSER.a(:text, HERMES_STRINGS["giftcards"]["remove"].upcase).present? ||
      @BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["credit_card_number"]).present?
    }
    
    if @BROWSER.a(:text, HERMES_STRINGS["giftcards"]["remove"].upcase).exists?
      @BROWSER.a(:text, HERMES_STRINGS["giftcards"]["remove"].upcase).click
      @BROWSER.button(:text, HERMES_STRINGS["giftcards"]["remove"].upcase).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["giftcards"]["remove"].upcase).click
    end

    @BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["credit_card_number"]).wait_until_present
    @BROWSER.input(:placeholder, HERMES_STRINGS["giftcards"]["credit_card_number"]).send_keys '4242424242424242'

    @BROWSER.span(:text, 'MM').click
    @BROWSER.div(:text, '01').wait_until_present
    @BROWSER.div(:text, '01').fire_event :click

    @BROWSER.span(:text, 'YY').click
    @BROWSER.div(:text, '20').wait_until_present
    @BROWSER.div(:text, '20').fire_event :click

    @BROWSER.input(:placeholder, '123').wait_until_present
    @BROWSER.input(:placeholder, '123').send_keys '123'

    click_button('CONFIRM PAYMENT')
  end

  # Confirm user gift card order after purchase
  # @parem total_price_before_discount
  # @parem total_price_after_discount
  def confirmation (card_name, total_price_before_discount, total_price_after_discount)
    @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["order_summary"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["order_summary"]).parent.parent.div(:text, /#{card_name}\n#{@CURRENT_USER_CURRENCY}#{total_price_before_discount}.00/).present?
    @BROWSER.div(:text, HERMES_STRINGS["giftcards"]["order_summary"]).parent.span(:index => 1, :text => "#{@CURRENT_USER_CURRENCY}#{total_price_after_discount}#{@CURRENT_USER_CURRENCY}#{total_price_before_discount}.00")
    @BROWSER.div(:text, "#{HERMES_STRINGS["giftcards"]["email_main_label"]}#{$current_user_email}").wait_until_present
  end

  # Checks that the 'View GiftCard Codes' links displays the last purchased code info and redirected the user to the captcha page
  def verify_view_giftcard_codes_link_redirection
    click_button('View your Gift Card Codes')
    click_button('GET MY GIFT CARD')
    click_button('Close View your Gift Card Codes')
  end

  # Searches for a giftcard using the string contained in the gift_card_name variable
  # @param gift_card_name
  # @param suggested_search
  def search_for_gift_card (gift_card_name, suggested_search)
    @BROWSER.div(:class, 'icon-web_search').wait_until_present
    
    if suggested_search
      index = (gift_card_name.size.to_f / 2).ceil
      search_string = gift_card_name[0, index]
    else
      search_string = gift_card_name
    end

    puts "Search string is - #{search_string} - GiftCard Name - #{gift_card_name}"
    @BROWSER.div(:class, 'icon-web_search').parent.input.send_keys search_string
    @BROWSER.div(:class, 'icon-web_search').parent.input(:value, search_string).wait_until_present
    
    if suggested_search
      @BROWSER.div(:class, 'icon-web_search').parent.parent.span(:text, gift_card_name).wait_until_present
      @BROWSER.div(:class, 'icon-web_search').parent.parent.span(:text, gift_card_name).click
    else
      @BROWSER.div(:class, 'icon-web_search').click
    end
  end

  # Validates giftcard search functionality is working when results are/are not expected
  # @param gift_card_exists
  # @param suggested_search
  def validate_gift_card_search_functionality (gift_card_exists, suggested_search)
    # If gift card should return a result, grab the name of a random giftcard that is located on the current page
    if gift_card_exists
      @BROWSER.div(:class, 'white-flag-icon white-flag-icon__box').wait_until_present
      ( @BROWSER.divs(:class, 'white-flag-icon white-flag-icon__box').count > 1 ) ? index = rand(@BROWSER.divs(:class, 'white-flag-icon white-flag-icon__box').count - 1) : index = 0
      gift_card_name = @BROWSER.div(:class => 'white-flag-icon white-flag-icon__box', :index => index).parent.parent.div(:index, 10).text
    else
    # If Giftcard search should not return any results, then set the search string to 'does not exist'
      gift_card_name = 'does not exist'
    end

    search_for_gift_card(gift_card_name,suggested_search)
    
    if ( gift_card_exists && !suggested_search )
    # User should see the search for giftcard as the first card in the list of results
      @BROWSER.div(:class => 'white-flag-icon white-flag-icon__box', :index => 0).parent.parent.div(:text, gift_card_name).wait_until_present
      @BROWSER.h2(:text, "#{HERMES_STRINGS['giftcards']['search_results']}: #{gift_card_name}").wait_until_present
    elsif ( gift_card_exists && suggested_search )
    # User should be redirected to the giftcard page that was searched on if the clicked on the suggested search list item
      is_visible('Buy this Gift Card')
      @BROWSER.div(:text, gift_card_name).wait_until_present
    else
    # User should see a no search results and a message that says 'No gift cards found'
      @BROWSER.h3(:text, /#{HERMES_STRINGS['giftcards']['no_gift_cards']}/).wait_until_present
      @BROWSER.div(:class => 'white-flag-icon white-flag-icon__box').wait_while_present
    end
  end

  def verify_giftcard_enabled_disabled
    $GIFT_CARD_HASH[:enabled_disabled] == 'enabled' ? @BROWSER.div(:text, /#{$GIFT_CARD_HASH[:gift_card_name]}/).wait_until_present : Watir::Wait.until {  ! @BROWSER.div(:text, /#{$GIFT_CARD_HASH[:gift_card_name]}/).present? }
  end
end