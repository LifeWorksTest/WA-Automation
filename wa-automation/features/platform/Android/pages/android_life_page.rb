# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidLifePage < Calabash::ABase
    LBL_EAP = "* text:'Employee Assistance'"
  
    def trait
        LBL_EAP
    end

    def is_visible(page)
        case page
        when 'EAP_Page'
          wait_for(:timeout => 30,:post_timeout => 2){element_exists(LBL_EAP)}
          wait_for(:timeout => 30,:post_timeout => 2){element_exists("WebView css:'DIV' class:'size-xl font-semibold'")}
          @CATEGORY_LIST = query("WebView css:'DIV' class:'size-xl font-semibold'")  
        else 
          fail(msg = "Error. is_visible. The button #{button} is not defined.")
        end  
    end

    # Validates that Categories are displayed on EAP life screen and that they have sub-categories limked to them
    def validate_catogries
      is_visible('EAP_Page')
      no_of_categories = query("WebView css:'DIV' class:'size-xl font-semibold'").count
          
      if no_of_categories == 0
         fail(msg = "Error. validate_catogries. There are no categories displayed in this page.")
      end

      for i in 0..no_of_categories - 1
          label = @CATEGORY_LIST[i]["textContent"]
          
          touch("WebView css:'Div' textContent:'#{label}'")
  	      wait_for(:timeout => 30, :post_timeout => 2){element_exists("WebView css:'DIV' class:'font-bold size-lg'")}
  	      no_of_sub_categories = query("WebView css:'DIV' class:'font-bold size-lg'").count
          puts "no_of_sub_categories is #{no_of_sub_categories}"
           
          if no_of_sub_categories == 0
             fail(msg = "Error. validate_catogries. There are no sub-categories displayed in this page.")
          end

          touch("WebView css:'Div' textContent:'#{label}'")
          wait_for(:timeout => 30, :post_timeout => 2){element_does_not_exist("WebView css:'DIV' class:'font-bold size-lg'")}
      end 
    end

    def open_an_article
        is_visible('EAP_Page')
        
        category_lbl = @CATEGORY_LIST[2]["textContent"]
        touch("WebView css:'Div' textContent:'#{category_lbl}'")
        wait_for(:timeout => 30){element_exists("WebView css:'DIV' class:'font-bold size-lg'")}
        
        # Clicks on the last displayed sub-category for opening the article
        sub_category_lbl = query("WebView css:'DIV' class:'font-bold size-lg'")[1]["textContent"]
        touch("WebView  css:'Div' textContent:'#{sub_category_lbl}'")
        wait_for(:timeout => 30){element_exists("WebView css:'DIV' class:'font-bold size-lg'")}
        text_before_opening_article = query("WebView css:'DIV' class:'font-bold size-lg'")[0]["textContent"]
        touch("WebView css:'DIV' class:'font-bold size-lg'")
        wait_for(:timeout => 30,:post_timeout => 2){("WebView css:'DIV' class:'font-bold'")}
        text_after_opening_article = query("WebView css:'DIV' class:'font-bold pdf-article-title'")[0]["textContent"]
        touch("WebView css:'SPAN'{textContent CONTAINS 'Home'}")
        wait_for(:timeout => 30){element_exists(LBL_EAP)}      
        
        unless text_before_opening_article == text_after_opening_article       
         fail "Wrong article is opened!! Expected to see '#{text_before_opening_article}' article, but opened '#{text_after_opening_article}' article."
        else
         puts "Correct article is opened!! Expected to see '#{text_before_opening_article}' article and opened '#{text_after_opening_article}' article."
        end              
    end  	    
end    