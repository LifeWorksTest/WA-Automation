class PerksHomePage
	def initialize (browser)
		@BROWSER = browser

		@PERKS_MENU = @BROWSER.div(:class, %w(perks-menu))
		@BTN_MENU_HOME = @BROWSER.div(:class, %w(perks-menu)).a(:text, HERMES_STRINGS['components']['main_menu']['perks_home_page'])
    @LBL_SUGGESTED_RETAILERS = @BROWSER.span(:text, 'Suggested')
    @OFFER_TYPES = []
    
    # Puts every offer type (apart from Restaurants) into an array
    PERKS_FEATURE_ARRAY.each do |offer_type| 
      @OFFER_TYPES.push eval(offer_type[1][:FEATURE_CAROUSEL][:OFFER_TYPE])
    end
    
    @RESTAURANT_HELPER_ARRAY = @OFFER_TYPES.select { |offer_types| !offer_types.include? HERMES_STRINGS['components']['main_menu']['restaurants'] }
  end

  def click_button (button)
    case button
    when 'Perk Homepage'
      @BTN_MENU_HOME.wait_until_present
      @BTN_MENU_HOME.click
      is_visible('main')
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # @param = page
  # @param = feature_array
  # @param = i
  # Feature homepage hash contains 3 values, (1) Class to initialise (2) Page option 1 - eg 'main' (3) Page option 2 eg - 'popular' - 
  # Page options can be toggle with the i argument. i = 1 by default
	def is_visible (page, feature_array = nil, i = 1)
    case page
    when 'main'
      @PERKS_MENU.wait_until_present
      @LBL_SUGGESTED_RETAILERS.wait_until_present
      @BTN_MENU_HOME.wait_until_present
      Watir::Wait.until { @BROWSER.divs(:id, /suggested-/).count > 0 }
    when 'Feature Homepage'
      @FEATURE_HOMEPAGE = eval(feature_array[1][:FEATURE_HOMEPAGE][0]).new @BROWSER
      @FEATURE_HOMEPAGE.is_visible(feature_array[1][:FEATURE_HOMEPAGE][i])
    else
      fail(msg = "Error. is_visible. The option #{page} is not defined in menu.")
    end
  end

  # This method tests the functionality of all enabled perks features
  def validate_perks_homepage
    # If no argument is passed into the check_carousel method, then this method will test the 'suggested' carousel
    check_carousel_functionality

    # This loop validates each feature using the feature array that is initialised in this class
    PERKS_FEATURE_ARRAY.each do |feature_array|

      if check_if_feature_key_value_is_boolean($USER_FEATURE_LIST[feature_array[1][:FEATURE_KEY]])
        @IS_PERK_ENABLED = $USER_FEATURE_LIST[feature_array[1][:FEATURE_KEY]]
      else 
        @IS_PERK_ENABLED = $USER_FEATURE_LIST[feature_array[1][:FEATURE_KEY]] > 0
      end

      check_functionality(feature_array)
    end    
  end

  # @param = feature_array
  # Contains all the methods needed to fully test each perks homepage feature
  def check_functionality (feature_array)
    check_perks_homepage_menu_links(feature_array)
    check_carousel_header_links(feature_array)
    check_call_to_action_buttons(feature_array)
    check_carousel_functionality(feature_array)
    check_see_all_links_redirection(feature_array)
  end
	
  # @param = feature_array
  # Checks that the perks menu links are correctly redirecting the user to the correct feature homepage
  def check_perks_homepage_menu_links (feature_array)
    if @IS_PERK_ENABLED
      eval(feature_array[1][:BTN_PERKS_MENU_FEATURE]).wait_until_present
      eval(feature_array[1][:BTN_PERKS_MENU_FEATURE]).click
      feature_array[1][:FEATURE_KEY] == 'benefit_global_gift_cards' ? i = 2 : i = 1
      is_visible('Feature Homepage', feature_array, i)
      click_button('Perk Homepage')
    else
      Watir::Wait.until { !eval(feature_array[1][:BTN_PERKS_MENU_FEATURE]).present? }
    end
  end

  def check_carousel_header_links (feature_array)
    if @IS_PERK_ENABLED
      feature_array[1][:FEATURE_CAROUSEL][:LABEL]
      eval(feature_array[1][:FEATURE_CAROUSEL][:LABEL]).wait_until_present
      eval(feature_array[1][:FEATURE_CAROUSEL][:LABEL]).click
      feature_array[1][:FEATURE_KEY] == 'benefit_online_shop' ? i = 2 : i = 1
      is_visible('Feature Homepage', feature_array, i)
      click_button('Perk Homepage')
    else
      Watir::Wait.until{ !eval(feature_array[1][:FEATURE_CAROUSEL][:LABEL]).present? }
    end
  end

  # @param = feature_array
  # Checks that the 'Shop Online'/'Restaurants'/'Cinemas'/'Exclusive Offers' homepage redirection buttons are working correctly
	def check_call_to_action_buttons (feature_array)
    if feature_array[1][:BTN_CALL_TO_ACTION] != nil
      if @IS_PERK_ENABLED
        eval(feature_array[1][:BTN_CALL_TO_ACTION]).wait_until_present
        eval(feature_array[1][:BTN_CALL_TO_ACTION]).click
        is_visible('Feature Homepage', feature_array)
        click_button('Perk Homepage')
      else 
        Watir::Wait.until{ !eval(feature_array[1][:BTN_CALL_TO_ACTION]).present? }
      end
    end
  end

  # @param = feature_array
  # Checks carousel scrolling and offer redirection functionality for all enabled features.
  def check_carousel_functionality (feature_array = nil)
    # If feature_array = nil, then the suggested offers carousel is tested
    if feature_array == nil
      check_suggested_carousel
      carousel_id = 'suggested-'
      feature_carousel_label = @LBL_SUGGESTED_RETAILERS
      check_carousel_scroll_functionality(carousel_id, feature_carousel_label)
    else
      @CAROUSEL_ARRAY = feature_array[1][:FEATURE_CAROUSEL]
     
      if @IS_PERK_ENABLED
        carousel_id = @CAROUSEL_ARRAY[:OFFER_ID]
        expected_offer_type = eval(@CAROUSEL_ARRAY[:OFFER_TYPE])
        feature_carousel_label = eval(@CAROUSEL_ARRAY[:LABEL])
        check_carousel_scroll_functionality(carousel_id, feature_carousel_label)
        open_last_offer_in_carousel(carousel_id, expected_offer_type)
      else
        Watir::Wait.until { !eval(@CAROUSEL_ARRAY[:LABEL]).present? }
      end
    end    
  end 

  # @param = carousel_id
  # @param = expected_offer_type
  # Clicks on the last offer in the offer carousel. Then validates the user is taken to the correct offer page
  def open_last_offer_in_carousel (carousel_id, expected_offer_type)
    offer_name = @BROWSER.divs(:id, /#{carousel_id}/).last.div(:index, 11).text.gsub(/\s-\s.*/,'').gsub(' -','')
    actual_offer_type = @BROWSER.divs(:id, /#{carousel_id}/).last.div(:index, 14).text

    @BROWSER.divs(:id, /#{carousel_id}/).last.div(:text, /#{offer_name}/).wait_until_present
    @BROWSER.divs(:id, /#{carousel_id}/).last.div(:text, /#{offer_name}/).fire_event('click')
    @BROWSER.divs(:id, /#{carousel_id}/).last.div(:text, /#{offer_name}/).wait_while_present
    
    # 'Restaurant' offer types are not displayed. Instead, the cuisine type is displayed. 
    if expected_offer_type == HERMES_STRINGS['components']['main_menu']['restaurants']
      # If the actual offer type matches any of the offer types contained in the restaurant_helper_array then this is incorrect
      if @RESTAURANT_HELPER_ARRAY.include? actual_offer_type
        fail(msg = "Error. open_last_offer_in_carousel. offer type is #{actual_offer_type}, but should be #{expected_offer_type}")
      end
    else
      expected_offer_type == actual_offer_type ? nil : fail(msg = "Error. open_last_offer_in_carousel. offer type is #{actual_offer_type}, but should be #{expected_offer_type}")
    end

    validate_offer_page(expected_offer_type, eval(@CAROUSEL_ARRAY[:OFFER_VALIDATOR]), offer_name)
  end

  # @param = carousel_id
  # @param = feature_carousel_label
  def check_carousel_scroll_functionality (carousel_id, feature_carousel_label)
    if carousel_id == 'suggested-' || @IS_PERK_ENABLED
      feature_carousel_label.wait_until_present
      Watir::Wait.until { @BROWSER.divs(:id, /#{carousel_id}/).count > 0 }
      offers_in_carousel = @BROWSER.divs(:id, /#{carousel_id}/).count - 1 
      
      # If there is a clickable arrow on the carousel, then enter the block below
      if feature_carousel_label.parent.parent.div(:class, %w(eap-slick-arrow eap-slick-arrow-next)).present?
        i = 0

        while (feature_carousel_label.parent.parent.div(:class, %w(eap-slick-arrow eap-slick-arrow-next)).present?) && (!@BROWSER.div(:id, "#{carousel_id}#{offers_in_carousel}").present?)
          i == offers_in_carousel ? fail(msg = "Error. check_carousel_functionality. #{feature_carousel_label.text} carousel is not scrolling correctly") : nil
          feature_carousel_label.parent.parent.div(:class, %w(eap-slick-arrow eap-slick-arrow-next)).click
          i += 1  
        end

      end
    end
  end

  # Opens every offer in the 'suggested offers' carousel and verifies that the user is redirected to the correct offer page
  def check_suggested_carousel
    @LBL_SUGGESTED_RETAILERS.wait_until_present
    Watir::Wait.until { @BROWSER.divs(:id, /suggested-/).count > 0 }
    suggested_offers = @BROWSER.divs(:id, /suggested-/)
    
    # For each offer in the suggested carousel, open the offer and validate the offer page
    suggested_offers.each do |carousel_offer|
      offer_name = carousel_offer.div(:index, 11).text.gsub(/\s-\s.*/,'').gsub(' -','')
      offer_type = carousel_offer.div(:index, 14).text
      
      # 'Restaurant' offer types are not displayed. Instead, the cuisine type is displayed.
      # If the current offer type does not match and offer type in the @RESTAURANT_HELPER_ARRAY, then assume the offer is a restaurant offer
      if !@RESTAURANT_HELPER_ARRAY.include? offer_type
        @CAROUSEL_ARRAY = PERKS_FEATURE_ARRAY[:RESTAURANTS_PERK]
        offer_type = HERMES_STRINGS['components']['main_menu']['restaurants']
      else
        # Uses the offer type of the current offer being validated to select the correct feature array
        PERKS_FEATURE_ARRAY.each do |perks_feature_array|
          if eval(perks_feature_array[1][:FEATURE_CAROUSEL][:OFFER_TYPE]) == offer_type
            @CAROUSEL_ARRAY = perks_feature_array[1]
          end
        end
      end

      carousel_offer.div(:index, 11).fire_event('click')
      carousel_offer.wait_while_present
      validate_offer_page(offer_type, eval(@CAROUSEL_ARRAY[:FEATURE_CAROUSEL][:OFFER_VALIDATOR]), offer_name)
    end
  end

  # @param = offer_type
  # @param = offer_validator
  # @param = offer_name
  # Validates that after clicking on an offer inside a carousel, the user is redirected to the correct offer page
  def validate_offer_page (offer_type, offer_validator, offer_name)
    puts "Offer being validated = #{offer_name}"
    offer_validator.wait_until_present
   
    if offer_type == HERMES_STRINGS['offers']['exclusive_offers'] || offer_type == HERMES_STRINGS['offers']['instore_offers'].gsub('-', ' ')
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, offer_name).wait_until_present
      @BROWSER.i(:class, %w(icon-web_close)).wait_until_present
      @BROWSER.i(:class, %w(icon-web_close)).click
      @BROWSER.i(:class, %w(icon-web_close)).wait_while_present
    elsif offer_type == HERMES_STRINGS['components']['main_menu']['restaurants']
      @BROWSER.h1(:text, offer_name).wait_until_present
    else
      @BROWSER.div(:text, offer_name).wait_until_present
    end

    click_button('Perk Homepage')
  end

  # @param = feature_array
  # Checks that the 'See All' links which are situated next to each perks carousel are redirecting the user to the correct feature homepage
  def check_see_all_links_redirection (feature_array)
    if @IS_PERK_ENABLED
      eval(feature_array[1][:FEATURE_CAROUSEL][:LABEL]).parent.div(:class, %w(primary-link)).wait_until_present
      eval(feature_array[1][:FEATURE_CAROUSEL][:LABEL]).parent.div(:class, %w(primary-link)).click
      feature_array[1][:FEATURE_KEY] == 'benefit_online_shop' ? i = 2 : i = 1
      is_visible('Feature Homepage', feature_array, i)
    else
      Watir::Wait.until { !eval(feature_array[1][:FEATURE_CAROUSEL][:LABEL]).parent.div(:class, %w(primary-link)).present? }
    end

    click_button('Perk Homepage')
  end

  # This method returns true if the object passes in a boolean value. 
  # Some feature keys values do not use bool values to signify if they are enble/disabled
  def check_if_feature_key_value_is_boolean (object)  
    object.is_a?(TrueClass) || object.is_a?(FalseClass) 
  end
end