# -*- encoding : utf-8 -*-
class HermesRestaurantDiscountsPage
  
  def initialize (browser)
    @BROWSER = browser

    @LBL_CLEAR_ALL = @BROWSER.a(:text, HERMES_STRINGS["global"]["clear_all"])
    @BTN_FAVOURITES = @BROWSER.div(:class, %w(white-icon star))
    @BTN_SHOW_MAP = @BROWSER.div(:text, HERMES_STRINGS["restaurants"]["show_on_map"])
    @BTN_FAVOURITE_CHECKBOX = @BROWSER.i(:class, 'icon-star')

    @BTN_VIEW_WEBSITE = @BROWSER.button(:text, HERMES_STRINGS["restaurant_detail"]["view_website"])
    @BTN_FAVOURITE = @BROWSER.button(:text, HERMES_STRINGS["restaurant_detail"]["favourite"])
    @BTN_UNFAVOURITE = @BROWSER.button(:text, HERMES_STRINGS["restaurant_detail"]["unfavourite"])
    @BTN_SHOW_CARD = @BROWSER.button(:text, HERMES_STRINGS["restaurant_detail"]["show_redeem"])

    @SELECT_CUISINE_BOX = "div[style^='display: inline-block; margin: auto 20px auto auto; vertical-align: top; width: 200px; max-width: 200px;']"
  end

  def is_visible (page)
    case page
    when 'Main'
      @LBL_CLEAR_ALL.wait_until_present
      @BTN_SHOW_MAP.wait_until_present
      @BTN_FAVOURITE_CHECKBOX.wait_until_present
      # Verifies that the cuisine selection box contains at least 1 cuisine type
      Watir::Wait.until { 
        @BROWSER.element(css: @SELECT_CUISINE_BOX).present?
        @BROWSER.li(:id, /item-restaurant_/).present?
        @BROWSER.lis(:id, /item-restaurant_/).count > 0 
      }
    when 'Added to Favourites'
      @BROWSER.p(:text, HERMES_STRINGS["restaurants"]["added_to_favourites"]).wait_until_present
    when 'Removed from Favourites'
      @BROWSER.p(:text, HERMES_STRINGS["restaurants"]["removed_from_favourites"]).wait_until_present
    when 'restaurant page'
      @BTN_VIEW_WEBSITE.wait_until_present
      # @BROWSER.h2(:text, HERMES_STRINGS["restaurant_detail"]["overview"]).wait_until_present
      @BROWSER.h2(:text, "*#{HERMES_STRINGS["restaurant_detail"]["terms_con"]["title_2"]}").wait_until_present
      @BROWSER.h2(:text, HERMES_STRINGS["restaurant_detail"]["left_column"]["address"]).wait_until_present
      @BROWSER.h2(:text, HERMES_STRINGS["restaurant_detail"]["left_column"]["directions"]).wait_until_present

      # Watir::Wait.until { @BROWSER.h2(:text, HERMES_STRINGS["restaurant_detail"]["overview"]).parent.div.text != nil }
      Watir::Wait.until { @BROWSER.h2(:text, "*#{HERMES_STRINGS["restaurant_detail"]["terms_con"]["title_2"]}").parent.div.text != nil }
      Watir::Wait.until { @BROWSER.h2(:text, HERMES_STRINGS["restaurant_detail"]["left_column"]["address"]).parent.span.text != nil }
      Watir::Wait.until { @BROWSER.h2(:text, HERMES_STRINGS["restaurant_detail"]["left_column"]["directions"]).parent.p.text != nil }
    end
  end 

  def click_button (button)
    case button
    when 'Add/Remove From Favourites'
      @BTN_FAVOURITES.wait_until_present
      @BTN_FAVOURITES.click
      is_visible('Added To Favourites')
    when 'Browser back'
      @BROWSER.back
    when 'Favourites Checkbox'
      @BTN_FAVOURITE_CHECKBOX.wait_until_present
      @BTN_FAVOURITE_CHECKBOX.click
      @BROWSER.div(:id, 'spinner').wait_while_present
      sleep(0.5)
    when 'Favourite'
      @BTN_FAVOURITE.wait_until_present
      @BTN_FAVOURITE.click
      @BTN_UNFAVOURITE.wait_until_present
    when 'Unfavourite'
      @BTN_UNFAVOURITE.wait_until_present
      @BTN_UNFAVOURITE.click
      @BTN_FAVOURITE.wait_until_present
    when 'Show Card & Redeem'
      @BTN_SHOW_CARD.wait_until_present
      @BTN_SHOW_CARD.fire_event('click')
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end          

  # Open restaurant by the given index
  # @param index
  def open_restaurant_by_index (index)    
    Watir::Wait.until { @BROWSER.divs(:class => %w(white-flag-icon white-flag-icon__box)).count > 0 }

    if @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).present? 
      @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).scroll.to :top
      @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.wait_until_present
      
      restaurant_name = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 10).text
      cuisine_type = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 13).text.gsub(/\s+\/\s+/, "/")
      offer_details = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 9).text
      
      @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.div.fire_event('click')
      is_visible('restaurant page')
      
      @BROWSER.h1(:text, restaurant_name).parent.p(:text, cuisine_type).wait_until_present
      @BROWSER.h1(:text, /#{restaurant_name}/).parent.span(:text, /#{offer_details}/i).wait_until_present
      @BROWSER.button(:text => HERMES_STRINGS["restaurant_detail"]["show_redeem"], :index => 0).wait_until_present
      @BROWSER.button(:text => HERMES_STRINGS["restaurant_detail"]["show_redeem"], :index => 1).wait_until_present
    end
  end

  # Open resturant profile
  # @param - restaurant name
  def go_to_resturant (restaurant, click = true)
    @BROWSER.input(:index, 1).wait_until_present
    @BROWSER.input(:index, 1).send_keys restaurant
    Watir::Wait.until { @BROWSER.input(:index, 1).value == restaurant }
    @BROWSER.div(:class, 'icon-web_search').click
    @BROWSER.div(:text, restaurant).parent.i(:class, 'icon-web_close').wait_until_present
    Watir::Wait.until { @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count > 0 }
    
    if !@BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).parent.parent.div(:text, /#{restaurant}/).present? 
        fail(msg = "Error. go_to_resturant. Company #{restaurant} was not found")
    end

    if click
      @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).parent.parent.div(:text, /#{restaurant}/i).fire_event('click')
      @BROWSER.h1(:text, "#{restaurant}").wait_until_present
      is_visible('restaurant page')
    end
  end

  # Favourite or unfavourite restaurant by the restaurant name
  # @param operation "favourite" or "unfavourite"
  # @param restaurant name
  def favourite_unfavourite_restaurant (operation, restaurant)
    @BROWSER.div(:text, /#{restaurant}/).wait_until_present

    if operation == 'favourite'
      if @BTN_FAVOURITE.present?
        click_button('Favourite')
      elsif !@BROWSER.div(:text => restaurant, :index => 2).parent.parent.div(:class, %w(white-icon star)).div(:class, /active/).present?
        @BROWSER.div(:text => restaurant, :index => 2).parent.parent.div(:class, %w(white-icon star)).wait_until_present
        @BROWSER.div(:text => restaurant, :index => 2).parent.parent.div(:class, %w(white-icon star)).click
        is_visible('Added to Favourites')
      end
    elsif operation == 'unfavourite'
      if @BTN_UNFAVOURITE.present?
        click_button('Unfavourite')
      else 
        if @BROWSER.div(:text => restaurant, :index => 2).parent.parent.div(:class, %w(white-icon star)).present?
          @BROWSER.div(:text => restaurant, :index => 2).parent.parent.div(:class, %w(white-icon star)).click
        else
          @BROWSER.div(:text => restaurant).parent.parent.div(:class, %w(white-icon star)).click
        end
      end

      is_visible('Removed from Favourites')
    end
  end

  # Remove all restaurants from favourites
  def remove_all_restaurants_from_favourites
    click_button('Favourites Checkbox')
    i = 0

    while @BROWSER.div(:class => %w(white-icon star), :index => i).present?
      restaurant_name = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 12).text
      favourite_unfavourite_restaurant('unfavourite', restaurant_name)
      i += 1
    end 
  end

  # Check if restaurant is in favourites
  # @param restaurant name
  # @param state - 'is in' or 'is not in' the favourites
  def check_if_in_favourites (restaurant, state)
    restaurant_count = @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count
    click_button('Favourites Checkbox')
    Watir::Wait.until { @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count < restaurant_count}

    if state == 'is in'
      @BROWSER.div(:text, /#{restaurant}/).wait_until_present
    elsif state == 'is not in'
      if  @BROWSER.div(:text, /#{restaurant}/).present?
        fail(msg = "Error. check_if_in_favourites. Restaurant #{restaurant} should not be in favourites.")
      end
    end
  end

  # Validate gourmet society expire date
  def validate_gourmet_society_expire_date
    click_button('Show Card & Redeem')
    user_name = ACCOUNT[:"#{$account_index}"][:valid_account][:user_name]
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, /#{user_name}/).wait_until_present
    card_number = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:index, 9).text.delete 'Membership number:'
    puts "Card number:#{card_number}"
    
    if @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:index, 9).text.sub('Membership number: ','') == nil
      fail(msg = "Error. validate_gourmt_society_expire_date. Card number was empty.")
    end

    expiry_date = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:index, 10).text.delete 'Membership expires:'
    card_used_on = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:index, 11).text.delete 'Card used on:'
    puts "Expiry date:#{expiry_date}"
    puts "Card used on:#{card_used_on}"

    if Date.parse(expiry_date) < Date.parse(Time.now.strftime('%d/%m/%Y'))
      fail(msg = "Error. validate_gourmet_society_expire_date. The expiry (#{expiry_date}) date is no longer valid.")
    end

    if Date.parse(card_used_on) != Date.parse(Time.now.strftime('%d/%m/%Y'))
      fail(msg = "Error. validate_gourmet_society_expire_date. The card used on date (#{card_used_on}) should be today's date")
    end
    
    @BROWSER.i(:class, 'icon-web_close').click
    @BROWSER.i(:class, 'icon-web_close').wait_while_present
  end

  # @param = cuisines_to_select
  # Randomly select x amount of random cusines.
  def select_random_cuisine_types (cuisines_to_select)
    @BROWSER.element(css: @SELECT_CUISINE_BOX).wait_until_present

    number_of_available_cuisines = @BROWSER.element(css: @SELECT_CUISINE_BOX).lis.count - 1
    
    # if the amt of cuisines to select is greater than the number of available cuisines then adjust the cuisines_to_select variable to (number_of_available_cuisines - 1)
    if cuisines_to_select > number_of_available_cuisines
      cusines_to_select = number_of_available_cuisines - 1
    end

    random_cuisine_array = (0..number_of_available_cuisines).to_a.sample(cuisines_to_select)
    @SELECTED_CUISINE_ARRAY = []
    
    random_cuisine_array.each do |cuisine_index|
      cuisine_name = @BROWSER.element(css: @SELECT_CUISINE_BOX).li(:index, cuisine_index).text
      @SELECTED_CUISINE_ARRAY << { :cuisine_index => cuisine_index, :cuisine_name => cuisine_name }
    end

    select_cuisines
  end

  # Uses the selected cuisine type array in order to click on the cuisine type and then verify that the amount of restaurants displayed has increased with each added selection
  def select_cuisines
    current_restaurant_total = 0

    @SELECTED_CUISINE_ARRAY.each do |cuisine_type|
      previous_restaurant_total = current_restaurant_total
      current_restaurant_total = 0

      @BROWSER.element(css: @SELECT_CUISINE_BOX).li(:index, cuisine_type[:cuisine_index]).img.fire_event('click')
      sleep(1.5)
      @BROWSER.element(css: @SELECT_CUISINE_BOX).span(:text, cuisine_type[:cuisine_name]).parent.i(:class, 'icon-web_close').wait_until_present
      # @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present
      # Watir::Wait.until { @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count > 0 }
      current_restaurant_total = @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count
      
      while (@BROWSER.li(:class, 'next').present?) && (!@BROWSER.ul(:class, 'pagination').lis[-2].class_name.include? 'active')
        @BROWSER.li(:class, 'next').click
        @BROWSER.div(:class, %w(white-flag-icon white-flag-icon__box)).wait_until_present
        current_restaurant_total = current_restaurant_total + @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count
      end
      
      if current_restaurant_total < previous_restaurant_total
        fail(msg = "error. select_cuisines. previous restaurant total was #{previous_restaurant_total}, the current total is #{current_restaurant_total}")
      end
      
      puts "Cuisine type - #{cuisine_type[:cuisine_name]}... Number of restaurants on page = #{current_restaurant_total}, previous total = #{previous_restaurant_total}"
    end
  end

  # @param = method_to_deselect
  # Deselect a selected cuisines either using the clear all button or clickingon each sleected cuisine individually
  def clear_all_cuisines (method_to_deselect)
    if method_to_deselect == 'clear all'
      @BROWSER.element(css: @SELECT_CUISINE_BOX).a(:text, 'Clear all').wait_until_present
      @BROWSER.element(css: @SELECT_CUISINE_BOX).a(:text, 'Clear all').click
    else
      @SELECTED_CUISINE_ARRAY.each do |cuisine_type|
        # Either deselect a cuisine by clicking on the enabled cuisine's checkbox or the close cuisine icon inside the select cuisine box 
        if cuisine_type[:cuisine_index].even?
          @BROWSER.element(css: @SELECT_CUISINE_BOX).span(:text, cuisine_type[:cuisine_name]).parent.i(:class, 'icon-web_close').fire_event('click')
        else
          @BROWSER.element(css: @SELECT_CUISINE_BOX).li(:index, cuisine_type[:cuisine_index]).img.fire_event('click')
        end
      end
    end

    # Check that the deselected cuisine has been removed from the select cuisine box
    @SELECTED_CUISINE_ARRAY.each do |cuisine_type|
      Watir::Wait.until { !@BROWSER.element(css: @SELECT_CUISINE_BOX).span(:text, cuisine_type[:cuisine_name]).parent.i(:class, 'icon-web_close').present? }
      puts "'#{cuisine_type[:cuisine_name]}' has been removed from the cusined filter list"
    end
  end

  # @param = all_restaurants_visible
  # if all_restaurants_visible = true, then check that at least one restaurant is displayed that does not have a cuisine type contained in the @SELECTED_CUISINE_ARRAY
  # if all_restaurants_visible = false, then check that only restaurants that contain a cuisine type in the @SELECTED_CUISINE_ARRAY are displayed
  def verify_restaurant_visibility (all_restaurants_visible)
    @CUISINES_TO_VERIFY = @SELECTED_CUISINE_ARRAY.map { |cuisine| cuisine[:cuisine_name] }
    i = 0

    while @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).present?
      if !@CUISINES_TO_VERIFY.any? { |cuisines| @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 13).text.include? cuisines }
        if all_restaurants_visible
          puts "test passed. Other restaurants other than the filtered restaurant types are displayed. all_visible = #{all_restaurants_visible}"
          puts "restaurant that was found that makes this test pass = #{@BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 13).text}"
          break
        else
          fail(msg = "error. verify_restaurant_visibility. expected cuisine type should be one of '#{@CUISINES_TO_VERIFY}', but is actually '#{@BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).parent.parent.div(:index, 13).text}'")
        end
      else
        i += 1

        if !@BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).present? 
          if (@BROWSER.li(:class, 'next').present?) && (!@BROWSER.ul(:class, 'pagination').lis[-2].class_name.include? 'active')
            i = 0
            @BROWSER.li(:class, 'next').click
            @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => i).wait_until_present
          elsif all_restaurants_visible
            fail(msg = 'error. verify_restaurant_visibility. Only the restaurants that were previously filtered are being displayed. All restaurants cusines should be visible')
          end
        end
      end
    end
  end

end

