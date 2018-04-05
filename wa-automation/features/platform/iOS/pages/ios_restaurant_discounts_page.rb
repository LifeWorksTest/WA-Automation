# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSRestaurantDiscountsPage < Calabash::IBase
  LBL_RESTAURANT_DISCOUNT = "* id:'#{IOS_STRINGS["WAMMenuItemRestaurantDiscountsTitle"]}'"
  LBL_FAVOURITE_RESTUARANT = "UILabel marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}'"

  BTN_FAVORITES = "* marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}'"           
  BTN_BOOK_A_TABLE = "button marked:'#{IOS_STRINGS["WAMRSDetailMainButtonPopup"]}'"
  BTN_TEARMS_AND_CONDITIONS = "button marked:'#{IOS_STRINGS["WAMRSDetailTerms"]}'"
  BTN_SHOW_CARD = "button marked:'#{IOS_STRINGS["WAMRSDetailMainButtonMembershipCard"]}'"
  BTN_SHOW_CARD_AND_REDEEM = "button marked:'#{IOS_STRINGS["WAMRSDetailMainButtonMembershipCardAndRedeem"]}'"
  BTN_UNFAVORITE_DETAIL_PAGE = "* marked:'ic heart default'"
  BTN_FAVORITE_DETAIL_PAGE = "* marked:'ic heart default'"
  BTN_MAP = "* marked:'ic map view'"
  BTN_NEAR_ME = "* marked:'#{IOS_STRINGS["WAMRSChangeLocationButtonNearMe"]}'"
  BTN_REMOVE = "label marked:'#{IOS_STRINGS["WAMRSFavouriteRemoveButton"]}'"
  BTN_BACK = "UINavigationBar descendant * index:6"
  BTN_CANCEL = "button marked:'#{IOS_STRINGS["WAMFoundationCancelKey"]}'"
  BTN_SEARCH = " * marked:'Search'"

  def trait
    LBL_RESTAURANT_DISCOUNT
  end

  def click_button (button)
    case button
    when 'Back'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      LBL_RESTAURANT_DISCOUNT
    when 'Favorite'
      wait_for(:timeout => 30){element_exists(BTN_FAVORITE_DETAIL_PAGE)}
      touch(BTN_FAVORITE_DETAIL_PAGE)
      wait_for(:timeout => 30){element_exists(BTN_UNFAVORITE_DETAIL_PAGE)}
      @FAVORITES_COUNTER += 1
    when 'Unfavorite'
      wait_for(:timeout => 30){element_exists(BTN_UNFAVORITE)}
      touch(BTN_UNFAVORITE)
      wait_for(:timeout => 30){element_exists(BTN_REMOVE)}
      touch(BTN_REMOVE)
      wait_for(:timeout => 30){element_does_not_exist(BTN_REMOVE)}
      wait_for(:timeout => 30){element_exists(BTN_FAVORITE)}
      @FAVORITES_COUNTER -= 1
    when 'Favorites'
      wait_for(:timeout => 30){element_exists(BTN_FAVORITES)}
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}' sibling * index:1 marked:'(#{@FAVORITES_COUNTER})'")}
      touch(BTN_FAVORITES)
      wait_for(:timeout => 30){element_exists("* marked:'#{IOS_STRINGS["WAMFoundationFavourites"]}'")}
    when 'SHOW CARD'
      wait_for(:timeout => 30){element_exists(BTN_SHOW_CARD)}
      touch(BTN_SHOW_CARD)
      wait_for(:timeout => 30){element_exists("label marked:'Platinum'")}
      wait_for(:timeout => 30){element_exists("* marked:'bt close white'")}
      touch("* marked:'bt close white'")
      wait_for(:timeout => 30){element_does_not_exist("* marked:'bt close white'")}
    when 'SHOW CARD AND REDEEM'
      wait_for(:timeout => 30){element_exists(BTN_SHOW_CARD_AND_REDEEM)}
      touch(BTN_SHOW_CARD_AND_REDEEM)
      wait_for(:timeout => 30){element_exists("label marked:'Platinum'")}
      wait_for(:timeout => 30){element_exists("* marked:'bt close white'")}
      touch("* marked:'bt close white'")
      wait_for(:timeout => 30){element_does_not_exist("* marked:'bt close white'")}
    when 'TEARMS AND CONDITIONS'
      wait_for(:timeout => 5){element_exists(BTN_TEARMS_AND_CONDITIONS)}
      touch(BTN_TEARMS_AND_CONDITIONS)
      wait_for(:timeout => 5){element_exists("label marked:'#{IOS_STRINGS["WAMRSDetailTerms"]}'")}
      wait_for(:timeout => 5){element_exists("UINavigationTransitionView descendant * label index:0")}
      wait_for_none_animating
      terms_text = (query "UINavigationTransitionView descendant * label index:0")[0]['text']

      if terms_text == nil
        Fail(msg = 'Error. Terms and Conditions text is empty')
      end
    when 'Near me'
      wait_for(:timeout => 5){element_exists(BTN_NEAR_ME)}
      touch(BTN_NEAR_ME)
      wait_for(:timeout => 30){element_does_not_exist(BTN_NEAR_ME)}
    when 'Map'
      wait_for(:timeout => 5){element_exists(BTN_MAP)}
      touch(BTN_MAP)
      sleep(1)
      wait_for(:timeout => 30){element_exists("* marked:'ic list view'")}
    when 'Cancel'
      wait_for(:timeout => 5){element_exists(BTN_CANCEL)}
      flash(BTN_CANCEL)
      touch(BTN_CANCEL)
      wait_for(:timeout => 30){element_does_not_exist(BTN_CANCEL)}
    when 'Search'
      wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("label id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")}
      @LBL_RESTAURANT_NAME = query("label id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")[0]['text']
      touch(BTN_SEARCH)
      wait_for(:timeout => 30){element_exists("UISearchBarTextFieldLabel marked: '#{IOS_STRINGS["WAMRSSearchPlaceholder"]}'")}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end
  
  # After searching for a location, the location should be saved in the latest search
  # @param location
  def validate_location_exists_in_page(location)
    wait_for(:timeout => 30){element_exists("UITableViewLabel")}
    number_of_resoults = query("UITableViewLabel").count
    
    for i in 0..number_of_resoults - 1
      if query("UITableViewLabel index:#{i}")[0]['text'].include? location
        return
      end
    end
  end

  # Validate the map view
  def validate_map_view
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Map pin'")}
    total_results = query("* marked:'Map pin'").count
    
    if total_results == 0
      fail(msg = 'Error. validate_map_view. 0 restaurants was found')
    end 

    for i in 0..3
      puts("#{query("UICollectionView descendant * id:'net.wamapp.wam.Calabash.WAMRSCarouselCell.title'")[0]['text']}")
      scroll("scrollView index:2", :right)
      wait_for_none_animating
    end 

    swipe(:down, :query => "scrollView index:0", :offset => {:x => 123, :y => 30}, :"swipe-delta" =>{:vertical => {:dx=> 0, :dy=> 250} })
    wait_for_none_animating
    
    if query("UICollectionView descendant * id:'net.wamapp.wam.Calabash.WAMRSCarouselCell.title'")[0]['text'] == nil
      fail(msg = 'Error. validate_map_view. Restaurants were not loaded after swiping the screen')
    end
  end
  
  # Search for restaurant location
  # @param location
  def search_for_location (location)
    wait_for(:timeout => 30){element_exists("textField")}
    keyboard_enter_text(location)
    wait_for(:timeout => 30){element_exists("UITableViewLabel index:0")}
    touch "UITableViewLabel index:0"
    wait_for(:timeout => 30){element_exists("WAMRSListCollectionViewCell")}
  end

  # Validate favorites counter against the current label
  def validate_favorites_counter
    puts "@FAVORITES_COUNTER:#{@FAVORITES_COUNTER}"
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}' sibling * index:1 marked:'(#{@FAVORITES_COUNTER})'")}
  end

  # Set favorites counter
  def set_favorites_counter
    sleep(0.5)
    wait_poll(:retry_frequency => 0.5,:until_exists => BTN_FAVORITES, :timeout => 30) do
      custom_scroll('Up')
    end

    wait_for(:timeout => 30,:post_timeout => 1){element_exists("label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}' sibling * index:1")}
    @FAVORITES_COUNTER = (/\d+/.match (query "label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}' sibling * index:1")[0]['text'])[0].to_i
    puts "@FAVORITES_COUNTER=#{@FAVORITES_COUNTER}"
  end

  # Get favorites counter
  def get_favorites_counter
    sleep(0.5)
    wait_poll(:retry_frequency => 0.5,:until_exists => "label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}'", :timeout => 30) do
      custom_scroll('Up')
    end
    
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}' sibling * index:1")}
    
    return (/\d+/.match (query "label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}' sibling * index:1")[0]['text'])[0].to_i
  end

  # Validate favorite counter has increase or decrease
  # @param increase_decrease - increased by one/decreased by one
  def validate_favorite_counter_has_update (increase_decrease)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("label marked:'#{IOS_STRINGS["WAMRSFavouriteRestaurants"]}'")}
    current_value = get_favorites_counter
    puts "current_value:#{current_value}"

    if increase_decrease == 'increased by one'
      if  @FAVORITES_COUNTER != current_value
        fail(msg = "Error. validate_favorite_counter_has_update. Current favorite counter is #{@FAVORITES_COUNTER} and expected to #{current_value}")
      end
    elsif increase_decrease == 'decreased by one'
      if  @FAVORITES_COUNTER != current_value
        fail(msg = "Error. validate_favorite_counter_has_update. Current favorite counter is #{@FAVORITES_COUNTER} and expected to #{current_value}")
      end
    end
  end

  # Check the first 3 restaurant in the list check that the details are match
  # in the list and in the restaurant profile 
  def check_restaurant_list_details
    for i in 0..4
      wait_for(:timeout => 30){element_exists("WAMRSListCollectionViewCell")}
      
      if element_exists("WAMRSListCollectionViewCell index:0 descendant * id:'ic_distance'")
        j = 0
      else 
        j = 1
      end

      puts "j=#{j} i=#{i}"

      wait_for(:timeout => 5){element_exists("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")}
      restaurant_name = query(("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'"))[0]['text']

      if restaurant_name.include? "\'"
        flick("scrollView", {x:0, y:-50})
        sleep(2)
        next
      end

      wait_for(:timeout => 5){element_exists("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.discount'")}
      restaurant_offer = query(("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.discount'"))[0]['text']
      
      special_offers = query("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.offers'")[0]['text'] 
      
      if special_offers != nil
        restaurant_offer = restaurant_offer + ' | ' + special_offers
      end

      wait_for(:timeout => 5){element_exists("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.location'")}
      restaurant_address = query("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.location'")[0]['text']
      restaurant_address = (/[^,]*/.match restaurant_address)[0]

      wait_for(:timeout => 5){element_exists("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.cuisine'")}
      restaurant_type = query("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.cuisine'")[0]['text']
      wait_for(:timeout => 5){element_exists("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.distance'")}
      restaurant_distance = query("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.distance'")[0]['text']
      puts "#{restaurant_name}"
      touch("WAMRSListCollectionViewCell index:#{j} descendant * id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")
      validate_restaurant_page('Hi-Life', restaurant_name, restaurant_offer, restaurant_address, restaurant_type, restaurant_distance)
      click_button('Back')
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("WAMRSListCollectionViewCell")}
      flick("scrollView", {x:0, y:-50})
      sleep(2)
    end
  end

  # Validate restaurant page according to the given values
  def validate_restaurant_page (restaurant_provider, restaurant_name, restaurant_offer, restaurant_address, restaurant_type, restaurant_distance)
    wait_for(:timeout => 15){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSHeaderView.name' marked:'#{restaurant_name}'")}
    wait_for(:timeout => 15){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSHeaderView.offer' marked:'#{restaurant_offer}'")}
    wait_for(:timeout => 15){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSHeaderView.cuisine' * marked:'#{restaurant_type}'")}
    wait_for(:timeout => 15){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSHeaderView.distance' * marked:'#{restaurant_distance}'")}
      
    case restaurant_provider
    when 'Book A Table'
      wait_for(:timeout => 5){element_exists(BTN_BOOK_A_TABLE)}

      custom_scroll('Down')
      wait_for(:timeout => 5){element_exists("* marked:'Overview'")}
      wait_for(:timeout => 5){element_exists("* id:'net.wamapp.wam.Calabash.WAMOverviewView.text'")}
      if (query "* id:'net.wamapp.wam.Calabash.WAMOverviewView.text'")[0]['text'] == nil
        fail (msg = "Error. validate_restaurant_page. Restaurant Overview is empty for restaurant #{restaurant_name}")
      end

      wait_for(:timeout => 30){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.address'")} 
      resturant_address_in_profile = (query "* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.address'")[0]['label']
    
      if !(resturant_address_in_profile.include? restaurant_address)
        fail(msg = "Error. check_restaurant_list_details. Restaurants address in profile is:#{resturant_address_in_profile} while restaurant address in the main view is:#{restaurant_address}")
      end

#      wait_for(:timeout => 30){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.call'")}
      custom_scroll('Down')
#      wait_for(:timeout => 30){element_exists("* marked:'One Main Course'")}
    when 'Hi-Life'        
      if element_exists(BTN_BOOK_A_TABLE)
        fail(msg = "Error. check_restaurant_list_details. Restaurant #{restaurant_name} provider is not Book A Table therefor not expected to see 'BOOK A TABLE' button")
      end
    
      custom_scroll('Down')

      if element_does_not_exist("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.call'")
        require_phone_booking = false
      else
        require_phone_booking = true
        custom_scroll('Down')
        wait_for(:timeout => 5){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.call'")}
        click_button('SHOW CARD AND REDEEM')
      end

      custom_scroll('Down')

      wait_for(:timeout => 30){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.address'")} 
      resturant_address_in_profile = query("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.address'")[0]['label']

      if !(resturant_address_in_profile.include? restaurant_address)
        fail(msg = "Error. check_restaurant_list_details. Restaurants address in profile is:#{resturant_address_in_profile} while restaurant address in the main view is:#{restaurant_address}")
      end

      custom_scroll('Down')
      custom_scroll('Down')

      wait_for(:timeout => 30){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSDetailViewController.additional_info'")}
    end

    #wait_poll(:until_exists => BTN_TEARMS_AND_CONDITIONS, :timeout => 15) do 
     # custom_scroll('Down')
    #end

    #click_button('TEARMS AND CONDITIONS')

    #if (query "* marked:'Terms and Conditions' sibling *")[0]['text'] == nil
     # fail (msg = "Error. check_restaurant_list_details. Restaurant Terms & Conditions is empty for restaurant #{restaurant_name}")
    #end
  end

  # Scroll Up/Down
  # @param direction
  def custom_scroll (direction)
    if direction == 'Down'
        scroll("scrollView index:0", :down)
    elsif direction == 'Up'
      scroll("scrollView index:0", :up)
    end

    sleep(0.5)
  end
  # Favorite and unfavorite the current restaurant
  # @param state - Favorite/Unfavorite
  def favorite_unfavorite (state)
    if state == 'Favorite'
      if element_does_not_exist BTN_UNFAVORITE
        click_button('Favorite')
      end
    elsif state == 'Unfavorite'
      if element_does_not_exist BTN_FAVORITE
        click_button('Unfavorite')
      end 
    end
  end

  # Search for the given restaurant and go to the restaurant page
  def open_restaurant (restaurant_name)
    search_for_restaurant_in_favorites(restaurant_name)

    touch("* marked:'#{restaurant_name}'")
    wait_for(:timeout => 15){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSHeaderView.name' marked:'#{restaurant_name}'")}
  end

  # Search for restaurant
  # @param - restaurant_name_in_favorites
  def search_for_restaurant_in_favorites (restaurant_name)
    wait_for(:timeout => 10){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSListCollectionViewCell.name'")}
    puts "Search for restaurant:'#{restaurant_name}'"
    
    wait_poll(:retry_frequency => 0.5, :until_exists => "* marked:'#{restaurant_name}'", :timeout => 15) do 
      custom_scroll('Down')
    end
  end

  # Click on Search icon and search using restaurant name
  # @param - restaurant_name
  def search_a_restaurant (restaurant_name)
    wait_for(:timeout => 10){element_exists("label marked:'#{IOS_STRINGS["WAMRSSearchPlaceholder"]}'")}
    keyboard_enter_text(restaurant_name)
    tap_keyboard_action_key
  end 

  # Open the searched restaurant and validate the displayed details
  # @param - restaurant_name
  # TODO - Add more validation i.e. Book a table button button and alternatinve? for non-BAT restaurants 
  def validate_restaurant (restaurant_name)
    wait_for(:timeout => 10){element_exists("* marked:'#{restaurant_name}'")}
    sleep(2)
    touch("* marked:'#{restaurant_name}'")
    wait_for(:timeout => 15){element_exists("* id:'net.wamapp.wam.Calabash.WAMRSHeaderView.name' marked:'#{restaurant_name}'")}
    wait_for(:timeout => 15){element_exists("label marked:'#{IOS_STRINGS["WAMRSDetailTitle"]}'")}
    click_button('Back')
  end 

  # Validate the given restaurant is not in favourites list
  # @param-restaurant_name
  def validate_restaurant_is_not_in_favourites (restaurant_name)
    for i in 0..10
      if element_exists("'* marked:#{restaurant_name}'")
        fail(msg = "Error. validate_restaurant_is_not_in_favourites. Restaurant:'#{restaurant_name}' shouldn't be in the favorites page")
      end
    end
  end

  # Search for restaurant around my location
  # @param-location 
  def near_me (location)
    wait_for(:timeout => 15){element_exists("* marked:'#{IOS_STRINGS["WAMFoundationCurrentLocation"]}'")}
    wait_for(:timeout => 15){element_exists("* id:'activity_location_new_restaurants_use_current_location_button'")}
    enter_text("* id:'activity_location_new_restaurants_search_toolbar_input_text'", location)
    wait_for(:timeout => 15){element_exists("* id:'location_list_view_item_title'")}
    touch("* id:'location_list_view_item_title'")
    wait_for(:timeout => 15){element_exists("* id:'card_view'")}
  end
end