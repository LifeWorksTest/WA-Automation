# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSShopOnlinePage < Calabash::IBase
  BTN_SEE_ALL_FEATURED_CASHBACK = "label marked:'#{IOS_STRINGS["WAMShopOnlineFeaturedCashbackTitle"]}' sibling *"
  BTN_SEE_ALL_FEATURED_OFFERS =  "label marked:'#{IOS_STRINGS["WAMShopOnlineFeaturedOffersTitle"]}' sibling *"
  BTN_SEE_ALL_POPULAR_IN_NETWORK =  "label marked:'#{IOS_STRINGS["WAMShopOnlinePopularInNetworkTitle"]}' sibling *"
  BTN_SEE_ALL_RECOMMENDED_OFFERS =  "label marked:'#{IOS_STRINGS["WAMShopOnlineRecommendedOffersTitle"]}' sibling *"
  BTN_BACK = "UINavigationBar descendant * index:6"
  BTN_X = "button marked:'ic close'"
  BTN_CLOSE = "button marked:'#{IOS_STRINGS["WAMFoundationCloseKey"]}'"
  BTN_HEART = "* marked:'ic heart default'"
  BTN_HEART_FILLED = "* marked:'ic heart default'"
  BTN_SAVE_OFFER = "button marked:'#{IOS_STRINGS["WAMFoundationSaveKey"]}' index:0"
  BTN_OFFER_SAVED = "button marked:'#{IOS_STRINGS["WAMShopOnlineRetailerSavedButton"]}' index:0"
  BTN_X_WHITE = "button marked:'bt close white'"
  BTN_SEARCH = "* marked:'Search'"
  BTN_SEARCH_CLOSE = "UIImageView id:'shoponline_search_cancel'"

  LBL_RETAILERS = "label marked:'#{IOS_STRINGS["WAMShopOnlineCompareRetailersListTitle"]}'"
  LBL_PRODUCTS =  "label marked:'#{IOS_STRINGS["WAMShopOnlineSearchProductsSegmentTitle"]}'"
  LBL_BROWSE =  "label marked:'#{IOS_STRINGS["WAMShopOnlineBrowseCategoryText"]}'"
  LBL_BROWSE_RETAILERS = "label marked:'#{IOS_STRINGS["WAMShopOnlineBrowseRetailersTitle"]}'"
  LBL_SHOP_ONLINE = "label marked:'#{IOS_STRINGS["WAMShopOnlineViewControllerTitle"]}'"
  LBL_SHOP_NOW = "label marked:'#{IOS_STRINGS["WAMShopOnlineRetailerShopNow"]}'"
  LBL_READ_MORE = "label marked:'#{IOS_STRINGS["WAMFoundationReadMore"]}'"
  LBL_READ_LESS = "label marked:'#{IOS_STRINGS["WAMFoundationReadLess"]}'"
  LBL_RETAILER_DETAIILS = "label marked:'#{IOS_STRINGS["WAMShopOnlineRetailerDetails"]}'"
  LBL_TERMS_AND_CONDITIONS = "label marked:'#{IOS_STRINGS["WAMShopOnlineRetailerTermsAndConditions"]}'"
  LBL_CANCEL = "* marked: '#{IOS_STRINGS["WAMFoundationCancelKey"]}'"


  TXF_SEARCH = "UISearchBarTextField index:0"

  IMG_SPINNER = "imageView id:'spin'"

  def trait
    wait_for_none_animating

    if element_exists("WAMMainFlatButton")
      wait_for_none_animating
      touch("WAMMainFlatButton")
      wait_for(:timeout => 30){element_does_not_exist("WAMMainFlatButton")}
    end

    LBL_SHOP_ONLINE
  end

  def click_button (button)
    case button
    when 'X'
      if element_exists(BTN_X_WHITE)
        touch(BTN_X_WHITE)
        wait_for(:timeout => 30){element_does_not_exist(BTN_X_WHITE)}
      elsif (device_agent.query({type: "Button", marked: "Done"})) != []
        sleep(1)
        device_agent.touch({type: "Button", marked: "Done"})
        sleep(2)
        wait_for(:timeout => 30){element_exists(BTN_BACK)}
      else
        wait_for(:timeout => 30){element_exists(BTN_X)}
        touch(BTN_X)    
        sleep(2)  
      end
    when 'See All Featured Cashback'
      wait_for(:timeout => 30){element_exists(BTN_SEE_ALL_FEATURED_CASHBACK)}
      touch(BTN_SEE_ALL_FEATURED_CASHBACK)
      wait_for(:timeout => 30){element_exists("UILabel marked:'#{IOS_STRINGS["WAMShopOnlineFeaturedCashbackTitle"]}'")}
    when 'See All Featured Offers'
      scroll("scrollView index:0", :down)
      wait_for_none_animating

      wait_for(:timeout => 30){element_exists(BTN_SEE_ALL_FEATURED_OFFERS)}
      scroll("scrollView index:0", :down)
      touch(BTN_SEE_ALL_FEATURED_OFFERS)
      wait_for(:timeout => 30){element_exists("UILabel marked:'#{IOS_STRINGS["WAMShopOnlineFeaturedOffersTitle"]}'")}
    when 'See All Popular in Network'
      wait_poll(:retry_frequency => 0.5,:until_exists => BTN_SEE_ALL_POPULAR_IN_NETWORK, :timeout => 30) do
        scroll("scrollView index:0", :down)
        wait_for_none_animating
      end

      scroll("scrollView index:0", :down)
      sleep(2)
      touch(BTN_SEE_ALL_POPULAR_IN_NETWORK)
      wait_for(:timeout => 30){element_exists("UILabel marked:'#{IOS_STRINGS["WAMShopOnlinePopularInNetworkTitle"]}'")}
    when 'See All Recommended Offers'

      scroll_to_the_bottom
      wait_poll(:retry_frequency => 0.5,:until_exists => BTN_SEE_ALL_RECOMMENDED_OFFERS, :timeout => 30) do
        scroll('scrollView index:0', :up)
        wait_for_none_animating
      end
      
      flash(BTN_SEE_ALL_RECOMMENDED_OFFERS)
      touch(BTN_SEE_ALL_RECOMMENDED_OFFERS)
      sleep(1)
      wait_for(:timeout => 30){element_exists("UILabel marked:'#{IOS_STRINGS["WAMShopOnlineRecommendedOffersTitle"]}'")}
    when 'Browse by Category'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(LBL_BROWSE)}
      touch(LBL_BROWSE)
      wait_for(:timeout => 30){element_exists("UILabel marked:'#{IOS_STRINGS["WAMShopOnlineBrowseCategoryText"]}'")}
    when 'Save Offer'
      if element_exists(BTN_OFFER_SAVED)
        touch(BTN_OFFER_SAVED)
      end

      wait_for(:timeout => 30){element_exists(BTN_SAVE_OFFER)}
      touch(BTN_SAVE_OFFER)
      wait_for(:timeout => 30){element_exists(BTN_OFFER_SAVED)}
    when 'Offer Saved'
      wait_for(:timeout => 30){element_exists(BTN_OFFER_SAVED)}
      touch(BTN_OFFER_SAVED)
      wait_for(:timeout => 30){element_exists(BTN_SAVE_OFFER)}
    when 'Close'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_CLOSE)}
      touch(BTN_CLOSE)
      wait_for_none_animating
    when 'Back'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      sleep(1)
    when 'Read More'
      wait_for(:timeout => 30){element_exists(LBL_READ_MORE)}
      touch(LBL_READ_MORE)
      wait_for(:timeout => 30){element_exists(LBL_READ_LESS)}
    when 'Read Less'
      wait_for(:timeout => 30){element_exists(LBL_READ_LESS)}
      touch(LBL_READ_LESS)
      wait_for(:timeout => 30){element_exists(LBL_READ_MORE)}
    when 'Favourite heart'
      wait_for_none_animating
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_HEART)}
      touch(BTN_HEART)
      wait_for(:timeout => 30){element_exists(BTN_HEART_FILLED)}
    when 'Unfavourite'
      wait_for_none_animating
      wait_for(:timeout => 30){element_exists(BTN_HEART_FILLED)}
      touch(BTN_HEART_FILLED)
      wait_for(:timeout => 30){element_exists(BTN_HEART)}
    when 'Search'
      wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      wait_for(:timeout => 30){element_exists(TXF_SEARCH)}
    when 'Terms & Conditions'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(LBL_TERMS_AND_CONDITIONS)}
      touch(LBL_TERMS_AND_CONDITIONS)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMShopOnlineRetailerTermsAndConditions"]}'")}
    when 'Shop Now'
      wait_for(:timeout => 30){element_exists(LBL_SHOP_NOW)}
      touch(LBL_SHOP_NOW)
      wait_for(:timeout => 30){element_exists(BTN_X)}
    when 'Retailers'
      wait_for_none_animating
      wait_for(:timeout => 30){element_exists(LBL_RETAILERS)}
      touch(LBL_RETAILERS)
      wait_for_none_animating
     when 'Products'
      wait_for_none_animating
      wait_for(:timeout => 30){element_exists(LBL_PRODUCTS)}
      touch(LBL_PRODUCTS)
      wait_for_none_animating
    when 'Cancel'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(LBL_CANCEL)}
      flash(LBL_CANCEL)
      touch(LBL_CANCEL)
      wait_for_none_animating
    else
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")
    end

    if element_exists(IMG_SPINNER)
      wait_for(:timeout => 30){element_does_not_exist(IMG_SPINNER)}
    end

    if element_exists("* id:'bt_close_white'")
      wait_for_none_animating
      touch("* id:'bt_close_white'")
      wait_for_none_animating
      wait_for(:timeout => 30){element_does_not_exist("* id:'bt_close_white'")}
    end
  end

  # Open retailer page
  # @retailer_name
  def open_retailer_page (retailer_name)
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("WAMShopOnlineRetailerTableViewCell index:0")}
    wait_for_none_animating 
    touch("WAMShopOnlineRetailerTableViewCell")
    wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMShopOnlineRetailerDetails"]}'")}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("label marked:'#{retailer_name}'")}
  end

  # Open product page
  # @product_name
  def open_product_page (retailer_name)
    wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:'0'")}
    wait_for_none_animating
    sleep(2)
    number_of_products = query("UITableViewCellContentView").size
    puts "number_of_products:#{number_of_products}"
    
    for i in 0..number_of_products - 1
      query "textField isFirstResponder:1", :resignFirstResponder
      puts "i is #{i}"
      wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:#{i}")}
      touch("UITableViewCellContentView index:#{i}")
      wait_for_none_animating

      if element_exists("label marked:'#{IOS_STRINGS["WAMShopOnlineSearchNoResultsTitle"]}'")
        fail(msg = 'Error. open_product_page. Product page does not have any offers')
      end 
        
      click_button('Back')
    end
  end

  # Unsave first offer
  def unsave_first_offer
    wait_for_none_animating

    scroll("scrollView index:0", :down)
    wait_for_none_animating

    click_button('Offer Saved')
    click_button('Back')
    click_button('Back')
  end

  # Save first offer in the list
  def save_first_offer
    wait_for_none_animating
    
    scroll("scrollView index:0", :down)
    wait_for_none_animating
    @offer_deal =  query("button marked:'Save' index:0 sibling * index:0")[0]['text']
    @offer_cashback = query("button marked:'Save' index:0 sibling * index:1")[0]['text']
    wait_for(:timeout => 30){element_exists("button marked:'#{IOS_STRINGS["WAMShopOnlineRetailerShopNow"]}'")}
    puts "@offer_deal:#{@offer_deal}"
    puts "@offer_cashback:#{@offer_cashback}"

    click_button('Save Offer')
    click_button('Back')
    click_button('Back')
  end

  # Validate that the last saved offer is in or not in Saved Offer list
  # @param option - 'in' or 'not in'
  def validate_last_saved_offer_is_in_list (option)
    wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMShopOnlineCategorySaveOffers"]}'")}
    
    if option == 'is in' 
      wait_for(:timeout => 30){element_exists("UITableViewCellContentView label marked:'#{@offer_deal}'")}
      wait_for(:timeout => 30){element_exists("UITableViewCellContentView label marked:'#{@offer_cashback}'")}
    elsif option == 'is not in'
      wait_for_none_animating
      
      if element_exists("UITableViewCellContentView label marked:'#{@offer_deal}'") && element_exists("UITableViewCellContentView label marked:'#{@retailer_name} - #{@offer_text}'")
        fail(msg = 'Error. validate_last_saved_offer_is_in_list. Offer was not removed from Saved Offers list')
      end
      
      if query("UITableViewCellContentView").size == 0
        wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMFoundationEmptyScreenTitle"]}'")}
      end
    end

    click_button('Back')
    click_button('Close')
  end

  # Validate that the retailer is in or not in Favourites
  # @param option - 'in' or 'not in'
  def validate_retailer_is_in_favourites (option)
    if option == 'in'
      wait_for(:timeout => 30){element_exists("label marked:'#{@retailer_name}'")}
    elsif option == 'not in'
      wait_for_none_animating
      
      if element_exists("label marked:'#{@retailer_name}'")
        fail(msg = 'Error. validate_retailer_is_in_favourites. Retailer was not removed from Favourites list')
      end

      if query("UITableViewCellContentView").size == 0
        wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMFoundationEmptyScreenTitle"]}'")}
      end
    end
  end
  
  # Go over current list of retailer and validate retailer page
  # @parm current_page - the current view if current_page=nil it means that the current view is Featured Cashback
  # else if is Popular in Network or Recommended Offers 
  def go_over_current_table (current_page = nil)
    wait_for_none_animating
    wait_for(:timeout => 30){element_exists("UITableViewCellContentView")}
    number_of_retailers_in_page = query("UITableViewCellContentView").size
    puts "number_of_retailers_in_page:#{number_of_retailers_in_page}"
    
    for i in 0..number_of_retailers_in_page - 2   
      wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:#{i} label index:0")}
      retailer_cashback = query("UITableViewCellContentView index:#{i} label index:0")[0]['text']
      puts "retailer_cashback:#{retailer_cashback}"
      cashback_up_to = false

      if retailer_cashback.include? 'Up to'
        if (query("UITableViewCellContentView index:#{i} label descendant * index:1")[0]['text']).split(" ",2)[1] != ("#{IOS_STRINGS["WAMShopOnlineRetailerCellRatesAvailable"]}"[3..-1])
          fail(msg = 'Error. go_over_current_table. Cashback rates are not available')
        end  
        
        cashback_up_to = true
        retailer_name = (/[^ -]*/.match (query("UITableViewCellContentView index:#{i} label index:2"))[0]['text'])[0]
      else
        if current_page != nil
          wait_for(:timeout => 30){element_exists("UITableViewCellContentView index:#{i} label index:2")}
          retailer_name =  (/[^-]*[^- ]/.match (query("UITableViewCellContentView index:#{i} label index:2"))[0]['text'])[0]
        else
          wait_for(:timeout => 30, :post_timeout => 1){element_exists("UITableViewCellContentView index:#{i} label index:1")}
          retailer_name = (/[^-]*[^- ]/.match (query("UITableViewCellContentView index:#{i} label index:1"))[0]['text'])[0]
        end
      end
      
      wait_for(:timeout => 30,:post_timeout => 1){element_exists("UITableViewCellContentView index:#{i}")}
      touch("UITableViewCellContentView index:#{i}")
      wait_for_none_animating

      if current_page == nil
        wait_for(:timeout => 30){element_exists(LBL_SHOP_NOW)}
        wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMShopOnlineRetailerDetails"]}'")}
        wait_for(:timeout => 30){element_exists("label marked:'#{retailer_name}'")}
        
        click_button('Read More')
        click_button('Read Less')

        wait_for_none_animating
        scroll("scrollView index:0", :down)
        wait_for_none_animating

        wait_poll(:retry_frequency => 0.5,:until_exists => LBL_TERMS_AND_CONDITIONS, :timeout => 30) do
          scroll("scrollView", :down)
        end

        scroll("scrollView", :down)
        click_button('Terms & Conditions')
        click_button('Back')
        click_button('Back')
      else
        #wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{retailer_name}'")}
        click_button('X')
      end
    end
  end

  # Select category from list
  # @param category - to select
  def select_category (category)
    wait_for_none_animating
    wait_for(:timeout => 30){element_does_not_exist(IMG_SPINNER)}
    
    wait_poll(:retry_frequency => 0.5,:until_exists => "label marked:'#{category}'", :timeout => 30) do
      scroll("scrollView index:0", :down)
      wait_for_none_animating
    end

    touch("label marked:'#{category}'")

    wait_for(:timeout => 30){element_exists(LBL_BROWSE_RETAILERS)}
    wait_for(:timeout => 30){element_exists("label marked:'#{category}'")}
  end

  # Select retailer from list
  # @param retailer_name
  def select_retailer (retailer_name)
    @retailer_name = retailer_name
    
    wait_poll(:retry_frequency => 0.5,:until_exists => "label marked:'#{retailer_name}'", :timeout => 30) do
      scroll("UITableView index:1", :down)
      wait_for_none_animating
    end

    touch("label marked:'#{retailer_name}'")
    wait_for(:timeout => 30){element_exists(LBL_RETAILER_DETAIILS)}
    wait_for(:timeout => 30){element_exists("label marked:'#{retailer_name}'")}
  end

  # Search for retailer or product
  # @search_for
  # @exists - if the product exists or not
  def search (search_for, search_type, exists)
    touch(TXF_SEARCH)
    wait_for_keyboard
    keyboard_enter_text(search_for)

    if exists == 'existing'
      wait_for(:timeout => 30){element_does_not_exist("label marked:'#{IOS_STRINGS["WAMShopOnlineSearchRetailerRecentTile"]}'")}
      
      if search_type == 'retailer'
        wait_for(:timeout => 30){element_exists("WAMShopOnlineRetailerTableViewCell")}
      elsif search_type == 'product'
        click_button('Products')
        wait_for(:timeout => 30){element_exists("UITableViewCellContentView")} 
      end   
    
    else exists == 'unexisting'
      wait_for(:timeout => 30){element_exists("label marked:'#{IOS_STRINGS["WAMShopOnlineSearchNoResultsTitle"]}'")}
    end
  end

  # Scroll to the bottom of the page
  def scroll_to_the_bottom
    scroll("scrollView index:0", :down)
    wait_for_none_animating
    
    i = 0
    while element_exists("WAMShopOnlineOfferTableViewCell index:#{i+1}")
      scroll("scrollView index:0", :down)
      wait_for_none_animating
      i = i + 1
    end 
  end     

  # Clear entered search field
  def clear_search
    click_button('Back')
    wait_for(:timeout => 30){element_exists("UISearchBarTextField index:0")}
    clear_text("UISearchBarTextField")
    wait_for_none_animating
    click_button('Cancel')
  end   

  # Return to the main page
  def return_to_main_page
    if element_exists(BTN_CLOSE)
      click_button('Close')
    end

    if element_exists(LBL_CANCEL)
      click_button('Cancel')
    end
  end
end
