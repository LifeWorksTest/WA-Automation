# -*- encoding : utf-8 -*-
class HermesInstoreColleagueOffersPage

	def initialize (browser)
	    @BROWSER = browser
      @file_service = FileService.new
      @ARCH_OFFERS_PAGE = ArchOffersPage.new @BROWSER
      
      @BTN_VIEW_WEBSITE = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).button(:text, HERMES_STRINGS["offers"]["visit_website"])
	end

	def is_visible(instore_colleague_offer)
		if instore_colleague_offer == 'In-Store Offers'
			@BROWSER.div(:class => 'title-velocity-hook', :text => /#{HERMES_STRINGS["offers"]["title_1"]}/).wait_until_present
      @BROWSER.div(:id => 'view', :text => /#{HERMES_STRINGS["offers"]["title_1"]}/).wait_until_present
		elsif instore_colleague_offer == 'Exclusive Offers'
      @BROWSER.div(:class => 'title-velocity-hook', :text => /#{HERMES_STRINGS["offers"]["title_2"]}/).wait_until_present
      @BROWSER.div(:id => 'view', :text => /#{HERMES_STRINGS["offers"]["title_2"]}/).wait_until_present
    end
	end

  def click_button (button)
    case button
    when 'View Website'
      @BTN_VIEW_WEBSITE.wait_until_present
      @BTN_VIEW_WEBSITE.fire_event('click')
      Watir::Wait.until { @BROWSER.windows.count == 2 }
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end
	
	#Validate offers data
	def validate_offers_data (amount_of_offers_to_validate)
    @HELPER_METHODS_PAGE = HermesHelperMethodsPage.new @BROWSER
    offers_validated = 0
    i = 0

    while (offers_validated < amount_of_offers_to_validate)
      puts "Offers Validated = #{offers_validated}"

      @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).wait_until_present

      offer_name = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).parent.parent.div(:index, 9).text
      merchant_name = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).parent.parent.div(:index, 10).text.gsub(/\s-\s.*/,'')
      
      offer_description = ''

      if @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).parent.parent.div(:index, 10).span.present?
        offer_description = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).parent.parent.div(:index, 10).span.text.gsub(/.*\s-\s/, '')
      end

      offer_type = @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).parent.parent.div(:index, 13).text
      offer_expiry_date = (/\d+\/\d+\/\d+/.match (@BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => offers_validated).parent.parent.div(:index, 14).text)).to_s

      open_offer(offers_validated)

      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, offer_name).wait_until_present
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, /\w+ \d+\/\d+\/\d+ \w+ #{offer_expiry_date}/).wait_until_present
      
      if offer_description != ''
        @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).span(:text, /#{offer_description}/).wait_until_present
      end

      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, /#{merchant_name}/).wait_until_present
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).button(:text, HERMES_STRINGS["offers"]["visit_website"]).wait_until_present

      if @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, /#{offer_type}/).present?
        @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text => HERMES_STRINGS["offers"]["claim"], :index => 0).parent.div(:index => 1, :text => /(\d+|\w+)/).wait_until_present
        @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text => HERMES_STRINGS["offers"]["claim"], :index => 2).parent.img(:src, /benefit-colleague-offer-redemption/).present?
      end

      read_more_links = [merchant_name, HERMES_STRINGS["offers"]["tcs"]]

      read_more_links.each do |read_more_link|
      
        if (@BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, read_more_link).present?) && (@BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, read_more_link).parent.a(:text, HERMES_STRINGS["global"]["read_more"]).present?)
          pre_expanded_descrioption = @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, read_more_link).parent.span.text.length
          @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, read_more_link).parent.a(:text, HERMES_STRINGS["global"]["read_more"]).click
          Watir::Wait.until { @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, read_more_link).parent.span.text.length > pre_expanded_descrioption }
        end
      end

      ##### Work in progress - Need to get the date comparison to work with us and UK date formats
      if ACCOUNT[:account_1][:valid_account][:country_code] == 'gb'
        
        if Date.parse(offer_expiry_date) < Date.today
          fail(msg = "Error. validate_offers_data. The expiry (#{offer_expiry_date}) date is no longer valid.")
        end
      end

      # Verify redirection to external website
      click_button('View Website')
      @HELPER_METHODS_PAGE.verify_external_redirection

      # Close Modal window
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).i(:class, 'icon-web_close').wait_until_present
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).i(:class, 'icon-web_close').click
      @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).i(:class, 'icon-web_close').wait_while_present
      offers_validated += 1
    end
	end

  # Opens an offer according to index passed to method or if index is nil, opens a random offer or newly created offer in Arch 
  # @param index
  def open_offer (index = nil)
    # If offer_name is not nil (eg - An offer has just been created in Arch), then we search each page until we find the offer name
    # Only the last page of offer is searched on as new offers should be displayed last

    if @ARCH_OFFERS_PAGE.return_or_amend_variable('Offer Name') != nil
      offer_name = @ARCH_OFFERS_PAGE.return_or_amend_variable
      puts "Offer to open = #{offer_name}"
      index = @BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count - 1

      if @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 9).text.include? offer_name
        puts "The newly created offer '#{offer_name}' is  the last offer in the offer list"
      elsif i == offers_on_page
        fail(msg = "Error. open_offer. The newly created offer '#{offer_name}' is not the last offer in the offer list.")
      end

    # Random offer is opened on the 1st page of offers if no index is sent to method and the ext file offer_name value is empty
    elsif (index == nil)
      index = rand(@BROWSER.divs(:class, %w(white-flag-icon white-flag-icon__box)).count - 1)
    end

    # Once the index has been obtained, the code below clicks on the offer with the specified index and waits until the modal window is opened
    @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).wait_until_present
    @BROWSER.div(:class => %w(white-flag-icon white-flag-icon__box), :index => index).parent.parent.div(:index, 9).click
    @BROWSER.div(:class, %w(ReactModal__Content ReactModal__Content--after-open)).div(:text, HERMES_STRINGS["offers"]["get"]).wait_until_present
  end
end