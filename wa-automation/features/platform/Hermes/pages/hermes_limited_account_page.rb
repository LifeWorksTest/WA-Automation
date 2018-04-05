class HermesLimitedAccountPage
  
	def initialize (browser)
    @BROWSER = browser
    
    @LBL_IMPROVE_WELLBEING = @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["wellness_feature"]["title"])
    @LBL_LIVE_CHAT_FEATURE =  @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["chat_feature"]["title"])
    @LBL_ZENDESK_FEATURE = @BROWSER.div(:text, 'Support Requests and FAQs')
    @LBL_WELLNESS_TOOLS = @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["cerner_feature"]["title"])
    @LBL_GIFTCARDS = @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["gift_cards_feature"]["title"])
    @LBL_CINEMA_TICKETS = @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["cinemas_feature"]["title"])
    @LBL_EXCLUSIVE_OFFERS = @BROWSER.div(:text, HERMES_STRINGS["limited_account"]["exclusive_offers_feature"]["title"])

    @BTN_ALREADY_HAVE_ACCOUNT = @BROWSER.a(:text, HERMES_STRINGS["limited_account"]["action_banner"]["already_have_account"])
    @BTN_CREATE_YOUR_ACCOUNT = @BROWSER.button(:text, HERMES_STRINGS["limited_account"]["action_banner"]["create_your_account"])
    @BTN_SKIP = @BROWSER.div(:id, 'skip-button')
    @BTN_SKIP_CONFIRM = @BROWSER.a(:text, HERMES_STRINGS["limited_account"]["skip"]["skip"].upcase)
  end

  def is_visible (page)
  	case page
  	when 'main'
    	Watir::Wait.until {@BROWSER.url.include? 'limited-account'}
    	@BTN_ALREADY_HAVE_ACCOUNT.wait_until_present
    	@BTN_CREATE_YOUR_ACCOUNT.wait_until_present
      @BTN_SKIP.wait_until_present 
      @LBL_ZENDESK_FEATURE.wait_until_present

     ($USER_FEATURE_LIST['eap_cerner']) && (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_US') ? @LBL_WELLNESS_TOOLS.wait_until_present : Watir::Wait.until { !@LBL_WELLNESS_TOOLS.present? }
     ($USER_FEATURE_LIST['benefit_cinema']) && (ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Web_UK') ? @LBL_CINEMA_TICKETS.wait_until_present : Watir::Wait.until { !@LBL_CINEMA_TICKETS.present? }
      $USER_FEATURE_LIST['eap_wellness'] ? @LBL_IMPROVE_WELLBEING.wait_until_present : Watir::Wait.until { !@LBL_IMPROVE_WELLBEING.present? }
      $USER_FEATURE_LIST['eap_chat'] ? @LBL_LIVE_CHAT_FEATURE.wait_until_present : Watir::Wait.until { !@LBL_LIVE_CHAT_FEATURE.present? }
      $USER_FEATURE_LIST['benefit_global_gift_cards'] > 0 ? (@LBL_GIFTCARDS.wait_until_present) : Watir::Wait.until { !@LBL_GIFTCARDS.present? }
      $USER_FEATURE_LIST['benefit_colleague_offer'] ? @LBL_EXCLUSIVE_OFFERS.wait_until_present : atir::Wait.until { !@LBL_EXCLUSIVE_OFFERS.present? }

  	when 'Confirm Skip'
  		@BTN_SKIP_CONFIRM.wait_until_present
 	  end
  end   
  
  def click_button (button)
  	case button
  	when 'Skip'
  		@BTN_SKIP.wait_until_present
  		@BTN_SKIP.click
  		is_visible('Confirm Skip')
  	when 'Confirm Skip'
  		@BTN_SKIP_CONFIRM.wait_until_present
  		@BTN_SKIP_CONFIRM.click
  		@BTN_SKIP_CONFIRM.wait_while_present
  		@BROWSER.div(:id, 'feed').wait_until_present
    when 'Create your account'
      @BTN_CREATE_YOUR_ACCOUNT.wait_until_present
      @BTN_CREATE_YOUR_ACCOUNT.click
      @BROWSER.div(:text, 'These features require a personal account').wait_until_present
  	end
	end

  # skips the limited account page which then navigates user to the newsfeed page.
  def skip_limited_account_page
    click_button('Skip')
    click_button('Confirm Skip')
  end
end