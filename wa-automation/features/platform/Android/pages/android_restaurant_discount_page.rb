# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidRestaurantDiscountsPage < Calabash::ABase
  TXV_RESTAURANT_DISCOUNT = "* id:'view_toolbar_wrapper_root' AppCompatTextView marked:'Restaurants'"
  TXV_RESTAURANT_NAME = "* id:'search_item_title' text:'Masala'"

  BTN_FAVORITES = "* id:'view_new_restaurants_refine_bar_favourite'"
  BTN_MAP = "* id:'action_show_map'"
  BTN_BOOK_A_TABLE = "* id:'view_restaurant_details_book_a_table_button'"
  BTN_SHOW_CARD = "* id:'view_restaurant_details_how_to_claim_show_card_button'"
  BTN_SHOW_CARD_AND_REDEEM = "* id:'view_restaurant_details_how_to_claim_show_card_and_redeem_button'"
  BTN_UNFAVORITE = "* id:'view_new_restaurant_list_item_favourite'"
  BTN_FAVORITE = "* id:'fragment_new_restaurant_details_favourite_button'"
  BTN_REFINE = "* id:'view_new_restaurants_refine_bar_refine' text:'Refine'"
  BTN_NEAR_ME = "* id:'view_new_restaurants_refine_bar_location' text:'Near Me'"
  BTN_SHOW_CARD_AND_REDEEM = "* id:'view_restaurant_details_how_to_claim_show_card_and_redeem_button'"
  BTN_SEARCH = "* id:'action_search'"
  

  IMG_SPINNER = "android.widget.Spinner id:'action_bar_spinner'"

  def trait
    TXV_RESTAURANT_DISCOUNT
  end

  def click_button (button)
    case button
    when 'Favorite'
      sleep(2)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FAVORITE)}
      touch(BTN_FAVORITE)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'snackbar_text' marked:'Added to Favorites!'")}
      @FAVORITES_COUNTER += 1
      press_back_button
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_MAP)}
    when 'Unfavorite'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_UNFAVORITE)}
      touch(BTN_UNFAVORITE)
      wait_for(:timeout => 30, :post_timeout => 1){ element_exists("* id:'snackbar_text' marked:'Removed from Favorites!'")}
      @FAVORITES_COUNTER -= 1
      press_back_button
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_MAP)}
    when 'Favorites'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FAVORITES)}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_new_restaurants_refine_bar_favourite' marked:'#{@FAVORITES_COUNTER}'")}
      touch(BTN_FAVORITES)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'activity_list_new_favourite_restaurants_toolbar' * child marked:'Favorites'")}
    when 'SHOW CARD'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SHOW_CARD)}
      touch(BTN_SHOW_CARD)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'dialog_fragment_hilife_card_image_view'")}
      press_back_button
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SHOW_CARD)}
    when 'SHOW CARD AND REDEEM'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SHOW_CARD_AND_REDEEM)}
      touch(BTN_SHOW_CARD_AND_REDEEM)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'dialog_fragment_hilife_card_image_view'")}
      press_back_button
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SHOW_CARD_AND_REDEEM)}
    when 'TEARMS AND CONDITIONS'
      wait_for(:timeout => 30){element_exists(BTN_TEARMS_AND_CONDITIONS)}
      touch(BTN_TEARMS_AND_CONDITIONS)
      sleep(1)
    when 'Near Me'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_NEAR_ME)}
      touch(BTN_NEAR_ME)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_NEAR_ME)}
    when 'Map'
      wait_for(:timeout => 5){element_exists(BTN_MAP)}
      touch(BTN_MAP)
      wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(BTN_MAP)}
    when 'Search'
      wait_for(:timeout => 5){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_search_toolbar_input_text'")}  
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end
  
  def validate_favorites_counter
    puts "@FAVORITES_COUNTER:#{@FAVORITES_COUNTER}"
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_new_restaurants_refine_bar_favourite' marked:'#{@FAVORITES_COUNTER}'")}
  end

  def set_favorites_counter
    sleep(3)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_new_restaurants_refine_bar_favourite'")}
    @FAVORITES_COUNTER = ((query "* id:'view_new_restaurants_refine_bar_favourite'")[0]['text']).to_i
    puts "set_favorites_counter:@FAVORITES_COUNTER=#{@FAVORITES_COUNTER}"
  end

  # Check the first 3 restaurant in the list check that the details are match
  # in the list and in the restaurant profile 
  def check_resturent_list_details
    # Need to see with Simon what we do if AVG cost is 0
    for i in 0..4
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_mvp_collection_recycler_view'")}
      
      if query("* id:'card_view' index:0 descendant * id:'view_new_restaurant_list_item_cuisines'") && element_exists("* id:'card_view' index:0 descendant * id:'view_new_restaurant_list_item_distance'")
        j = 0
      else 
        j = 1
      end

    puts "j=#{j} i=#{i}"
      
    #if element_exists("* id:'view_new_restaurant_list_item_nr_offers'")
    #  restaurant_offer = restaurant_offer + ' | ' + (query "* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_nr_offers'")[0]['text']
    #end
    restaurant_offer = ""
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_name'")}
    restaurant_name = query("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_name'")[0]['text']
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_location'")}
    restaurant_address = query("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_location'")[0]['text']
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_cuisines'")}
    restaurant_type = query("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_cuisines'")[0]['text']
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_distance'")}
    restaurant_distance = query("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_distance'")[0]['text']
    
    puts "#{restaurant_name}"
    touch("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_name'")
    validate_restaurant_page(restaurant_name, restaurant_offer, restaurant_address, restaurant_type, restaurant_distance)
    press_back_button
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view'")}
    #wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view' index:#{j} descendant * id:'view_new_restaurant_list_item_name'")}

    perform_action('drag', 50, 50, 90, 75, 10)
      sleep(1)
    end
    press_back_button
  end

  def validate_restaurant_page(restaurant_name, restaurant_offer, restaurant_address, restaurant_type, restaurant_distance, constraints_counter = nil)
    puts"restaurant_type:#{restaurant_type}"
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_restaurant_details_header_title' marked:'#{restaurant_name}'")}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_restaurant_details_header_cuisine_type' marked:'#{restaurant_type}'")}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_restaurant_details_header_title'")}
    
    if query("* id:'view_restaurant_details_header_subtitle'")[0]['text'] == nil
      fail(msg = "Error. check_resturent_list_details. Restaurant details are empty for restaurant #{restaurant_name}")
    end
    
    wait_for(:timeout => 30, :post_timeout => 1, :post_timeout => 1){element_exists("* id:'view_restaurant_details_how_to_claim_section'")}
    scroll('Down')

    if ((query "* id:'view_restaurant_details_how_to_claim_first_instruction'")[0]['text']).include? 'does not'

      require_phone_booking = false  
      if element_exists("* id:'view_restaurant_details_how_to_claim_call_restaurant'")
        fail(msg = 'Error. check_resturent_list_details. There is no need for a phone booking for #{restaurant_name} however CALL RESRAURANT is visible')
      end

      wait_poll(:until_exists => BTN_SHOW_CARD_AND_REDEEM, :timeout => 60, :post_timeout => 1) do 
        perform_action('drag', 50, 50, 70, 50, 5)
      end
      click_button('SHOW CARD AND REDEEM')
    end
      

    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Restaurant Overview'")}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_expandable_text_text'")}
    if query("* id:'view_restaurant_details_overview_get_directions_text'")[0]['text'] == nil
      fail (msg = "Error. check_resturent_list_details. Restaurant Overview is empty for restaurant #{restaurant_name}")
    end

    scroll('Down')

    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_restaurant_details_overview_get_directions_text'")} 
    resturant_address_in_profile = query("* id:'view_restaurant_details_overview_get_directions_text'")[0]['text']
    
    if !(resturant_address_in_profile.include? restaurant_address)
      fail(msg = "Error. check_resturent_list_details. Restaurants address in profile is:#{resturant_address_in_profile} while restaurant address in the main view is:#{restaurant_address}")
    end
    press_back_button
  end

  def scroll(direction)
    if direction == 'Down'
      perform_action('drag', 50, 50, 90, 60, 10)
    elsif direction == 'Up'

    end
  end

  def favorite_unfavorite (state)
    if state == 'Favorite'
      # if element_does_not_exist BTN_UNFAVORITE
        click_button('Favorite')
      # end
    elsif state == 'Unfavorite'
      # if element_does_not_exist BTN_FAVORITE
        click_button('Unfavorite')
      # end 
    end
  end

  def go_to_restaurant (restaurant_name)
    puts "restaurant_name:#{restaurant_name}"
    wait_poll(:until_exists => "* marked:'#{restaurant_name}'", :timeout => 15) do 
      scroll('Down')
    end

    touch("* marked:'#{restaurant_name}'")
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_restaurant_details_header_title' marked:'#{restaurant_name}'")}
  end

  def check_resturent_in_favourites (state)
    sleep(0.5)
    wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist(IMG_SPINNER)}

    if state == 'is in'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view'")}

    elsif state == 'is not in'
      if element_exists("* id:'card_view'")
        if @FAVORITES_COUNTER == 0
          fail(msg = 'Error. check_resturent_in_favourites. Favorites counter is 0 while there are restaurants in this section')
        end

      else
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_mvp_collection_empty_view_container'")}

        if @FAVORITES_COUNTER != 0
          fail(msg = "Error. check_resturent_in_favourites. Favorites counter is #{@FAVORITES_COUNTER} while there is no restaurants in this section")
        end
      end
    end
    press_back_button
    wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_MAP)}
  end

  def open_first_restaurant_in_list
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view'")}
    touch("* id:'card_view'")
  end

  def near_me (location)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'activity_location_new_restaurants_search_toolbar_input_text'")}
    enter_text("* id:'activity_location_new_restaurants_search_toolbar_input_text'", location)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'location_list_view_item_title'")}
    touch("* id:'location_list_view_item_title'")
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view'")}
  end

  # Check if a previous location search in Near Me was saved 
  # @param location
  def check_near_me_location_is_saved (location)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'location_list_view_item_title'")}
    number_of_resoults = query("* id:'location_list_view_item_title'").count
    for i in 0..number_of_resoults - 1
      if query("* id:'location_list_view_item_title' index:#{i}")[0]['text'].include? location
        return
      end
    end

    fail(msg = "Error. check_near_me_location_is_saved. #{location} was not saved in the Near Me previous search")
  end

  def validate_map_results
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_map_new_restaurants_map'")}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_new_restaurant_carousel_item_title'")}
    sleep(1)
    restaurant_name = ''

    for i in 0..2
      restaurant_name = (query "* id:'view_new_restaurant_carousel_item_title'")[0]['text']
      puts "Restaurant name from map view:#{restaurant_name}"
      perform_action('drag', 50,30,90,90,10)
      sleep(1)
    end

    perform_action('drag', 50,50,50,90,10)
    sleep(1)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_map_new_restaurants_search_area_button'")}
    touch("* id:'fragment_map_new_restaurants_search_area_button'")
    wait_for(:timeout => 30, :post_timeout => 1){element_does_not_exist("* id:'fragment_map_new_restaurants_search_area_button'")}
    puts "Restaurant name from map view after moving the map for a new area:#{(query "* id:'view_new_restaurant_carousel_item_title'")[0]['text']}"
  end

  def search_restaurant (restaurantName)
    enter_text("* id:'view_search_toolbar_input_text'", restaurantName)
    hide_soft_keyboard
  end
  
  def choose_result (restaurantName)
    restaurant = query(TXV_RESTAURANT_NAME)
    
    while restaurant.empty? 
      perform_action('drag',50,50,50,20,20)
      #scroll('Down')
      restaurant = query(TXV_RESTAURANT_NAME)
    end

    touch(TXV_RESTAURANT_NAME)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView id:'view_restaurant_details_header_title'")}
  end
end

