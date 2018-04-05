# -*- encoding : utf-8 -*-
class ArchOffersPage
  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new

    @BTN_INSTORE = @BROWSER.a(:text, 'In-store')
    @BTN_COLLEAGUE = @BROWSER.a(:text, 'Colleague')
    @BTN_CREATE_NEW = @BROWSER.a(:text, 'Create New')
    @BTN_UPDATE = @BROWSER.button(:text, 'Update')
    @BTN_SAVE = @BROWSER.button(:text, 'Save')
  end

  def is_visible (page)
    case page
    when 'Main'
      @BTN_INSTORE
      @BTN_COLLEAGUE 
      @BTN_CREATE_NEW
      @BTN_UPDATE
      @BROWSER.table(:class, %w(table table-striped table-hover table-with-header)).wait_until_present
      @BROWSER.tr(:text, /Title Networks Dates Action/).wait_until_present
    when 'Create New'
      @BROWSER.select(:name, 'country').wait_until_present
      @BROWSER.input(:name, 'retailer_name').wait_until_present
      @BROWSER.input(:id, 'start-date').wait_until_present
      @BROWSER.input(:id, 'expiry-date').wait_until_present
      @BROWSER.input(:name, 'url').wait_until_present
      @BROWSER.input(:name, /translations/).wait_until_present
      @BTN_SAVE.wait_until_present
    end
  end
  def click_button (button)
    case button
    when 'Update'
      @BTN_UPDATE.wait_until_present
      Watir::Wait.until { @BTN_UPDATE.enabled? }
      @BTN_UPDATE.click
      Watir::Wait.until { @BTN_UPDATE.disabled? }
      is_visible('Main')
    when 'Create New'
      @BTN_CREATE_NEW.wait_until_present
      @BTN_CREATE_NEW.click
      is_visible('Create New')
    when 'In-store'
      @BTN_INSTORE.wait_until_present
      @BTN_INSTORE.click
      is_visible('Main')
    when 'Colleague'
      @BTN_COLLEAGUE = @BROWSER.a(:text, 'Colleague')
      @BTN_COLLEAGUE.wait_until_present
      @BTN_COLLEAGUE.click
      is_visible('Main')
    when 'Save'
      @BTN_SAVE.wait_until_present
      @BTN_SAVE.click
      @BROWSER.li(:text, 'Offer created successfully.').wait_until_present
      is_visible('Main')
    end
  end

  def set_country_filter (country)
    @BROWSER.select_list(:name, 'country').wait_until_present
    @BROWSER.select_list(:name, 'country').select country
    click_button('Update')
  end

  # @param company_name_id
  # @param add_all
  def create_offer (offer_type, company_name_id = nil, add_all = true)
    click_button('Create New')
    is_visible('Create New')

    if COMPANY_PROFILE[:profile_1][:country].include? 'United Kingdom'
      country = 'United Kingdom'
      language = 'English (UK)'
    elsif COMPANY_PROFILE[:profile_1][:country].include? 'United States'
      country = 'United States'
      language = 'English (USA)'
    elsif COMPANY_PROFILE[:profile_1][:country].include? 'Canada'
      country = 'Canada'
      language = 'French (CA)'
    end 

    @OFFER_NAME = "#{country} #{Time.now.strftime("%d-%m-%Y %H_%M_%S")}"
    
    @BROWSER.select(:name, 'country').select country
    @BROWSER.input(:name, 'retailer_name').send_keys @OFFER_NAME
    @BROWSER.input(:id, 'start-date').send_keys start_date = Time.now.strftime("%d/%m/%Y")
    @BROWSER.input(:id, 'expiry-date').send_keys expiry_date = (Time.now. + 86400).strftime("%d/%m/%Y")
    @BROWSER.input(:id, 'expiry-label').send_keys expiry_date = (Time.now. + 86400).strftime("%d/%m/%Y")
    @BROWSER.input(:name, 'url').send_keys url = 'http://www.lifeworks.com'
    @BROWSER.input(:name, 'bar_code').send_keys bar_code = '5016196048547'
    @BROWSER.input(:name, 'code').send_keys code = rand(10000..900000)

    for i in 0..(@BROWSER.labels(:class, 'locale').count - 1)
      language = @BROWSER.label(:class => 'locale', :index => i).text
      puts "language = #{language}"
      @BROWSER.span(:class => 'caption', :text => language).fire_event('click')
      sleep 1
      @BROWSER.input(:name => /title/, :index => i).send_keys @OFFER_NAME
      @BROWSER.label(:text => 'Offer Summary', :index => i).parent.div(:class, /ql-editor/).click
      @BROWSER.label(:text => 'Offer Summary', :index => i).parent.div(:class, /ql-editor/).send_keys "Offer Summary #{language}"
      @BROWSER.label(:text => 'Merchant Description', :index => i).parent.div(:class, /ql-editor/).click
      @BROWSER.label(:text => 'Merchant Description', :index => i).parent.div(:class, /ql-editor/).send_keys "Merchant Description #{language}"
      @BROWSER.input(:name => /discount/, :index => i).click
      @BROWSER.input(:name => /discount/, :index => i).send_keys "Discount #{language}"
      @BROWSER.label(:text => 'Offer Terms & Conditions', :index => i).parent.div(:class, /ql-editor/).click
      @BROWSER.label(:text => 'Offer Terms & Conditions', :index => i).parent.div(:class, /ql-editor/).send_keys "Terms and Conditions #{language}"
      @BROWSER.label(:text => 'Barcode Redemption Instructions', :index => i).parent.div(:class, /ql-editor/).click
      @BROWSER.label(:text => 'Barcode Redemption Instructions', :index => i).parent.div(:class, /ql-editor/).send_keys "Barcode Redemption Instructions #{language}"
      @BROWSER.label(:text => 'Online Code Redemption Instructions', :index => i).parent.div(:class, /ql-editor/).click
      @BROWSER.label(:text => 'Online Code Redemption Instructions', :index => i).parent.div(:class, /ql-editor/).send_keys "Barcode Redemption Instructions #{language}"
    end

    @BROWSER.file_field(:index, 0).set eval(IMAGE_FILES[:offers][:png])
    @BROWSER.file_field(:index, 1).set eval(IMAGE_FILES[:offers][:png])
    
    if add_all
      @BROWSER.input(:name => 'company_all', :index => 0).click
      @BROWSER.input(:name => 'company_all', :index => 0, :checked => 'checked').wait_until_present
    else
      @BROWSER.input(:name => 'company_all', :index => 1).click
      @BROWSER.input(:name => 'company_all', :index => 1, :checked => 'checked').wait_until_present
      @BROWSER.span(:class, %w(select2 select2-container select2-container--default select2-container--focus)).send_keys company_name_id
      @BROWSER.element(:text, company_name_id).click
    end

    click_button('Save')

    go_to_last_offer(country, offer_type)
    validate_offer(country,@OFFER_NAME,start_date,expiry_date,url,bar_code,code.to_s,add_all)
  end

  def go_to_last_offer (country, offer_type)
    @BROWSER.ul(:class, %w(nav nav-pills nav-stacked)).li(:text, 'Offers').click
    @BROWSER.ul(:class, 'pagination').wait_until_present
    click_button(offer_type.gsub(' Offers', '').gsub('Exclusive', 'Colleague'))
    set_country_filter(country)
    @BROWSER.a(:text => 'last').click
    @BROWSER.li(:class => 'disabled', :text => 'last').wait_until_present
    sleep 2
    index_of_the_latest_offer_in_list = (@BROWSER.tbody.trs.count - 1)
    @BROWSER.a(:text => 'Edit', :index => index_of_the_latest_offer_in_list).click
    @BROWSER.h2(:text, /Edit/).wait_until_present
  end

  def validate_offer (country, offer_name, start_date, expiry_date, url, bar_code, code, add_all)
    @BROWSER.h2(:text, /Edit/).wait_until_present

    if @BROWSER.select(:name, 'country').option(:selected, 'selected').text != country
      fail(msg = "Error. validate_offer.")
    end

    if @BROWSER.input(:name, 'retailer_name').value != offer_name
      fail(msg = "Error. validate_offer.")
    end
    
    if @BROWSER.input(:id, 'start-date').value != start_date
      fail(msg = "Error. validate_offer.")
    end 
    
    if @BROWSER.input(:id, 'expiry-date').value != expiry_date
      fail(msg = "Error. validate_offer.")
    end

    if @BROWSER.input(:id, 'expiry-label').value != expiry_date
      fail(msg = "Error. validate_offer.")  
    end

    if @BROWSER.input(:name, 'url').value != url
      fail(msg = "Error. validate_offer.")
    end

    if @BROWSER.input(:name, 'bar_code').value != bar_code
      fail(msg = "Error. validate_offer.")
    end

    if @BROWSER.input(:name, 'code').value != code
      fail(msg = "Error. validate_offer.")
    end
    
    if add_all
      if !@BROWSER.input(:name => 'company_all', :index => 0).checked?
        fail(msg = "Error. validate_offer.")
      end
    else
      if !(@BROWSER.li(:class, 'select2-selection__choice').text.include? company_name_id)
        fail(msg = "Error. validate_offer.")
      end
    end
  end

  def return_or_amend_variable (variable_name, new_variable_value = nil)
    if variable_name == 'Offer Name'
      new_variable_value == nil ? (return @OFFER_NAME) : @OFFER_NAME = new_variable_value
    end
  end

end