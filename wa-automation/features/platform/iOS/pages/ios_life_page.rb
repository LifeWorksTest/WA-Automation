# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSLifePage < Calabash::IBase
  LBL_EAP = "label marked:'#{IOS_STRINGS["WAMEmployeeAsstanceTitleLabel"]}'"
  
  def trait
    LBL_EAP
  end

  def is_visible (page)
    case page
    when 'EAP_Page'
      wait_for(:timeout => 30,:post_timeout => 2){element_exists(LBL_EAP)}
      wait_for(:timeout => 30, :post_timeout => 2){element_exists("WKWebView css:'DIV' class:'size-xl font-semibold'")}
      @CATEGORY_LIST = query("WKWebView css:'DIV' class:'size-xl font-semibold'")
    end
  end

  # Validates that Categories are displayed on EAP life screen and that they have sub-categories limked to them
  def eap_screen_validate_categories
    is_visible('EAP_Page')
  	no_of_categories = query("WKWebView css:'DIV' class:'size-xl font-semibold'").count
		
	  if no_of_categories == 0
      fail(msg = "Error. eap_screen_validate_categories. There are no categories displayed in this page.")
    end

  	for i in 0..no_of_categories - 1
  	  label = @CATEGORY_LIST[i]["textContent"]
  	  
      touch("WKWebView marked:'#{label}'")
  	  wait_for(:timeout => 30, :post_timeout => 2){element_exists("WKWebView css:'DIV' class:'font-bold size-lg'")}
  	  no_of_sub_categories = query("WKWebView css:'DIV' class:'font-bold size-lg'").count
  	  puts "no_of_sub_categories is #{no_of_sub_categories}"
  	   
  	  if no_of_sub_categories == 0
      	fail(msg = "Error. eap_screen_validate_categories. There are no sub-categories displayed in this page.")
      end
  	  
  	  touch("WKWebView marked:'#{label}'")
  	  wait_for(:timeout => 30, :post_timeout => 2){element_does_not_exist("WKWebView css:'DIV' class:'font-bold size-lg'")}
  	end
  end

  # Opens one of the article in the second category element stored in categories_list array.
  def open_an_article
    is_visible('EAP_Page')
    
    category_lbl = @CATEGORY_LIST[2]["textContent"]
    touch("WKWebView marked:'#{category_lbl}'")
    wait_for(:timeout => 30){element_exists("WKWebView css:'DIV' class:'font-bold size-lg'")}
    
    # Clicks on the last displayed sub-category for opening the article
    sub_category_lbl = query("WKWebView css:'DIV' class:'font-bold size-lg'")[1]["textContent"]
    touch("WKWebView marked:'#{sub_category_lbl}'")
    wait_for(:timeout => 30){element_exists("WKWebView css:'DIV' class:'font-bold size-lg'")}
    touch("WKWebView css:'DIV' class:'font-bold size-lg'")
    wait_for(:timeout => 30,:post_timeout => 2){("WKWebView css:'DIV' class:'font-bold'")}
    touch("WKWebView css:'SPAN'{textContent CONTAINS 'Home'}")
    wait_for(:timeout => 30){element_exists(LBL_EAP)}
  end                  
end 