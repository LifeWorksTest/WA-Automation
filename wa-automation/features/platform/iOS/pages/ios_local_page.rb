# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSLocalPage < Calabash::IBase
  LBL_LOCAL = "label marked:'#{IOS_STRINGS["WAMMenuItemLocalTitle"]}'"
  LBL_SERACH = "button marked:'Search'"
  LBL_MARKED = "label marked:'#{IOS_STRINGS["WAMDDFavouritesListTitle"]}'"
  LBL_ALL_CATEGORIES = "label marked:'#{IOS_STRINGS["WAMDDAllCategories"]}'"
  LBL_ALL_CATEGORIES_OPTION = ("label marked:'#{IOS_STRINGS["WAMDDAllCategories"]}' index:1")
  LBL_SHOPPING = "label marked:'#{IOS_STRINGS["WAMDailyDealsShoppingDealsTitle"]}'"
  LBL_TRAVEL = "label marked:'#{IOS_STRINGS["WAMDailyDealsTravelDealsTitle"]}'"

  BTN_LOCATIONS = "* id:'fragment_daily_deals_list_refine_bar' child *"
  BTN_GET_DEAL = "button marked:'#{IOS_STRINGS["WAMDDDetailGetDealButtonTitle"]}'"  
  BTN_BACK = "UINavigationBar child * index:1 descendant * index:4"
  BTN_FAVOURITE = "labek marked:'ic favourite default'"
  BTN_FAVOURITED = "label marked:'ic favourite active'"

  IMG_SPINNER = "imageView id:'spin'"

  def trait
    LBL_LOCAL
  end

  def is_visible (page)
    case page
    when 'main'
      wait_for(:timeout => 30){element_exists(LBL_CITY_DEALS)}
      wait_for(:timeout => 30){element_exists(LBL_SHOPPING)}
      scroll_down
      wait_for(:timeout => 30){element_exists(LBL_TRAVEL)}
    when 'All categories'
      wait_for(:timeout => 30){element_exists(LBL_ALL_CATEGORIES)}
      wait_for_none_animating
    when 'Shopping'
      wait_for(:timeout => 30){element_exists(LBL_SHOPPING)}
      touch(LBL_SHOPPING)
      wait_for(:timeout => 60){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMDailyDealsShoppingDealsTitle"]}'")}
    when 'Travel'
      wait_for(:timeout => 30){element_exists(LBL_TRAVEL)}
      touch(LBL_TRAVEL)
      wait_for(:timeout => 30){element_exists("UINavigationBar marked:'#{IOS_STRINGS["WAMDailyDealsTravelDealsTitle"]}'")}
    when 'Search'
      wait_for(:timeout => 30){element_does_not_exist("text")}
    end
  end

  def click_button (button)
    case button
    when 'Back'
      wait_for(:timeout => 30){element_exists(BTN_BACK)}
      touch(BTN_BACK)
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(LBL_LOCAL)}
    when 'All categories'
      touch(LBL_ALL_CATEGORIES)
      wait_for(:timeout => 30){element_exists(LBL_ALL_CATEGORIES_OPTION)}
      touch(LBL_ALL_CATEGORIES_OPTION)
      is_visible('All categories')
    when 'Shopping'
      wait_for(:timeout => 30){element_exists(LBL_SHOPPING)}
      touch(LBL_SHOPPING)
      is_visible('Shopping')
    when 'Travel'
      wait_for(:timeout => 30){element_exists(LBL_TRAVEL)}
      touch(LBL_TRAVEL)
      is_visible('Travel')
    when 'Search'
      wait_for(:timeout => 30){element_exists(BTN_SEARCH)}
      touch(BTN_SEARCH)
      is_visible('Search')
    else 
      fail(msg = "Error. click_button. Button '#{button}' is not defined.")  
    end

  end

  # Selects number of defined catefgories randomly
  # @param total_categories_to_select
  def select_random_categories(total_categories_to_select)
    number_of_categories = (total_categories_to_select.to_i) - 1 

    for i in 0..number_of_categories
      wait_for(:timeout => 30){element_exists("UIImageView id:'ic_arrow_dropdown'")}
      touch "UIImageView id:'ic_arrow_dropdown'"
      selecting_category = (0..(query("WAMCategoryCell").count)).to_a.sample(1)[0].to_i
      wait_for(:timeout => 30,:post_timeout => 1){element_exists("WAMCategoryCell index:#{selecting_category}")}
      touch("WAMCategoryCell index:#{selecting_category}")
      wait_for(:timeout => 30){element_does_not_exist("WAMCategoryCell index:#{selecting_category}")}
      wait_for_none_animating
      validate_deals_date
    end   
  end   

  def validate_deals_date
    wait_for_none_animating

    for i in 0..1      
      wait_for(:timeout => 30,:post_timeout => 1){element_exists("UITableViewCellContentView index:0")}
      offer_amount = query("UITableViewCellContentView index:0 label index:3")[0]['label']
      offer_cashback = query("UITableViewCellContentView index:0 label index:4")[0]['label']
      offer_text = query("UITableViewCellContentView index:0 label index:0")[0]['label']
      offer_time = query("UITableViewCellContentView index:0 label index:1")[0]['label']
      offer_provider = query("UITableViewCellContentView index:0 label index:2")[0]['label']
      puts "offer_amount:#{offer_amount} offer_cashback:#{offer_cashback} offer_text:#{offer_text} offer_time:#{offer_time} offer_provider:#{offer_provider}"
    
      flash("UITableViewCellContentView index:0")
      touch("UITableViewCellContentView index:0")
      
      wait_for(:timeout => 30){element_exists("label marked:'#{offer_amount}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{offer_cashback}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{offer_text}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{offer_time}'")}
      wait_for(:timeout => 30){element_exists("label marked:'#{offer_provider}'")}
      
      sleep(1)
      click_button('Back')
      scroll("scrollView", :down)
      sleep(0.5)
      scroll("scrollView", :down)
      sleep(0.5)
    end
  end
end
