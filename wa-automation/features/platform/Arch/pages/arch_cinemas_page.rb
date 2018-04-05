class ArchCinemasPage

  def initialize (browser)
    @BROWSER = browser
    @file_service = FileService.new
    
    @LBL_UPLOAD_DISCOUNT_CODE_STOCK = @BROWSER.div(:text, 'Upload Discount Code Stock')
    @LBL_CINEMA_BRANCH_NAME = @BROWSER.label(:text, 'Cinema branch name*')
    @LBL_MERCHANT_DESCRIPTION = @BROWSER.textarea(:name, 'description')
    @LBL_ABOUT_THIS_OFFER = @BROWSER.label(:text, 'About this offer*')
    @LBL_HOW_TO_REDEEM = @BROWSER.label(:text, 'How to redeem*')
    @LBL_IMPORTANT_THINGS_TO_KNOW = @BROWSER.label(:text, 'Important things to know*')
    @LBL_TERMS_AND_CONDITIONS = @BROWSER.div(:id, 'quill-editor-quill-details-terms_and_conditions-description-body').div(:class, 'ql-line')
    @LBL_CONFIRMATION = @BROWSER.div(:text, /Are you sure you want to delete this?/)
    @LBL_CREATE_NEW_TICKET_TYPE = @BROWSER.label(:text, 'Create a new Ticket Type')
    @LBL_TICKET_TYPE_NAME = @BROWSER.label(:text, 'Name*')
    @LBL_TICKET_TYPE_SKU = @BROWSER.label(:text, 'Sku')
    @LBL_TICKET_TYPE_DESCRIPTION = @BROWSER.textarea(:name, 'description')
    @LBL_TICKET_TYPE_PRICE_TIER_1 = @BROWSER.label(:text, 'Price tier 1*')
    @LBL_TICKET_TYPE_PRICE_TIER_2 = @BROWSER.label(:text, 'Price tier 2*')
    @LBL_TICKET_TYPE_RETAIL_PRICE = @BROWSER.label(:text, 'Retail price*')
    @LBL_CINEMA_LOCATION_NAME = @BROWSER.label(:text, 'Name*')
    @LBL_CINEMA_LOCATION_ADDRESS = @BROWSER.textarea(:name, 'address')
    @LBL_CINEMA_LOCATION_POSTCODE = @BROWSER.label(:text, 'Postcode*')
    @LBL_EDIT_MERCHANT = @BROWSER.h2(:text, 'Edit a merchant')
    @LBL_MERCHANT_SETTINGS = @BROWSER.ul(:class, %w(nav nav-tabs)).li.a(:text, 'Merchant Settings')
    @LBL_CINEMA_LOCATIONS = @BROWSER.a(:text, 'Cinema Locations')
    @LBL_TICKET_TYPES = @BROWSER.a(:text, 'Ticket Type(s)')
    @LBL_CODE_STOCK = @BROWSER.a(:text, 'Code Stock')
    @LBL_CODE_EXPIRED = @BROWSER.a(:text, 'Code Expired')

    @BTN_CREATE_NEW = @BROWSER.a(:text, 'Create New')
    @BTN_SETTINGS = @BROWSER.a(:text, 'Settings')
    @BTN_TRANSACTIONS = @BROWSER.a(:text, 'Transactions')
    @BTN_MERCHANT = @BROWSER.a(:text, 'Merchant')
    @BTN_CREATE_CINEMA_LOCATION = @BROWSER.label(:text, 'Create a new cinema location')
    @BTN_DELETE = @BROWSER.button(:value, 'Delete')
    @BTN_CANCEL = @BROWSER.button(:value, 'Cancel')
    @BTN_UPLOAD_CSV = @BROWSER.label(:text, 'Upload a new set of cinema ticket codes')
    @BTN_UPLOAD = @BROWSER.button(:text, 'Upload')
    @BTN_SAVE = @BROWSER.button(:text, 'Save')

    @TXT_LOCATION_NAME = @BROWSER.a(:text, 'Name')
    @TXT_LOCATION_ADDRESS = @BROWSER.a(:text, 'Address')
    @TXT_LOCATION_POSTCODE = @BROWSER.a(:text, 'Postcode')
    @TXT_LOCATION_PRICEBAND = @BROWSER.a(:text, 'Price Band')
    @TXT_LOCATION_ACTION = @BROWSER.th(:text, 'Action')

    @SLCT_COUNTRY = @BROWSER.select_list(:name, 'country_code')
    @SLCT_PRICE_BAND = @BROWSER.select_list(:name, 'price_band')
  end

  def click_button(button)
    case button
    when 'Merchant'
      @BTN_MERCHANT.wait_until_present
      @BTN_MERCHANT.click
      is_visible('Merchant')
    when 'Create a new Cinema'
      @BROWSER.a(:text, 'Create New').wait_until_present
      @BROWSER.a(:text, 'Create New').click
      # @BTN_CREATE_NEW.wait_until_present
      # @BTN_CREATE_NEW.click
      is_visible('Create a new Cinema')
    when 'Cinema Locations'
      @LBL_CINEMA_LOCATIONS.wait_until_present
      @LBL_CINEMA_LOCATIONS.click
      is_visible('Cinema Locations')
    when 'Create a new location'
      @BTN_CREATE_CINEMA_LOCATION.parent.a(:text, 'Create New').wait_until_present
      @BTN_CREATE_CINEMA_LOCATION.parent.a(:text, 'Create New').click
      is_visible('Create a new location')
    when 'ticket-type'
      @BROWSER.a(:text, 'Ticket Type(s)').wait_until_present
      @BROWSER.a(:text, 'Ticket Type(s)').click
      # @LBL_TICKET_TYPES.wait_until_present
      # @LBL_TICKET_TYPES.click
      is_visible('ticket-type')
    when 'Create a new ticket type'
      @LBL_CREATE_NEW_TICKET_TYPE.parent.a(:text, 'Create New').wait_until_present
      @LBL_CREATE_NEW_TICKET_TYPE.parent.a(:text, 'Create New').click
      is_visible('Create a new ticket type')
    when 'Code Stock'
      @LBL_CODE_STOCK.wait_until_present
      @LBL_CODE_STOCK.click
      is_visible('Code Stock')
    when 'Upload CSV'
      @BTN_UPLOAD_CSV.parent.a(:text, /Upload CSV/).click
      is_visible('Upload CSV')
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  def is_visible (page)
    case page
    when 'Main'
      @BTN_TRANSACTIONS.wait_until_present
      @BTN_MERCHANT.wait_until_present
      @BTN_SETTINGS.wait_until_present
    when 'Merchant'
      @BROWSER.a(:text, 'Create New').wait_until_present
    when 'Create a new Cinema'
      @LBL_CINEMA_BRANCH_NAME.wait_until_present
      @LBL_CINEMA_BRANCH_NAME.parent.text_field.wait_until_present
      @SLCT_COUNTRY.wait_until_present
      @LBL_MERCHANT_DESCRIPTION.wait_until_present
      @LBL_ABOUT_THIS_OFFER.wait_until_present
      @LBL_ABOUT_THIS_OFFER.parent.div(:id, 'ql-editor-1').wait_until_present
      @LBL_HOW_TO_REDEEM.wait_until_present
      @LBL_HOW_TO_REDEEM.parent.div(:id, 'ql-editor-2').wait_until_present
      @LBL_IMPORTANT_THINGS_TO_KNOW.wait_until_present
      @LBL_IMPORTANT_THINGS_TO_KNOW.parent.div(:id, 'quill-editor-quill-details-things_to_know-description-body').div.wait_until_present
      @LBL_TERMS_AND_CONDITIONS.wait_until_present
      @BTN_SAVE.wait_until_present
    when 'Delete Cinema'
      @BROWSER.h2(:text, /Delete: #{CINEMAS[:"#{@CINEMA_NAME}"][:name]}?/).wait_until_present
      @LBL_CONFIRMATION.wait_until_present
      @BROWSER.div(:text, /Name: #{CINEMAS[:"#{@CINEMA_NAME}"][:name]}/).wait_until_present
      @BTN_DELETE.wait_until_present
      @BTN_CANCEL.wait_until_present
    when 'Delete ticket type'
      @BROWSER.h2(:text, /Delete:/).wait_until_present
      @LBL_CONFIRMATION.wait_until_present      
      @BROWSER.div(:text, /Name:/).wait_until_present
      @BTN_DELETE.wait_until_present
      @BTN_CANCEL.wait_until_present
    when 'Cinema Locations'
      @BTN_CREATE_CINEMA_LOCATION.parent.wait_until_present
      @BTN_CREATE_CINEMA_LOCATION.parent.a(:text, 'Create New').wait_until_present
      @TXT_LOCATION_NAME.wait_until_present
      @TXT_LOCATION_ADDRESS.wait_until_present
      @TXT_LOCATION_POSTCODE.wait_until_present
      @TXT_LOCATION_PRICEBAND.wait_until_present
      @TXT_LOCATION_ACTION.wait_until_present
    when 'Create a new location'
      @LBL_CINEMA_LOCATION_NAME.parent.text_field.wait_until_present
      @LBL_CINEMA_LOCATION_ADDRESS.wait_until_present
      @LBL_CINEMA_LOCATION_POSTCODE.parent.text_field.wait_until_present
      @SLCT_PRICE_BAND.wait_until_present
      @BROWSER.button(:text, 'Save').wait_until_present
    when 'Create a new ticket type'
      @LBL_TICKET_TYPE_NAME.wait_until_present
      @LBL_TICKET_TYPE_NAME.parent.text_field.wait_until_present
      @LBL_TICKET_TYPE_SKU.wait_until_present
      @LBL_TICKET_TYPE_SKU.parent.text_field.wait_until_present
      @LBL_TICKET_TYPE_DESCRIPTION.wait_until_present
      @LBL_TICKET_TYPE_PRICE_TIER_1.wait_until_present
      @LBL_TICKET_TYPE_PRICE_TIER_1.parent.text_field.wait_until_present
      @LBL_TICKET_TYPE_PRICE_TIER_2.wait_until_present
      @LBL_TICKET_TYPE_PRICE_TIER_2.parent.text_field.wait_until_present
      @LBL_TICKET_TYPE_RETAIL_PRICE.wait_until_present
      @LBL_TICKET_TYPE_RETAIL_PRICE.parent.text_field.wait_until_present
      @SLCT_PRICE_BAND.wait_until_present
      @BROWSER.button(:text, 'Save').wait_until_present
    when 'Edit Cinema'
      @BROWSER.h2(:text, 'Edit a merchant').wait_until_present
      @BROWSER.ul(:class, %w(nav nav-tabs)).li.a(:text, 'Merchant Settings').wait_until_present
      @BROWSER.a(:text, 'Cinema Locations')
      @BROWSER.a(:text, 'Ticket Type(s)').wait_until_present
      @BROWSER.a(:text, 'Code Stock').wait_until_present
      @BROWSER.a(:text, 'Code Expired').wait_until_present
      # @LBL_EDIT_MERCHANT.wait_until_present
      # @LBL_MERCHANT_SETTINGS.wait_until_present
      # @LBL_CINEMA_LOCATIONS.wait_until_present
      # @LBL_TICKET_TYPES.wait_until_present
      # @LBL_CODE_STOCK.wait_until_present
      # @LBL_CODE_EXPIRED.wait_until_present
    when 'ticket-type'
      @BROWSER.label(:text, 'Create a new Ticket Type').wait_until_present
      @BROWSER.label(:text, 'Create a new Ticket Type').parent.a(:text, 'Create New').wait_until_present
      # @LBL_CREATE_NEW_TICKET_TYPE.wait_until_present
      # @LBL_CREATE_NEW_TICKET_TYPE.parent.a(:text, 'Create New').wait_until_present
    when 'Code Stock'
      @BTN_UPLOAD_CSV.wait_until_present
    when 'Upload CSV'
      @LBL_UPLOAD_DISCOUNT_CODE_STOCK.wait_until_present
      @BTN_UPLOAD.wait_until_present
    else
      fail(msg = "Error. is_visible. The option #{page} is not defined in menu.")
    end
  end

  # Selects a chosen, existing cinema from the cinema 'merchant' screen in Arch and either clicks its edit (default) or delete button.
  # @param cinema_name
  # @param edit_or_delete 
  def edit_or_delete_cinema (cinema_name, edit_or_delete = 'Edit')
    @CINEMA_NAME = @file_service.get_from_file("cinema_name:")[0..-2]

    @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:name]}/).div.a(:text, "#{edit_or_delete}").wait_until_present
    @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:name]}/).div.a(:text, "#{edit_or_delete}").click
    is_visible("#{edit_or_delete} Cinema")

    if edit_or_delete == 'Delete'
      @BTN_DELETE.click
      @BROWSER.li(:text, 'Merchant deleted successfully.').wait_until_present
    end
  end

  # deletes one or more ticket type using an array
  # @param ticket_types
  def delete_ticket_types (ticket_types)
    click_button('Merchant')
    edit_or_delete_cinema(@CINEMA_NAME)
    click_button('ticket-type')

    ticket_types.split(',').each do |ticket_type|
      if @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}/).present?
        @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}/).div.a(:text, 'Delete').wait_until_present
        @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}/).div.a(:text, 'Delete').click
        is_visible('Delete ticket type')
        @BTN_DELETE.click
        @BROWSER.li(:text, 'Ticket type deleted successfully.').wait_until_present
      end
    end

  end

  # Creates a csv of ticket stock with unique codes for the upload_cinema_stock_csv method
  # @param ticket_type
  # @param ticket_quantity
  def create_csv_file_for_ticket_upload (ticket_type, ticket_quantity)
    file = File.new("cinema_#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}.csv", 'w+')
    file.puts('provider_ticket_type,lifeworks_ticket_type,expiry_date,expiry_time,time_zone,code,external_id')
    
    for i in 1..ticket_quantity.to_i
      cinema_name = "#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}:"
      provider_ticket_type = "#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}"
      ticket_type_code = @file_service.get_from_file("#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}:")
      ticket_sku = "#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:sku]}#{$UNIQUE_SKU_IDENTIFIER}"
      @file_service.insert_to_file(cinema_name, "#{sprintf '%04d', ticket_type_code.chomp.to_i + 1}")
      ticket_code = "#{EMAILS[:your_lifeWorks_cinema_discount_codes][:ticket_code_init]}#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:ticket_code]}_#{@file_service.get_from_file("#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}:").chomp}"
      expiry_date = (Time.now. + 20000000).strftime("%d/%m/%Y")

      line = "#{provider_ticket_type},#{ticket_sku},#{expiry_date},10:59:59,Europe/London,#{ticket_code},"
      file.puts(line)
    end

    file.close
    return file
  end

  # Calls the create_csv_file_for_ticket_upload method to create a csv upload file
  # @param ticket_type
  # @param ticket_quantity
  def upload_cinema_stock_csv (ticket_type, ticket_quantity)
    csv_file = create_csv_file_for_ticket_upload(ticket_type, ticket_quantity)

    click_button('Code Stock')
    click_button('Upload CSV')
    @BROWSER.file_field.set File.expand_path("cinema_#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}.csv")
    @BTN_UPLOAD.wait_until_present
    @BTN_UPLOAD.click
    @BROWSER.div(:class, %w(panel-body)).p(:text, "Successfully uploaded (#{ticket_quantity}) codes.").wait_until_present
    click_button('Code Stock')

    # Verifies that the amount of stock uploaded is equal to the number of rows of stock shown on the code stock page
    @BROWSER.tbody.tds(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}/).count == ticket_quantity
    File.delete(csv_file)
    click_button('ticket-type')
  end

  # Finds the latest transaction on the arch cinema transaction details search page and makes checks that the info displayed matches up with the the details of the latest order created
  def verify_cinema_transaction_order_details
    @CINEMA_ORDER_NUMBER = @file_service.get_from_file("cinema_order_number:")[0..-2]
    @TOTAL_CINEMA_BALANCE_TO_PAY = @file_service.get_from_file("cinema_total_to_pay:")[0..-2]

    # The latest transaction will always be last in the list of transactions. Therefore, the block below will keep paging until on the last page of tranasactions
    until @BROWSER.ul(:class, 'pagination').li(:text => '»', :class => 'disabled').present?
      @BROWSER.ul(:class, 'pagination').lis[-2].a.click
      @BROWSER.ul(:class, 'pagination').wait_until_present
    end

    # Checks made on the transaction details displayed on the tranasaction search page
    @BROWSER.tbody.td(:text, @CINEMA_ORDER_NUMBER).wait_until_present
    @BROWSER.tbody.td(:text, ACCOUNT[:"#{$account_index}"][:valid_account][:email]).wait_until_present
    @BROWSER.tbody.td(:text, Time.now.strftime("%d/%m/%Y")).wait_until_present
    @BROWSER.tbody.td(:text, ACCOUNT[:"#{$account_index}"][:valid_account][:user_name]).wait_until_present
    @BROWSER.tbody.td(:text, "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{@TOTAL_CINEMA_BALANCE_TO_PAY}").wait_until_present

    # clicking on the order number will drill down in the transaction detail page
    # Checks made on the transaction details displayed on the tranasaction detail page
    @BROWSER.tbody.td(:text, @CINEMA_ORDER_NUMBER).wait_until_present
    @BROWSER.tbody.td(:text, @CINEMA_ORDER_NUMBER).a.click
    @BROWSER.tbody.td(:text, @CINEMA_ORDER_NUMBER).wait_while_present
    @BROWSER.h3(:text, "Order ID: ##{@CINEMA_ORDER_NUMBER}").wait_until_present
    @BROWSER.div(:class, %w(panel panel-default)).td(:text, "Customer: #{ACCOUNT[:"#{$account_index}"][:valid_account][:user_name]}").wait_until_present 
    @BROWSER.div(:class, %w(panel panel-default)).td(:text, "Company: #{ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]}").wait_until_present 
    @BROWSER.div(:class, %w(panel panel-default)).td(:text, "Recipient email: #{ACCOUNT[:"#{$account_index}"][:valid_account][:email]}").wait_until_present 
    @BROWSER.div(:class, %w(panel panel-default)).td(:text, "Date: #{Time.now.strftime("%d/%m/%Y")}").wait_until_present 
    @BROWSER.div(:class, %w(panel panel-default)).td(:text, "Total Price: #{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{@TOTAL_CINEMA_BALANCE_TO_PAY}").wait_until_present 

    # Adds up the value of all of the tickets displayed on the tranasaction details page so the total value can be matched with the total order price which was stored in a global variable earlier
    @BROWSER.tbody(:index, 1).trs.each do |ticket_price|
      @TICKET_PRICE_TOTAL = @TICKET_PRICE_TOTAL.to_f + (/\d+\.\d+/.match "#{ticket_price.tds.last.text}").to_s.to_f
    end

    if @TICKET_PRICE_TOTAL != @TOTAL_CINEMA_BALANCE_TO_PAY.to_f
      fail(msg = "Error. verify_cinema_transaction_order_details. Total value of individual transactions shown on Arch is #{@TICKET_PRICE_TOTAL}, but it should be #{@TOTAL_CINEMA_BALANCE_TO_PAY}")
    end
    
    # Uses the ticket codes that were contained in the confirmation email and checks that these match up with the codes displayed on the arch transaction details page for the latest order
    $returned_value_from_email.each do |ticket_code|
      if !@BROWSER.tbody(:index, 1).tr(:text, /\*+#{ticket_code.split(//).last(4).join}/).present?
        fail(msg = "Error. verify_cinema_transaction_order_details. #{ticket_code} should be displayed on the cinema transaction detail page")
      end
    end

  end

  # Creates a new cinema
  # @param cinema_name
  # @param ticket_types
  # @param cinema_locations
  def create_new_cinema (cinema_name, ticket_types, cinema_location)
    @file_service.insert_to_file('cinema_name:', "#{cinema_name}")
    @CINEMA_NAME = @file_service.get_from_file("cinema_name:")[0..-2]
    puts "cinema name is - #{@CINEMA_NAME}"

    # Deletes the test cinema and test ticket types (if the previous test failed and these were not already deleted)
    if @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:name]}/).present?
      delete_ticket_types(ticket_types)
      @BROWSER.span(:class, %w(glyphicon glyphicon-chevron-left)).wait_until_present
      @BROWSER.span(:class, %w(glyphicon glyphicon-chevron-left)).fire_event('click')
      edit_or_delete_cinema(@CINEMA_NAME,'Delete')
    end

    # Add the details of the new cinema
    click_button('Create a new Cinema')
    # @LBL_CINEMA_BRANCH_NAME.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:name]
    @BROWSER.input(:name, 'name').send_keys CINEMAS[:"#{@CINEMA_NAME}"][:name]
    @SLCT_COUNTRY.select CINEMAS[:"#{@CINEMA_NAME}"][:country]
    @LBL_MERCHANT_DESCRIPTION.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:merchant_description]
    @LBL_ABOUT_THIS_OFFER.parent.div(:id, 'ql-editor-1').click
    @LBL_ABOUT_THIS_OFFER.parent.div(:id, 'ql-editor-1').send_keys CINEMAS[:"#{@CINEMA_NAME}"][:about_this_offer_text]
    @LBL_HOW_TO_REDEEM.parent.div(:id, 'ql-editor-2').click
    @LBL_HOW_TO_REDEEM.parent.div(:id, 'ql-editor-2').send_keys CINEMAS[:"#{@CINEMA_NAME}"][:how_to_redeem_text]
    @LBL_IMPORTANT_THINGS_TO_KNOW.parent.div(:id, 'quill-editor-quill-details-things_to_know-description-body').div.click
    @LBL_IMPORTANT_THINGS_TO_KNOW.parent.div(:id, 'quill-editor-quill-details-things_to_know-description-body').div.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:important_things_to_know_text]
    @BROWSER.file_field(:index, 0).set eval(IMAGE_FILES[:cinema][:png])
    @BROWSER.file_field(:index, 1).set eval(IMAGE_FILES[:cinema][:png])
    @LBL_TERMS_AND_CONDITIONS.click
    sleep(1)
    @LBL_TERMS_AND_CONDITIONS.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:terms_and_conditions_text]
    sleep(1)
    @BTN_SAVE.click
    
    @BROWSER.li(:text, 'Merchant created successfully.').wait_until_present
    is_visible('Merchant')
    
    edit_or_delete_cinema(@CINEMA_NAME)

    # Add a location to the new cinema
    click_button('Cinema Locations')
    click_button('Create a new location')
    @LBL_CINEMA_LOCATION_NAME.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:name]
    @LBL_CINEMA_LOCATION_ADDRESS.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:address]
    @LBL_CINEMA_LOCATION_POSTCODE.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:postcode]
    @SLCT_PRICE_BAND.select CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:price_band]
    @BROWSER.button(:text, 'Save').click
    @BROWSER.li(:text, 'Location created successfully.').wait_until_present
    @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:locations][:"#{cinema_location}"][:name]}/).present?

    # Add x amount of ticket types
    click_button('ticket-type')
    $UNIQUE_SKU_IDENTIFIER = Time.now.strftime("%d_%m_%y_%H_%M")

    ticket_types.split(',').each do |ticket_type|
      click_button('Create a new ticket type')
      @LBL_TICKET_TYPE_NAME.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]
      @LBL_TICKET_TYPE_SKU.parent.text_field.send_keys "#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:sku]}#{$UNIQUE_SKU_IDENTIFIER}"
      @LBL_TICKET_TYPE_DESCRIPTION.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:description]
      @LBL_TICKET_TYPE_PRICE_TIER_1.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:tier_1_price]
      @LBL_TICKET_TYPE_PRICE_TIER_2.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:tier_2_price]
      @LBL_TICKET_TYPE_RETAIL_PRICE.parent.text_field.send_keys CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:retail_price]
      @SLCT_PRICE_BAND.select CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:price_band]
      @BROWSER.button(:text, 'Save').click
      @BROWSER.li(:text, 'Ticket type created successfully.').wait_until_present
      @BROWSER.tbody.tr(:text, /#{CINEMAS[:"#{@CINEMA_NAME}"][:ticket_types][:"#{ticket_type}"][:name]}/).present?
    end
  end
end
