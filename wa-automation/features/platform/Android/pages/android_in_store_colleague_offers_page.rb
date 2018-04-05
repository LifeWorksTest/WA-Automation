# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidInStoreColleagueOffersPage < Calabash::ABase
	TXV_IN_STORE_OFFERS = "AppCompatTextView marked:'In-Store'"

	BTN_EXPANED_IMAGE = "android.widget.Button marked:'Expand Image'"
  BTN_COPY_CODE = "android.widget.Button marked:'Copy Code'"
  BTN_SAVE_IMAGE = "com.afollestad.materialdialogs.internal.MDButton marked:'Save Image'"
  
	def trait
    "android.support.v7.widget.AppCompatTextView"
  end

  def click_button (button)
  	case button
  	when 'COPY CODE'
  		wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_COPY_CODE)}
  		touch(BTN_COPY_CODE)
  		wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Code copied to the clipboard'")}
  	when 'EXPAND IMAGE'
  		wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_EXPANED_IMAGE)}
  		touch(BTN_EXPANED_IMAGE)
  	when 'SAVE IMAGE'
      wait_for(:timeout => 30, :post_timeout => 1){element_exists(BTN_SAVE_IMAGE)}
      touch(BTN_SAVE_IMAGE)
      wait_for(:timeout => 30, :post_timeout => 1){element_exists("* marked:'Barcode saved in the Gallery.'")}
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end	
  end

  # Validate data of the offers
  def validate_data_in_page (page)
    #wait_for(:timeout => 30, :post_timeout => 1){element_exists(TXV_IN_STORE_OFFERS)}
    wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'offer_header_deals_label'")}
  	number_of_offer = (/\d+/.match query("* id:'offer_header_deals_label'")[0]['text'])[0].to_i
  	puts "There are #{number_of_offer} offers however the validation is for the first 4 offers"

  	for i in 0..2
  		if i == number_of_offer - 1
  			card_index = 1
  		else
  			card_index = 0
  		end

		  wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'card_view' index:#{card_index} * id:'view_offer_item_layout_retailer_name'")}
		  text_in_image = query("* id:'card_view' index:#{card_index} * id:'view_offer_item_layout_retailer_name'")[0]['text']
  		offer_text = query("* id:'card_view' index:#{card_index} * id:'view_offer_item_layout_offer_title'")[0]['text']
  		puts "#{i}/#{number_of_offer} card_index:#{card_index} text_in_image #{text_in_image} offer_text #{offer_text}"
  		touch("* id:'card_view' index:#{card_index}")
  		sleep(1)

  		wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'#{text_in_image}'")}
  		wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'#{offer_text}'")}
  		
      if page == 'In-Store Offers'
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'Claim In-Store'")}
  		
        wait_poll(:until_exists => BTN_COPY_CODE, :timeout => 60, :post_timeout => 1) do 
          perform_action('drag', 50, 50, 70, 50, 5)
        end

    	 click_button('COPY CODE')
  		  code_to_present = query("android.widget.Button marked:'Copy Code' sibling *")[0]['text']
  		
  		  if code_to_present == nil
  			 fail(msg = "Error. validate_data_in_page. Code to present in store for the next offer is #{text_in_image offer_text} is nil")
  		  end

        wait_poll(:until_exists => BTN_EXPANED_IMAGE, :timeout => 60, :post_timeout => 1) do 
          perform_action('drag', 50, 50, 70, 50, 5)
        end

  		  if element_exists(BTN_EXPANED_IMAGE)
  			 click_button('EXPAND IMAGE')
				  wait_for(:timeout => 30, :post_timeout => 1){element_exists("AppCompatTextView marked:'#{offer_text}'")}  		
				  click_button('SAVE IMAGE')
  		  end
      else 
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_offer_details_visit_website_label'")}
        wait_for(:timeout => 30, :post_timeout => 1){element_exists("* id:'fragment_offer_details_terms_and_cond_button'")} 
      end 
       
  		press_back_button
    	sleep(1)

    	perform_action('drag', 50, 50, 70, 55, 5)
    	sleep(1)
  	end
  end

end
