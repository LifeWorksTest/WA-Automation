# -*- encoding : utf-8 -*-
require 'calabash-cucumber/ibase'

class IOSInStoreColleagueOfferPage < Calabash::IBase
  LBL_IN_STORE_OFFERS = "label marked:'#{IOS_STRINGS["WAMMenuItemInstoreOffersTitle"]}'"
  LBL_OK = "label marked:'#{IOS_STRINGS["WAMFoundationOkKey"]}'"
  LBL_OFFER_T_AND_C_TEXT = IOS_STRINGS["WAMColleagueOffersTaCTitle"][0..-3]
  LBL_OFFER_AND_T_AND_C = ("label {text CONTAINS '#{LBL_OFFER_T_AND_C_TEXT}'}")
  
  BTN_VISIT_WEBSITE = "button marked:'#{IOS_STRINGS["WAMColleagueOffersOpenWebsite"]}'"
  BTN_BACK = "UIImageView id: 'ic_back_white_arrow'"
  BNT_BLUE_BACK = "UINavigationBar descendant * index:6"
  BTN_COPY_CODE = "button index:0"

  def trait
    "WAMColleagueOfferCell"
  end

  def click_button (button)
    case button
    when 'Visit Website'
      wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_VISIT_WEBSITE)}
      touch(BTN_VISIT_WEBSITE)
    when 'COPY CODE'
      wait_for(:timeout => 30){element_exists(BTN_COPY_CODE)}
      touch(BTN_COPY_CODE)
      wait_for(:timeout => 30){element_exists("* marked:'#{IOS_STRINGS["WAMColleagueOffersSavedToClipboard"]}'")}
      wait_for(:timeout => 30){element_exists(LBL_OK)}
    when 'T&C'
      wait_for(:timeout => 30){element_exists(LBL_OFFER_AND_T_AND_C)}
      touch(LBL_OFFER_AND_T_AND_C)
      wait_poll(:retry_frequency => 0.5, :until_exists => "label {text CONTAINS '#{IOS_STRINGS["WAMColleagueOffersTaCTermsTitle"]}'}") do
        scroll("scrollView", :down)
      end   
    when 'Ok'
      wait_for(:timeout => 30,:post_timeout => 2){element_exists(LBL_OK)}
      wait_for_none_animating
      touch(LBL_OK)
      wait_for(:timeout => 30){element_does_not_exist(LBL_OK)}
    when 'Back'
      wait_for(:timeout => 30, :post_timeout => 2){element_exists(BTN_BACK)}
      touch(BTN_BACK)
    when 'Blue Back'
      wait_for(:timeout => 30,:post_timeout => 2){element_exists(BNT_BLUE_BACK)}
      touch(BNT_BLUE_BACK)
    else
      fail(msg = "Error. click_button. The button #{button} is not defined.")
    end

    #wait_for_none_animating
  end

  # Validate data of the offers
  # @param page - In-Store or Colleague Offer
  def validate_data_in_page (page)
    wait_for(:timeout => 30){element_exists("label marked:'#{page}'")}
    wait_for(:timeout => 30){element_exists("WAMColleagueOfferCell")}
    number_of_offer = query("WAMColleagueOfferCell").count
    
    for i in 0..number_of_offer - 1
      if i == number_of_offer - 1
        card_index = 1
      else
        card_index = 0
      end

      wait_for(:timeout => 30){element_exists("WAMColleagueOfferCell index:#{i}")}
      offer_company = query("WAMColleagueOfferCell index:#{i} child * label index:0")[0]['text']
      offer_text = query("WAMColleagueOfferCell index:#{card_index} label index:1")[0]['text']

      puts "#{i+1}/#{number_of_offer} card_index:#{card_index} offer_text #{offer_text}"
      touch("WAMColleagueOfferCell index:#{card_index} label index:1")
      wait_for_none_animating

      if page == 'In-Store'
        if element_does_not_exist(BTN_COPY_CODE)    
          scroll("scrollView", :down)
          wait_for_none_animating
          click_button('COPY CODE')
          click_button('Ok')
          code_to_present = query("button index:0 child label")[0]['text']
      
          if code_to_present == nil
            fail(msg = "Error. validate_data_in_page. Code to present in store for the next offer is #{text_in_image} is nil")
          end
        end
      end

      click_button('T&C')
      click_button('Blue Back')

      click_button('Visit Website')
      wait_for(:timeout => 30){element_exists("UIImageView id:'ic_refresh'")}
      click_button('Blue Back')

      click_button('Back')
      
      wait_for(:timeout => 30, :post_timeout => 1) {element_exists("WAMColleagueOfferCell")}
      scroll('scrollView', :down)
    end
  end
end