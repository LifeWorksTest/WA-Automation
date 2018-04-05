# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidShopOnlinePage < Calabash::ABase
  TXV_SHOP_ONLINE = "AppCompatTextView marked:'Shop Online'"
  TXV_RECOMMENDED = "AppCompatTextView id:'psts_tab_title' marked:'Recommended'"
  TXV_FEATURED = "AppCompatTextView id:'psts_tab_title' marked:'Featured'"
  TXV_BROWSE = "* marked:'Browse'"
  TXV_POPULAR = "AppCompatTextView id:'psts_tab_title' marked:'Popular'"
  TXV_READ_MORE = "AppCompatTextView marked:'Read More'"
  TXV_TERMS_CONDITIONS = "AppCompatButton id:'fragment_retailer_details_terms_and_conditions_button' marked:'Terms and Conditions'"
  TXF_SEARCH = "android.widget.EditText id:'search_src_text'"
  TXV_RETAILERS = "* marked:'Retailers'"
  TXV_PRODUCTS = "* marked:'Products'"

  BTN_FEATURED_CASHBACK_SEE_ALL = "* id:'fragment_shopping_Retailer_grid_mvp_section_title' sibling * index:0"
  BTN_FEATURED_OFFERS_SEE_ALL = "* id:'fragment_shopping_offer_short_list_title' sibling * index:0"
  BTN_RECOMMENDED_OFFERS_SEE_ALL = "* id:'fragment_shopping_offer_short_list_title' sibling * index:0"
  BTN_POPULAR_SEE_ALL = "* id:'fragment_shopping_Retailer_grid_mvp_section_title' sibling * index:0"

  BTN_BACK = "AppCompatImageButton contentDescription:'Navigate up'"
  BTN_SHOP_NOW = "android.widget.Button marked:'Shop Now'"
  BTN_EMAIL_LINK = "android.widget.Button marked:'Email Link'"
  BTN_FAVOURITED = "* contentDescription:'Unfavorite'"
  BTN_FAVOURITE = "* contentDescription:'Favorite'"
  BTN_SEARCH = "ActionMenuItemView id:'action_search'"

  CAROUSEL = "CarouselViewPager id:'fragment_carousel_view_pager'"

  def trait
    sleep(2)
    
    if element_exists("* marked:'Let\\'s go'")
      touch("* marked:'Let\\'s go'")
    end

    TXV_SHOP_ONLINE
  end

  def is_visible (page)
    case page
    when 'BROWSE'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'listContainer'")}
    when 'FEATURED'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(CAROUSEL)}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FEATURED_CASHBACK_SEE_ALL)}
    when 'RECOMMENDED'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView id:'fragment_shopping_offer_short_list_title' marked:'Recommended Offers'")}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_RECOMMENDED_OFFERS_SEE_ALL)}
    when 'POPULAR'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView id:'fragment_shopping_Retailer_grid_mvp_section_title' marked:'Popular Cashback'")}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_POPULAR_SEE_ALL)}
    when 'retailer page'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'action_favourite'")}
      sleep(1)
      
      if element_exists("* marked:'Got it'")
        touch("* marked:'Got it'")
      end

      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SHOP_NOW)}
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_EMAIL_LINK)}
    end
  end

  def click_button (button)
    case button
    when 'SEE ALL Featured Cashback'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FEATURED_CASHBACK_SEE_ALL)}
      touch(BTN_FEATURED_CASHBACK_SEE_ALL)            
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Featured Cashback'")}
    when 'SEE ALL Recommended Offers'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_RECOMMENDED_OFFERS_SEE_ALL)}
      touch(BTN_RECOMMENDED_OFFERS_SEE_ALL)            
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Recommended Offers'")}
    when 'SEE ALL Popular Cashback'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_POPULAR_SEE_ALL)}
      touch(BTN_POPULAR_SEE_ALL)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Popular Cashback'")}
    when 'Back'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      sleep(1)    
    when 'READ MORE'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_READ_MORE)}
      touch(TXV_READ_MORE)
    when 'Terms & Condition'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_TERMS_CONDITIONS)}
      touch(TXV_TERMS_CONDITIONS)
    when 'FEATURED'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_FEATURED)}
      touch(TXV_FEATURED)
      is_visible('FEATURED')
    when 'RECOMMENDED'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_RECOMMENDED)}
      touch(TXV_RECOMMENDED)
      is_visible('RECOMMENDED')
    when 'POPULAR'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_POPULAR)}
      touch(TXV_POPULAR)
      is_visible('POPULAR')
    when 'BROWSE'
      perform_action('drag', 10, 50, 15, 15, 5)
      sleep(0.5)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_BROWSE)}
      touch(TXV_BROWSE)
      is_visible('BROWSE')
    when 'search'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXF_SEARCH)}
    when 'favourite'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FAVOURITE)}
      touch(BTN_FAVOURITE)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FAVOURITED)}
    when 'unfavorite'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FAVOURITED)}
      touch(BTN_FAVOURITED)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_FAVOURITE)}
    else 
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end
  end

  # Go over all retailers in list. Open the retailer page and validate data
  def go_over_current_list
    wait_for(:timeout => 30){element_exists("* id:'list'")}
    number_of_retailers_in_list_view = query("* id:'list' child LinearLayout").size
  
    for i in 0..number_of_retailers_in_list_view - 1
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout index:#{i} * TextView")}
      retailer_cashback = query("TextView id:'view_retailer_list_item_cashback' index:#{i}")[0]['text']
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout index:#{i} * TextView")}
      retailer_summary = query("TextView id:'view_retailer_list_item_description' index:#{i}")[0]['text']
      retailer_name = (/[^-]*/.match retailer_summary)[0][0..-2]

      puts "i:#{i} retailer_cashback:#{retailer_cashback} retailer_summary:#{retailer_summary} retailer_name:#{retailer_name}"

      open_retailer_page_by_index(i, retailer_name)

      if retailer_cashback.include? 'Up to'
        up_to_cashbach_amount = (/\d+/.match retailer_cashback)[0]
        
        wait_poll(:until_exists => "WrappableViewPager id:'fragment_retailer_details_cashback_viewpager' TextView index:0 {text CONTAINS '#{up_to_cashbach_amount}% boosted cashback'}", :timeout => 15) do
          perform_action('drag', 50, 10, 60, 60, 5)
          sleep(0.5)
        end
      elsif
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_retailer_details_cashback_viewpager' TextView index:0'")}
        retailer_cashback_was = query("* id:'fragment_retailer_details_cashback_viewpager' TextView index:0'")[0]['text']
        
        if retailer_cashback_was.include? retailer_cashback 
          fail(msg = "Erro. go_over_current_list. Retailer cashbach in retailer page is #{retailer_cashback_was} while expecting to #{retailer_cashback}")
        end        
      end

      validate_retailer_page
      click_button('Back')
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list'")}
    end
  end

  # Validate retailer data
  def validate_retailer_page
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'retailer_name'")}
    retailer_name = query("AppCompatTextView id:'retailer_name'")[0]['text']
    click_button('READ MORE')

    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'retailer_full_description_title' marked:'#{retailer_name}'")}
    wait_for(:timeout => 30){element_exists("AppCompatTextView id:'retailer_full_description_details'")}
    system 'adb shell input keyevent 4'
    wait_for(:timeout => 30){element_does_not_exist("FrameLayout id:'customViewFrame'")}

    wait_poll(:until_exists => TXV_TERMS_CONDITIONS, :timeout => 15) do 
      perform_action('drag', 50, 60, 50, 20, 5)
      sleep(0.5)
    end

    click_button('Terms & Condition')
    click_button('Back')
  end

  # Select category
  # @param category
  def select_category (category)
    wait_poll(:until_exists => "TextView marked:'#{category}'", :timeout => 30, :post_timeout => 1) do 
      scroll_up
    end

    touch("TextView marked:'#{category}'")
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'view_toolbar_wrapper_spinner_title' marked:'#{category}'")}
  end

  # Search for the given retailer
  # @param retailer_name
  # @param state - 'exsits' or 'not exists'
  def search_for_retailer (retailer_name, state = 'exists')
    click_button('search')
    enter_text(TXF_SEARCH, retailer_name)

    if state == 'exists'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'listContainer' child * LinearLayout index:0")}
      touch("* id:'listContainer' child * LinearLayout index:0")

      is_visible('retailer page')
      
      if retailer_name != query("* id:'retailer_name'")[0]['text']
        fail("Error. go_over_current_list. Retailer name is not match with the retailer name in the list")
      end
    else
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'empty'")}
    end
  end

  # Favourite unfavourite retailer
  # @param action - "favourite" or "unfavorite"
  def favourite_unfavourite_retailer (action)
    if action == 'favourite'
      if element_exists(BTN_FAVOURITE)
        click_button('favourite')
      end
    elsif action == 'unfavourite'
      if element_exists(BTN_FAVOURITED)
        click_button('unfavorite')
      end
    end
  end

  # Select retailer from list 
  # @param retailer_name
  def check_if_retailer_is_in_favourites (retailer_name, state)
    retailer_name = retailer_name.to_s
    retailer_was_found = false

    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout")}
    number_of_retailer_in_list = query("* id:'list' child LinearLayout").size
    
    if number_of_retailer_in_list == 0 && state == 'not exists'
      return
    end

    if number_of_retailer_in_list == 0 && state == 'exists'
      fail("Error. go_over_current_list. Retailer name:#{retailer_name} should be at the favourites list but the list is empty.")
    end

    if state == 'exists'
      for i in 0..number_of_retailer_in_list - 1
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'list' child LinearLayout index:#{i} * TextView")}
        retailer_summary = query("* id:'list' child LinearLayout index:#{i} * TextView")[2]['text']
        retailer_name_temp = retailer_summary.split('-').first[0..-2]
        
        puts "Retailer summary is ---- #{retailer_summary} and retailer_name_temp is #{retailer_name_temp}"

        if retailer_name == retailer_name_temp
          puts "Retailer was found"
          retailer_was_found = true
          retailer_index_in_list = i
          break
        end
      end
    end  

    if state == 'exists' && !retailer_was_found
      fail("Error. go_over_current_list. Retailer name:#{retailer_name} should be at the favourites list but was not found in the first four places.")
    end

    if state == 'not exists' && retailer_was_found
      fail("Error. go_over_current_list. Retailer name:#{retailer_name} was found in favourites list.")
    end

    if state == 'exists' && retailer_was_found
      open_retailer_page_by_index(retailer_index_in_list, retailer_name)
    end
  end

  # Open retailer page by index
  # @param retailer_index
  # @param retailer_name
  def open_retailer_page_by_index (retailer_index, retailer_name)
    touch("* id:'list' child LinearLayout index:#{retailer_index}")
    is_visible('retailer page')
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'content' TextView")}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'retailer_name'")}

    if retailer_name != query("* id:'retailer_name'")[0]['text']
      fail("Error. go_over_current_list. Retailer name is not match with the retailer name in the list")
    end
  end
end
