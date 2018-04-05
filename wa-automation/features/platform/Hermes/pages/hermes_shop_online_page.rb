# -*- encoding : utf-8 -*-
class HermesShopOnlinePage
   
  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new
    
    if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_CA' 
      index = 0 
    else
      index = 1
    end
    
    @BTN_SEE_RECOMMENDED_CASHBACK_AND_OFFERS = @BROWSER.span(:text => HERMES_STRINGS["shop_online"]["hub"]["recommended"], :index => index).parent.div(:class, 'primary-link')
    @BTN_SEE_ALL_POPULAR_CASHBACK_AND_OFFERS = @BROWSER.span(:text => HERMES_STRINGS["shop_online"]["hub"]["popular"], :index => index).parent.div(:class, 'primary-link')
    @BTN_SEE_ALL_FEATURED_CASHBACK_AND_OFFERS = @BROWSER.span(:text, HERMES_STRINGS["shop_online"]["hub"]["featured"]).parent.div(:class, 'primary-link')

    @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["menu_title"]).wait_until_present

    if @BROWSER.button(:text, HERMES_STRINGS["components"]["interests_cta"]["label_3"]).present?
      click_button('Select interests')
      select_interests
      @BROWSER.refresh
    end

    @BROWSER.div(:text, HERMES_STRINGS["constants"]["categories"]["featured"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["constants"]["categories"]["recommended"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["constants"]["categories"]["popular"]).wait_until_present  

    @RETAILER_CURRENCY = ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]
    @LBL_BOOSTED_CASHBACK = HERMES_STRINGS["online_shop"]["modal"]["boosted_cashback"]
    @LBL_CASHBACK = HERMES_STRINGS["shop_online"]["cashback"]
    
    @BTN_GET_OFFER = @BROWSER.button(:text, /#{HERMES_STRINGS["shop_online"]["get_offer"]}/i)
    @BTN_GET_CASHBACK = @BROWSER.button(:text, HERMES_STRINGS["shop_online"]["get_cashback"])
    @BTN_VIEW_FAVOURITES = @BROWSER.span(:text, HERMES_STRINGS["shop_online"]["favourite"])
    @BTN_BACK_TO_HOMEPAGE = @BROWSER.button(:text, HERMES_STRINGS["shop_online"]["back"])

    @RETAILER_TYPE = nil
    @RETAILER_CATEGORY = nil
    @RETAILER_NAME = nil
  end

  def is_visible (page)
    @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["menu_title"]).wait_until_present
    Watir::Wait.until { @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["menu_title"]).parent.lis.count > 10 }

    case page
    when 'main'
      @BTN_SEE_RECOMMENDED_CASHBACK_AND_OFFERS.wait_until_present
      @BTN_SEE_ALL_POPULAR_CASHBACK_AND_OFFERS.wait_until_present
    when 'category'
      @BROWSER.span(:text, /• \d+/).wait_until_present
      
      Watir::Wait.until {
        @BTN_BACK_TO_HOMEPAGE.present? ||
        (/\d+/.match (@BROWSER.span(:text, /•/).text)).to_s.to_i > 1
      }

      if @BTN_BACK_TO_HOMEPAGE.present?
        @BROWSER.span(:text, /(#{HERMES_STRINGS["shop_online"]["retailers"]}|#{HERMES_STRINGS["shop_online"]["offers"]})/).present?
        @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["empty"]).wait_until_present
        puts 'No retailers/offers contained in category. Picking a new category.'
        select_category
      end

      if (/\d+/.match (@BROWSER.span(:text, /•/).text)).to_s.to_i > 12 
        Watir::Wait.until { @BROWSER.ul(:class, 'pagination').present? } 
      elsif @BROWSER.ul(:class, 'pagination').present?
        fail(msg = 'Error. is_visible. Pagination is visible on the page, but there are less than 13 retailers in this category')
      end
  
    when 'View Favourites'
      Watir::Wait.until { @BROWSER.lis(:id, /item-/).count > 0 }
      @BROWSER.span(:text, /#{HERMES_STRINGS["shop_online"]["favourite"]} • \d+/).wait_until_present

      number_of_items_in_favourites = /\d+/.match @BROWSER.span(:text, /#{HERMES_STRINGS["shop_online"]["favourite"]} • \d+/).text
      number_of_items_in_favourites = number_of_items_in_favourites.to_s.to_i
      
      Watir::Wait.until { number_of_items_in_favourites == @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count }
    when 'Featured'
      @BROWSER.span(:text, /#{HERMES_STRINGS["shop_online"]["hub"]["featured"]} • \d+/).wait_until_present
      @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["menu_title"]).wait_until_present
    else
      fail(msg = "Error. click_button. The option #{page} is not defined in menu.")
    end
  end

  def click_button (button)
    case button
    when 'Select interests'
      @BROWSER.button(:text, HERMES_STRINGS["components"]["interests_cta"]["label_3"]).wait_until_present
      @BROWSER.button(:text, HERMES_STRINGS["components"]["interests_cta"]["label_3"]).click
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["components"]["interests_modal"]["title"]).wait_until_present
    when 'Get Cashback'
      @BTN_GET_CASHBACK.wait_until_present
      @BTN_GET_CASHBACK.click
    when 'Get offer'
      @BTN_GET_OFFER.wait_until_present
      @BTN_GET_OFFER.click
    when 'View Favourites'
      @BTN_VIEW_FAVOURITES.wait_until_present
      @BTN_VIEW_FAVOURITES.scroll.to :bottom
      @BTN_VIEW_FAVOURITES.click
      @BROWSER.div(:id, 'spinner').wait_while_present
      is_visible('View Favourites')  
    when 'Back to homepage'
      @BTN_BACK_TO_HOMEPAGE.wait_until_present
      @BTN_BACK_TO_HOMEPAGE.click
      @BTN_BACK_TO_HOMEPAGE.wait_while_present
      @BTN_VIEW_FAVOURITES.wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Select user interests
  def select_interests
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["sign_up"]["interests"]["categories"]["sports"]).wait_until_present
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["sign_up"]["interests"]["categories"]["sports"]).click
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["sign_up"]["interests"]["categories"]["health"]).wait_until_present
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["sign_up"]["interests"]["categories"]["health"]).click
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["sign_up"]["interests"]["categories"]["home_garden"]).wait_until_present
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["sign_up"]["interests"]["categories"]["home_garden"]).click
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).button(:text, HERMES_STRINGS["components"]["interests_modal"]["submit"]).when_present.click
    
    if @BROWSER.section(:class, %w(interests-cta ng-scope)).present?
      fail('Error. select_interests. Select interests is still visible after selecting interests')
    end

    sleep(2)
  end

  # Select catergory by the given name or index
  # @param name
  # @param index
  # @param random
  def select_category (category = nil, index = nil)
    @BROWSER.refresh
    @BROWSER.li(:id, /item/).wait_until_present

    # If no category or index is passed, then a count is made of all available categories on the page and a random index/category is chosen. 
    if (category == nil || category == '' ) && (index == nil)
      index = rand(@BROWSER.lis(:id, /item/).count - 1)
      @RETAILER_CATEGORY = @BROWSER.li(:id => /item/, :index => index).text
    end

    # If index = nil, then we open the category according to the external data file value (eg - Not random)
    if index == nil
      @BROWSER.li(:text, category).wait_until_present
      @BROWSER.div(:class, %w(preloader velocity-animating)).wait_while_present
      @BROWSER.li(:text, category).click
    else
    # If the retailer index is not nil (this is used for random categories), then the stored index is used to open the category
      @BROWSER.li(:id => /item/, :index => index).wait_until_present
      @RETAILER_CATEGORY = @BROWSER.li(:id => /item/, :index => index).text
      puts "category = #{@RETAILER_CATEGORY}"
      @BROWSER.li(:id => /item/, :index => index).click
    end

    @BROWSER.div(:class, %w(preloader velocity-animating)).wait_while_present
    @BROWSER.span(:text, /#{@RETAILER_CATEGORY} •/).wait_until_present
    is_visible('category')
  end

  def select_retailer_type (retailer_type = nil)
    if @RETAILER_TYPE == nil
      @RETAILER_TYPE = retailer_type
    end

    @RETAILER_TYPE == 'retailers' ? (@RETAILER_NAME_INDEX = 10) && (@CASHBACK_INDEX = 9) && (@GET_OFFER_BUTTON = @BTN_GET_CASHBACK) : (@RETAILER_NAME_INDEX = 11) && (@CASHBACK_INDEX = 10) && (@GET_OFFER_BUTTON = @BTN_GET_OFFER) && (@EXPIRY_INDEX = 15)

    view = HERMES_STRINGS["shop_online"]["view"].gsub(' ','')
    @BROWSER.span(:text, view).parent.div(:text, HERMES_STRINGS["shop_online"]["retailers"]).wait_until_present
    @BROWSER.span(:text, view).parent.div(:text, HERMES_STRINGS["shop_online"]["offers"]).wait_until_present
    @BROWSER.span(:text, view).parent.div(:text, HERMES_STRINGS["shop_online"]["#{@RETAILER_TYPE}"]).click
    @BROWSER.span(:text, /• \d+ #{HERMES_STRINGS["shop_online"]["#{@RETAILER_TYPE}"]}/).wait_until_present
  end

  # Sort and check results
  # @param sort_option
  def sort_by (sort_option)
    @BROWSER.div(:text, "#{HERMES_STRINGS["shop_online"]["sort"]}:").parent.div(:index, 1).wait_until_present
    @BROWSER.div(:text, "#{HERMES_STRINGS["shop_online"]["sort"]}:").parent.div(:index, 1).click

    @BROWSER.div(:text, "#{HERMES_STRINGS["shop_online"]["sort"]}:").parent.div(:index, 2).div(:text, SHOP_ONLINE_SORT_OPTIONS[:"#{sort_option}"]).wait_until_present
    @BROWSER.div(:text, "#{HERMES_STRINGS["shop_online"]["sort"]}:").parent.div(:index, 2).div(:text, SHOP_ONLINE_SORT_OPTIONS[:"#{sort_option}"]).click
    sleep(2)
  end

  # Check sort highest cashback - Can limit amount of pages and categories to validate per test 
  # @param pages_to_validate
  # @param sort_type
  # @param amt_of_categories
  def check_sort_filters (retailers_or_offers_to_validate, retailer_type, sort_type, amt_of_categories)
    category_to_select = (0..@BROWSER.lis(:id, /item/).count - 1).to_a.sample(amt_of_categories.to_i)
    
    category_to_select.each do |category_index|
      i = 0
      retailers_or_offers_validated = 0

      select_category(nil,category_index)
      select_retailer_type(retailer_type)
      sort_by(sort_type)
      
      if sort_type == 'Highest Cashback' 
        sort_index = @CASHBACK_INDEX
      elsif sort_type == 'Ending Soon' 
        sort_index = @EXPIRY_INDEX
      elsif sort_type == 'Alphabetical Order'
        sort_index = @RETAILER_NAME_INDEX
      end

      @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present

      while (retailers_or_offers_validated < retailers_or_offers_to_validate)
        @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).wait_until_present
        @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i+1).wait_until_present

        retailer_name_1 = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, @RETAILER_NAME_INDEX).text.gsub(/\s-\s.*/,'')
        retailer_name_2 = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i+1).parent.parent.div(:index, @RETAILER_NAME_INDEX).text.gsub(/\s-\s.*/,'')

        if sort_type == 'Highest Cashback' || sort_type == 'Alphabetical Order'
          sort_value_1 = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, sort_index).text   
          sort_value_2 = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i+1).parent.parent.div(:index, sort_index).text

          if (sort_type == 'Highest Cashback') && (!sort_value_1.include? HERMES_STRINGS["global"]["upto"]) && (!sort_value_2.include? HERMES_STRINGS["global"]["upto"])
            sort_value_1 = (/\d+/.match sort_value_1)[0].to_i
            sort_value_2 = (/\d+/.match sort_value_2)[0].to_i
            puts "Retailer1:#{retailer_name_1} Cashback:#{sort_value_1}"
            puts "Retailer2#{retailer_name_2} Cashback:#{sort_value_2}"

            if sort_value_1 < sort_value_2
              fail("Error. check_sort_filters. List is not sorted. #{retailer_type} name 1 = #{retailer_name_1}:Cashback Rate = #{sort_value_1}. #{retailer_type} name 2 = #{retailer_name_2}:Cashback Rate = #{sort_value_2}")
            end
          elsif sort_type == 'Alphabetical Order'
            puts "Retailer/Offer name:#{retailer_name_1}"
            puts "Retailer/Offer name:#{retailer_name_2}"
          
            if retailer_name_1.downcase > retailer_name_2.downcase
              fail("Error. check_sort_filters. List is not sorted Alphabetically ---- #{retailer_type} name 1 = #{retailer_name_1} ---- #{retailer_type} name 2 = #{retailer_name_2}")
            end
          end
        elsif sort_type == 'Ending Soon'
          if @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, sort_index).present?
            sort_value_1 = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, sort_index).text
            else
            sort_value_1 = 'No Expiry Date'
          end
          
          if @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i+1).parent.parent.div(:index, sort_index).present?
            sort_value_2 = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i+1).parent.parent.div(:index, sort_index).text
          else
            sort_value_2 = 'No Expiry Date'
          end

          puts "Retailer1:#{retailer_name_1} Expiry Date:#{sort_value_1}"
          puts "Retailer2#{retailer_name_2} Expiry Date:#{sort_value_2}"
          
          if sort_value_1 == HERMES_STRINGS["shop_online"]["expired"]|| sort_value_2 == HERMES_STRINGS["shop_online"]["expired"]
            fail("Error. check_sort_filters. Expired offers should not be imported. #{retailer_type} name 1 = #{retailer_name_1}:#{sort_value_1}. #{retailer_type} name 2 =  #{retailer_name_2}:#{sort_value_2}")
          elsif Date.parse(sort_value_1) > Date.parse(sort_value_2)
            fail("Error. check_sort_filters. List is not sorted. #{retailer_type} name 1 = #{retailer_name_1}:#{sort_value_1}. #{retailer_type} name 2 = #{retailer_name_2}:#{sort_value_2}")
          end
        end
        
        retailers_or_offers_validated += 1

        if !@BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i + 2).present?
          if @BROWSER.li(:class, 'next').present?
            @BROWSER.li(:class, 'next').click
            puts "About to validate next page of offers"
            i = 0
          else
            puts "#{retailers_or_offers_validated} offers have been validated. #{retailers_or_offers_to_validate} offers should have been validated but there are not enough available to validate."
            break 
          end         
        else  
          i += 1
        end
      end
    end
  end

  # Open retailer
  # @param retailer
  # @param index
  # @param random
  def open_retailer (retailer, index = nil) 
    is_visible('category')
    
    # If no retailer or index is sent to this method, a count is made of retailers on the page and a random index is chosen. 
    # The retailer name of this random retailer is inserted to the ext data file
    if (retailer == nil || retailer == '' ) && (index == nil)
      index = rand(@BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count - 1)
      @RETAILER_NAME = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, @RETAILER_NAME_INDEX).text
    end

    # If index = nil, then a search is executed of all retailer on the page for a retailer card that includes the oretailer_name text. 
    # We then use the index of this card to click on the retailer card after the loop is completed
    if index == nil
      index = 0

      while @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).present?
        if @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, @RETAILER_NAME_INDEX).text.include? retailer
          break
        else
          index += 1
        end
      end
    end

    @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, @RETAILER_NAME_INDEX).wait_until_present
    @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, @RETAILER_NAME_INDEX).click
  end

  # Favourite or unfavourite retailer
  # @param action
  # @param random
  def favourite_or_unfavourite_retailer (action)
    @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present
    
    # If we are not on the retailer's/Offer's page or the View Favourites page then we just set the index to 0
    if (!@GET_OFFER_BUTTON.present?) && (!@BROWSER.span(:text, /#{HERMES_STRINGS["shop_online"]["favourite"]} •/).present?)
      # The retailer name of this random retailer is inserted to the ext data file
      if @RETAILER_NAME == nil
        index = rand(@BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count - 1)
        @RETAILER_NAME = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, @RETAILER_NAME_INDEX).text
      # If the random retailer field in the ext data file is populated, then a search is executed of all 
      # retailers on the page for a retailer card that includes the retailer_name text. 
      else @RETAILER_NAME != nil
        index = 0
        # If we are on the retailers page then this block below is skipped an dthe index stays at 0
        while !@BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 8).text.include? @RETAILER_NAME
          index += 1
        end
      end
    # This is used for unfavouriting any retailers that have been favourited in a previously failed test (executed before the main test begins)
    else
      index = 0
    end
    # Clicks the the favourite/unfavourite star for a retailer
    @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).click
    # action == 'add' ? add_or_remove_favourite = 'added_to_favourite' : add_or_remove_favourite = 'removed_to_favourite'
    action == 'add' ? add_or_remove_favourite = 'added to your favourites' : add_or_remove_favourite = 'removed from your favourites'
    # @BROWSER.p(:text, HERMES_STRINGS["shop_online"]["#{add_or_remove_favourite}"]).wait_until_present
    # @BROWSER.p(:text, HERMES_STRINGS["shop_online"]["#{add_or_remove_favourite}"]).wait_while_present
    @BROWSER.p(:text, /#{add_or_remove_favourite}/).wait_until_present
    @BROWSER.p(:text, /#{add_or_remove_favourite}/).wait_while_present
  end
  
  # Validate if retailer is in favourites section or not
  # @param state
  def validate_retailer_is_in_favourites (state)
    retailer_name = @RETAILER_NAME.gsub(/\s-\s.*/,'')
    retailer_count = @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count
    click_button('View Favourites')
    select_retailer_type(@RETAILER_TYPE)

    if state == 'is in'
      @BROWSER.div(:text, /#{retailer_name}/).wait_until_present
    elsif state == 'is not in'
      if  @BROWSER.div(:text, /#{retailer_name}/).present?
        fail(msg = "Error. check_if_in_favourites. Retailer #{retailer_name} should not be in favourites.")
      end
    end

    @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["menu_title"]).wait_until_present
    @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["menu_title"]).click
    @BROWSER.span(:text, /#{HERMES_STRINGS["shop_online"]["favourite"]} •/).wait_while_present
  end

  def remove_all_retailers_from_favourites(retailer_type)
    click_button('View Favourites')
    select_retailer_type(retailer_type)

    while @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).present?
      favourite_or_unfavourite_retailer('remove')
    end 

    click_button('Back to homepage')
  end
  
  # Validates retailers data by iterating over x number of pages of retiailers per category and checking important information is correct per retailer
  # @param pages_to_validate
  # @param amt_of_categories
  def validate_retailers_data (retailers_or_offers_to_validate, retailer_type, amt_of_categories)
    # Creates a random sample of x amount of categories to select. x = amt_of_categories variable
    category_to_select = (0..@BROWSER.lis(:id, /item/).count - 1).to_a.sample(amt_of_categories.to_i)
    
    category_to_select.each do |category_index|
      retailers_or_offers_validated = 0
      i = 0

      select_category(nil,category_index)
      select_retailer_type(retailer_type)
      @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present

      while (retailers_or_offers_validated < retailers_or_offers_to_validate)
        @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).wait_until_present
        retailer_name_and_description = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, @RETAILER_NAME_INDEX).text

        if retailer_name_and_description.scan(/ - /).count > 1
          retailer_or_offer_name = /(.*?-.*)\s-/x.match retailer_name_and_description
          retailer_or_offer_name = retailer_or_offer_name[1]
        else
          retailer_or_offer_name = retailer_name_and_description.gsub(/\s-\s.*/,'')
        end

        cashback_amt = (/#{@RETAILER_CURRENCY}?\d+\.?\d?%?/.match @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, @CASHBACK_INDEX).text).to_s
        retailer_or_offer_description = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, @RETAILER_NAME_INDEX).text.gsub(/.*\s-\s/, '').gsub('...', '').gsub('$', '\$')
        
        if retailer_type == 'offers'
          offer_type = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 9).text
        end

        puts "retailer_or_offer_name - #{retailer_or_offer_name}"
        puts "retailer_or_offer_cashback_amt - #{cashback_amt}"
        puts "retailer_or_offer_description - #{retailer_or_offer_description}"
        open_retailer(retailer_name_and_description, i)

        # After retailer is opened, check the Retailer Name, Offer/Share,favouriting buttons, Cashaback Amt & Offer headers are present
        @BROWSER.div(:text, /\+?\s?#{cashback_amt} (#{@LBL_CASHBACK}|#{@LBL_BOOSTED_CASHBACK})/i).wait_until_present
        @GET_OFFER_BUTTON.wait_until_present
        @BROWSER.a(:text, HERMES_STRINGS["shop_online"]["share"].upcase).wait_until_present
        @BROWSER.h4(:text, HERMES_STRINGS["shop_online"]["more_cashback"]).wait_until_present
        @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present

        # Retailer and offer specific checks
        if retailer_type == 'retailers'
          @BROWSER.div(:text, retailer_or_offer_name).wait_until_present
          @BROWSER.div(:text, retailer_or_offer_name).parent.span(:text, /#{retailer_or_offer_description}/).wait_until_present
          
          # Checks that for each cashback rate, there is a seperate 'Share Deal' & 'Get Deal' button 
          if @BROWSER.div(:text, /\d+ #{HERMES_STRINGS["shop_online"]["cashback_rates"]}/).present?
            amt_of_cashback_rates = ((/\d+/.match @BROWSER.element(css: "div[style^='font-size: 20px; padding-bottom: 20px; margin-bottom: 10px; border-bottom: 1px solid rgb(221, 227, 229);']").text).to_s).to_i

            Watir::Wait.until { 
              @BROWSER.as(:text, HERMES_STRINGS["shop_online"]["share"].upcase).count == amt_of_cashback_rates 
              @BROWSER.buttons(:text, HERMES_STRINGS["shop_online"]["get_cashback"]).count == amt_of_cashback_rates 
            }
          else
            @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["cashback_rate"]).wait_until_present

            Watir::Wait.until { 
              @BROWSER.as(:text, HERMES_STRINGS["shop_online"]["share"].upcase).count == 1
              @BROWSER.buttons(:text, HERMES_STRINGS["shop_online"]["get_cashback"]).count == 1 
            }

          end 
        else
          Watir::Wait.until { @BROWSER.element(css: "div[style^='font-size: 20px; margin-bottom: 5px;']").text.include? HERMES_STRINGS["shop_online"]["special_offer"] }
          @BROWSER.div(:text, /#{retailer_or_offer_description}/).wait_until_present
          @BROWSER.div(:text, offer_type).wait_until_present

          # Checks that offer codes are correctly displayed on screen (If applicable)
          if @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["redemption_copy"]).present?
            @BROWSER.div(:text, HERMES_STRINGS["shop_online"]["redemption_copy"]).parent.div(:index => 1, :text => /\w+/).wait_until_present
          end
        end

        # Tests the 'Read more' link functionality on the retailer's page which when clicked will reveal more text to read
        read_more_links = [retailer_or_offer_name, HERMES_STRINGS["shop_online"]["informations"], HERMES_STRINGS["shop_online"]["shipping"]]

        read_more_links.each do |read_more_link|
          if @BROWSER.div(:text, read_more_link).present? && @BROWSER.div(:text, read_more_link).parent.a(:text, HERMES_STRINGS["global"]["read_more"]).present?
            Watir::Wait.until{ @BROWSER.div(:text, read_more_link).parent.span.text[-3..-1] == '...' }
            pre_expanded_description = @BROWSER.div(:text, read_more_link).parent.span.text.length
            @BROWSER.div(:text, read_more_link).parent.a(:text, HERMES_STRINGS["global"]["read_more"]).click
            
            Watir::Wait.until { 
              @BROWSER.div(:text, read_more_link).parent.span.text.length > pre_expanded_description ||
              @BROWSER.div(:text, read_more_link).parent.span.text[-3..-1] != '...' 
            }
          end
        end

        @BROWSER.back
        @BROWSER.li(:id, /item/).wait_until_present
        @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).wait_until_present

        retailers_or_offers_validated += 1

        if !@BROWSER.div(:class => 'white-flag-icon white-flag-icon__box', :index => i + 1).present?
          if @BROWSER.li(:class, 'next').present?
            @BROWSER.li(:class, 'next').click
            puts "About to validate next page of offers"
            i = 0
          else
            puts "#{retailers_or_offers_validated} offers have been validated. #{retailers_or_offers_to_validate} offers should have been validated but there are not enough available to validate."
            break 
          end         
        else  
          i += 1
        end
      end
    end
  end

  # @param retailer_name
  # @param retailer_type
  def search_for_retailer_or_offer (retailer_name)
    puts "SEARCHING FOR - #{retailer_name}"
    @BROWSER.div(:class, 'icon-web_search').wait_until_present
    @BROWSER.div(:class, 'icon-web_search').parent.input.send_keys retailer_name
    @BROWSER.div(:class, 'icon-web_search').parent.input(:value, retailer_name).wait_until_present
  end

  # @param suggested_search
  # @param retailer_name
  # @param retailer_type
  # Suggested search tests the suggested search dropdown functionality. 
  # If this param is not true then this method will test search functionality for entering a string and clicking the 'search' button
  def validate_shop_online_search_functionality (suggested_search, retailer_name = nil, retailer_type = nil)
    if retailer_name == 'random' || retailer_name == nil
      if suggested_search
        index = rand(@BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count - 1)
        retailer_name = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 10).text.gsub(/\s-\s.*/,'')
      else
        select_retailer_type(retailer_type)
        retailer_name = @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).last.parent.parent.div(:index, @RETAILER_NAME_INDEX).text.gsub(/\s-\s.*/,'')
      end
    else
      retailer_name = SHOP_ONLINE_RETAILERS[:"#{retailer_name}"][:name]
    end

    search_for_retailer_or_offer(retailer_name)

    if suggested_search
      @BROWSER.div(:class, 'icon-web_search').parent.parent.span(:text, retailer_name).wait_until_present
      @BROWSER.div(:class, 'icon-web_search').parent.parent.span(:text, retailer_name).click
      @BTN_GET_CASHBACK.wait_until_present
      @BROWSER.div(:text, retailer_name).wait_until_present
    else
      @BROWSER.div(:class, 'icon-web_search').click   
      @BROWSER.span(:text, /#{HERMES_STRINGS["shop_online"]["search_title"].gsub("%{query}", "#{retailer_name}")} • [1-9]\d* #{HERMES_STRINGS["shop_online"]["results"]}/).wait_until_present
      Watir::Wait.until { @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => 0).parent.parent.div(:index, @RETAILER_NAME_INDEX).text.include? retailer_name }
    end
  end

  def return_or_amend_variable (variable_name, new_variable_value = nil)
    if variable_name == 'Retailer Category'
      new_variable_value == nil ? (return @RETAILER_CATEGORY) : @RETAILER_CATEGORY = new_variable_value
    elsif variable_name == 'Retailer Name'
      new_variable_value == nil ? (return @RETAILER_NAME) : @RETAILER_NAME = new_variable_value
    end
  end
  
end