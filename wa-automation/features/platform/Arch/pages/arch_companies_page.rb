# -*- encoding : utf-8 -*-
class ArchCompaniesPage
  def initialize (browser)
    @BROWSER = browser
    
    @BTN_CREATE_COMPANY = @BROWSER.div(:class, 'thumbnail').a(:class => %w(btn btn-primary), :text => 'Create Company')
    @TXF_SEARCH_FOR_COMPANIES = @BROWSER.form(:class, 'form').input(:class, 'form-control')
    @TABLE_HEADERS = @BROWSER.tr(:text, 'Company ▼ ▲ LifeWorks subdomain Account state Users (active/shared) Package Sign up date ▼ ▲')
    @BTN_CHANGE_TO_PERSONAL_ACCOUNT = @BROWSER.button(:name, 'change_to_personal_account_type')
  end

  def is_visible (page)
    case page
    when 'companies'
      @BROWSER.h2(:text, 'Companies').wait_until_present
      @BROWSER.h3(:text, 'Companies List').wait_until_present
      @BTN_CREATE_COMPANY.wait_until_present
      @TXF_SEARCH_FOR_COMPANIES.wait_until_present
      puts "table row = #{@BROWSER.tr.text}"
      @TABLE_HEADERS.wait_until_present
    when 'company'
      @BROWSER.div(:class => 'thumbnail', :index => 0, :text => /Number of users\nTotal Active: .*\n\nState overview\n\nActive\nAwaiting approval\nPending\nArchived\n.*\n.*\n.*\n.*\nNumber of deleted users: .*/).wait_until_present
    when 'Create Shared Account'
      @BROWSER.text_field(:name, 'login').wait_until_present
      @BROWSER.text_field(:name, 'password').wait_until_present
      @BROWSER.select_list(:name, 'country_code').wait_until_present
      @BROWSER.select_list(:name, 'locale').wait_until_present
    end
  end

  def click_button (button)
    case button
    when 'Overview'
      @BROWSER.a(:text => /Overview/).wait_until_present
      @BROWSER.a(:text => /Overview/).click
      @BROWSER.h4(:text, 'Number of users').wait_until_present
    when 'Details'
      @BROWSER.a(:class => /btn/, :text => /Details/).wait_until_present
      @BROWSER.a(:class => /btn/, :text => /Details/).click
      @BROWSER.tr(:text, /Company Name/).wait_until_present
    when 'Create Company'
      @BROWSER.a(:text, 'Create Company').wait_until_present
      @BROWSER.a(:text, 'Create Company').click
      @BROWSER.h2(:text, 'Create new company').wait_until_present
    when 'Badges'
      @BROWSER.a(:class => /btn/, :text => /Badges/).wait_until_present
      @BROWSER.a(:class => /btn/, :text => /Badges/).click
      @BROWSER.a(:text, 'Create new').wait_until_present
    when 'Save Dependant Account Limit'
      @BROWSER.td(:text, 'Dependant Accounts').parent.button(:type, 'submit').click
      @BROWSER.td(:text, 'Dependant Accounts').parent.text_field.wait_while_present
      @BROWSER.td(:text, 'Dependant Accounts').parent.button(:type, 'submit').wait_while_present
      @BROWSER.td(:text, 'Dependant Accounts').parent.button(:type, 'button').wait_while_present
    when 'Edit Dependant Account Limit'
      @BROWSER.a(:id, 'dependant_accounts_limit').wait_until_present
      @BROWSER.a(:id, 'dependant_accounts_limit').click
      @BROWSER.td(:text, 'Dependant Accounts').parent.text_field.wait_until_present
      @BROWSER.td(:text, 'Dependant Accounts').parent.button(:type, 'submit').wait_until_present
      @BROWSER.td(:text, 'Dependant Accounts').parent.button(:type, 'button').wait_until_present
    when 'Upload'
      @BROWSER.a(:class => /btn/, :text => /Upload/).wait_until_present
      @BROWSER.a(:class => /btn/, :text => /Upload/).click
      @BROWSER.h2(:text, 'Upload').wait_until_present
    when 'Submit CSV'
      @BROWSER.button(:text, 'Submit').wait_until_present
      @BROWSER.button(:text, 'Submit').click
      @BROWSER.h4(:text, 'There was no ARCH validation errors.').wait_until_present
      @BROWSER.h4(:text, 'There was no API errors during users upload action - users sent to API were added.').wait_until_present
    when 'Spot Rewarding'
      @BROWSER.button(:text, 'Benefits').wait_until_present
      @BROWSER.button(:text, 'Benefits').click
      @BROWSER.div(:class, %w(btn-group btn-group-justified)).a(:text, 'Spot Rewarding').wait_until_present
      @BROWSER.div(:class, %w(btn-group btn-group-justified)).a(:text, 'Spot Rewarding').click
    when 'Transactions'
      @BROWSER.div(:class, %w(col-xs-12 messages-container)).ul(:class, %w(nav nav-pills)).a(:text, 'Transactions').wait_until_present
      @BROWSER.div(:class, %w(col-xs-12 messages-container)).ul(:class, %w(nav nav-pills)).a(:text, 'Transactions').click
      @BROWSER.a(:text, 'Download as CSV').wait_until_present
    when 'Features'
      if !@BROWSER.div(:class => 'l1_feature_name').present?
        @BROWSER.div(:class, %w(btn-group btn-group-justified)).a(:text, 'Features').wait_until_present
        @BROWSER.div(:class, %w(btn-group btn-group-justified)).a(:text, 'Features').fire_event('click')
        @BROWSER.div(:class => 'l1_feature_name').wait_until_present
      end
    when 'Save'
      @BROWSER.button(:id => 'btn-submit', :text => 'Save').wait_until_present
      @BROWSER.button(:id => 'btn-submit', :text => 'Save').click
      sleep(5)
    when 'Users'
      @BROWSER.button(:class => /btn/, :text => /Users/).wait_until_present
      @BROWSER.button(:class => /btn/, :text => /Users/).click

      @BROWSER.a(:text, 'Users').wait_until_present
      @BROWSER.a(:text, 'Users').click
      @BROWSER.table(:id, 'user-list').wait_until_present
    when 'Shared Accounts'
      @BROWSER.button(:class => /btn/, :text => /Users/).wait_until_present
      @BROWSER.button(:class => /btn/, :text => /Users/).fire_event('click')
      @BROWSER.a(:text, 'Shared Accounts').wait_until_present
      @BROWSER.a(:text, 'Shared Accounts').fire_event('click')
      @BROWSER.a(:text, 'Create Shared Account').wait_until_present
    when 'Create Shared Account'
      @BROWSER.a(:text, 'Create Shared Account').click
      is_visible('Create Shared Account')
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Search for company
  # @param company_name 
  def search_for_company (company_name, exists_or_not = true)
    @TXF_SEARCH_FOR_COMPANIES.wait_until_present
    @TXF_SEARCH_FOR_COMPANIES.send_keys company_name

    @BROWSER.button(:id, 'submitbutton').wait_until_present
    @BROWSER.button(:id, 'submitbutton').click
    @BROWSER.div(:id, 'company-user-search-results-loader').wait_until_present
    @BROWSER.div(:id, 'company-user-search-results-loader').wait_while_present

    if exists_or_not
      validate_data_in_table(company_name)
    else
      @BROWSER.div(:id, 'content-container').p(:text, 'No results.').wait_until_present
      @BROWSER.div(:class => 'thumbnail', :text => /Showing items 1 to 0 of 0/).wait_until_present
    end
  end

  # validate that all companies data in the table are different from nil
  # @param company_name
  def validate_data_in_table (company_name)
    company_found = false
    @TABLE_HEADERS.wait_until_present
    number_of_results = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.trs.count    
    puts "number_of_results:#{number_of_results}"
    
    for i in 0..number_of_results - 1
      puts "I:#{i}"
      @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, i).td.wait_until_present
      Watir::Wait.until { @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, i).td.text.length > 1 }
      
      if @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, i).td.text == company_name
        puts "company name = #{company_name} -------- Company found = #{@BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, i).td.text}"

        for j in 0..5
          @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, i).td(:index, j).wait_until_present
            if @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, i).td(:index, j).text == nil
              fail(msg = "Error. validate_data_in_table. Empty cell was found for company name: #{company_name}, line:#{i} row:#{j}")
            end
        end
        i = number_of_results + 1  
      elsif (i == number_of_results - 1) && (company_found == false)
        fail(msg = 'Error. validate_data_in_table. Company not found after iterating through all search results')
      end
    end
  end

  # Open company form table by company name or location (row) in table
  # @param company_row_in_table
  # @param company_name
  def open_company_from_table (company_row_in_table = nil, company_name = nil)
    @company_details_from_table_array = Array.new(7)
    
    pagination_index = 1
    pagination_total_page = 0
    not_found_company_in_the_table = true
    
    while not_found_company_in_the_table
      if company_row_in_table != nil
        @company_details_from_table_array[0] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 0).text
        @company_details_from_table_array[1] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 1).text
        @company_details_from_table_array[2] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 2).text
        @company_details_from_table_array[3] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 3).text
        @company_details_from_table_array[4] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 4).text
        @company_details_from_table_array[5] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 5).text.delete(' UTC')

        @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.tr(:index, company_row_in_table).td(:index, 0).click
        @BROWSER.h2(:text, @company_details_from_table_array[0]).wait_until_present
        not_found_company_in_the_table = false
      elsif @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => company_name).exists?
        @company_details_from_table_array[0] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => "#{company_name}").parent.td(:index, 0).text
        @company_details_from_table_array[1] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => "#{company_name}").parent.td(:index, 1).text
        @company_details_from_table_array[2] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => "#{company_name}").parent.td(:index, 2).text
        @company_details_from_table_array[3] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => "#{company_name}").parent.td(:index, 3).text
        @company_details_from_table_array[4] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => "#{company_name}").parent.td(:index, 4).text
        @company_details_from_table_array[5] = @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td(:index => 0, :text => "#{company_name}").parent.td(:index, 5).text.delete(' UTC')
        
        not_found_company_in_the_table = false
        @BROWSER.table(:class, %w(table table-bordered table-hover)).tbody.td.a(:index => 0, :text => "#{company_name}").click
        @BROWSER.h2(:text, @company_details_from_table_array[0]).wait_until_present
      elsif @BROWSER.ul(:class, %w(pagination pagination-sm)).exists?
        pagination_total_page = @BROWSER.ul(:class, %w(pagination pagination-sm)).lis.count - 2
        pagination_index += 1
        @BROWSER.ul(:class, %w(pagination pagination-sm)).a(:text, "#{pagination_index}").wait_until_present
        @BROWSER.ul(:class, %w(pagination pagination-sm)).a(:text, "#{pagination_index}").click
        @BROWSER.table(:class, %w(table table-bordered table-hover)).wait_until_present
       
      else
        fail(msg = 'Error. open_company_from_table. Company was not found on Arch')
      end
    end

    is_visible('company')
  end

  # Validate company data
  def validate_company_data
    validate_details
  end

  # validate details
  def validate_details
    click_button('Details')
    company_name = (/[^\n]*/.match @company_details_from_table_array[0])[0]
    puts "@company_details_from_table_array:#{@company_details_from_table_array}"
    @BROWSER.tr(:text, "Company Name #{company_name}").wait_until_present
    @BROWSER.tr(:text, "Account state #{(@company_details_from_table_array[2])[1..-1]}").wait_until_present
    @BROWSER.tr(:text, /WAM Network Creation Date #{(@company_details_from_table_array[5])}/).wait_until_present
    @BROWSER.table(:index, 1).tr(:text, /WAM Network Creation Date #{@company_details_from_table_array[5]}/).text
  end

  # Disabled or enabled company features
  def disabled_enabled_company_features (row, feature_name, is_enabled, value = nil)
    on_off = Array.new(2)
    eval(is_enabled) ? (on_off[0] = 'off') && (on_off[1] = 'on') : (on_off[0] = 'on') && (on_off [1] = 'off')
    click_button('Features')
    
    # Expand feature accordian
    @BROWSER.div(:class => 'l1_feature_name', :text => row).wait_until_present
    @BROWSER.div(:class => 'l1_feature_name', :text => row).scroll.to :center
    sleep(1)

    if @BROWSER.div(:class => 'l1_feature_name', :text => row).parent.parent.div.class_name.include? 'triangle-right'
      @BROWSER.div(:class => 'l1_feature_name', :text => row).scroll.to :bottom
      @BROWSER.div(:class => 'l1_feature_name', :text => row).click
      Watir::Wait.until(30) { @BROWSER.div(:class => 'l1_feature_name', :text => row).parent.parent.div.class_name.include? 'triangle-bottom' }
    end
    
    sleep(1)

    # This block will enable/disable features that are linked to a parent feature.
    if @BROWSER.div(:class => 'name-div', :text => feature_name).present?
      @BROWSER.div(:text, feature_name).scroll.to :bottom
      sleep(0.5)
      
      if @BROWSER.div(:class => 'name-div', :text => feature_name).parent.parent.parent.div(:class, /bootstrap-switch-#{on_off[0]}/).present?
        @BROWSER.div(:text, feature_name).parent.parent.parent.td(:index, 2).div.div.click
        @BROWSER.div(:class => 'name-div', :text => feature_name).parent.parent.parent.div(:class, /bootstrap-switch-#{on_off[1]}/).wait_until_present
      end

      # Sets a value to an enabled feature (if value is not nil) - eg - 'Max categories' = 3
      if value != nil
        if @BROWSER.div(:text, feature_name).parent.parent.parent.span(:class, 'select2-arrow').present?
          @BROWSER.div(:text, feature_name).parent.parent.parent.span(:class, 'select2-arrow').click
          @BROWSER.div(:id, 'select2-drop').div(:text, value).wait_until_present
          @BROWSER.div(:id, 'select2-drop').div(:text, value).click
          Watir::Wait.until { @BROWSER.div(:text, feature_name).parent.parent.parent.a(:class, 'select2-choice').text == value}
        else
          @BROWSER.div(:text, feature_name).parent.parent.parent.input.to_subtype.clear
          Watir::Wait.until { @BROWSER.div(:text, feature_name).parent.parent.parent.input.value == '' }
          @BROWSER.div(:text, feature_name).parent.parent.parent.input.send_keys value
          Watir::Wait.until { @BROWSER.div(:text, feature_name).parent.parent.parent.input.value == value }
        end
      end 
    
    # This block will enable/disable features at parent level.
    elsif @BROWSER.div(:class => 'l1_feature_name', :text => feature_name).present?
      if @BROWSER.div(:class => 'l1_feature_name', :text => feature_name).parent.parent.parent.parent.parent.div(:class, /bootstrap-switch-#{on_off[0]}/).present?
        @BROWSER.div(:class => 'l1_feature_name', :text => feature_name).parent.parent.parent.parent.parent.div(:class, /bootstrap-switch-#{on_off[0]}/).scroll.to :bottom
        @BROWSER.div(:class => 'l1_feature_name', :text => feature_name).parent.parent.parent.parent.parent.div(:class, /bootstrap-switch-#{on_off[0]}/).click
        @BROWSER.div(:class => 'l1_feature_name', :text => feature_name).parent.parent.parent.parent.parent.div(:class, /bootstrap-switch-#{on_off[1]}/).wait_until_present
      end
    else
      fail(msg = "Error. disabled_enabled_company_features. Feature '#{feature_name}' does not exist")
    end    
  end

  # Get company profile values
  def get_company_profile
    company_profile = Array.new(10)
    company_profile[0] = @BROWSER.a(:id, 'name').text
    company_profile[1] = @BROWSER.a(:id, 'started_on').text
    company_profile[2] = @BROWSER.a(:id, 'wa_subdomain').text
    company_profile[3] = @BROWSER.a(:id, 'industry_type').text
    company_profile[4] = @BROWSER.a(:id, 'vat_number').text
    company_profile[5] = @BROWSER.a(:id, 'contact_tel').text
    
    @BROWSER.a(:id, 'address').wait_until_present 
    @BROWSER.a(:id, 'address').click 
    @BROWSER.input(:name, 'address_one').wait_until_present
    company_profile[6] = @BROWSER.input(:name, 'address_one').value    
    company_profile[7] = @BROWSER.input(:name, 'address_two').value
    company_profile[8] = @BROWSER.input(:name, 'city').value
    company_profile[9] = @BROWSER.input(:name, 'post_code').value
    @BROWSER.button(:class, %w(btn btn-default btn-sm editable-cancel)).click
    @BROWSER.button(:class, %w(btn btn-default btn-sm editable-cancel)).wait_while_present

    return company_profile
  end

  # Save current feature state to the file
  def save_state_to_file
    score = 6
    click_button('Details')
    @BROWSER.tr(:text, /Features/).parent.form.click
    @BROWSER.tr(:text, /Features/).form(:class, %w(featuresTable clickable editing)).wait_until_present

    if ! @BROWSER.tr(:text, /Features/).div(:text => 'Social Recognition', :class => %w(feature-cell field panel-heading)).parent.div(:class, %w(col-sm-12 checkbox)).input.checked?
      score = 5 
    end

    if ! @BROWSER.tr(:text, /Features/).div(:text => 'Social Feed', :class => %w(feature-cell field panel-heading)).parent.div(:class, %w(col-sm-12 checkbox)).input.checked? 
      score = 3
    end

    if ! @BROWSER.tr(:text, /Features/).div(:text => 'Social Colleague Directory', :class => %w(feature-cell field panel-heading)).parent.div(:class, %w(col-sm-12 checkbox)).input.checked? 
      score = 0
    end

    file_service = FileService.new
    file_service.insert_to_file("admin_panel_settings_score:", score)
  end

  # Get company snapshot
  # @retuen company_snapshot
  def get_company_snapshot
    @BROWSER.div(:class => 'text-center', :text => 'State overview').wait_until_present
    company_snapshot = Array.new(4)

    for i in 0..company_snapshot.size - 1
    company_snapshot[i] = @BROWSER.tbody.th(:index, i).text
    end

    return company_snapshot
  end
("#{ screenshot_folder = "#{@test_report_folder_name}/screenshots" }")
  # Create company
  def create_company(payment_mathod)
    @BROWSER.div(:id, 'collapseCompany').wait_until_present
    email = next_email_account
    
    @BROWSER.input(:id, 'companyName').wait_until_present
    @BROWSER.input(:id, 'companyName').send_keys "#{USER_PROFILE[:new_admin_user][:company_name]}" + ' ' + "#{@COUNTER_INDEX}"
    @BROWSER.input(:id, 'nickname').wait_until_present
    @BROWSER.input(:id, 'nickname').send_keys "#{ $COMPANY_NICKNAME = "#{USER_PROFILE[:new_admin_user][:company_nickname]}" + "#{@COUNTER_INDEX}"}"
    @BROWSER.select(:name, /company/).wait_until_present
    @BROWSER.select(:name, /company/).select USER_PROFILE[:new_admin_user][:country]

    @BROWSER.input(:id, 'companyStart').wait_until_present
    @BROWSER.input(:id, 'companyStart').send_keys "#{USER_PROFILE[:new_admin_user][:joined_day]}/#{USER_PROFILE[:new_admin_user][:joined_month]}/#{USER_PROFILE[:new_admin_user][:joined_year]}"
    @BROWSER.select(:id, 'locale').wait_until_present
    @BROWSER.select(:id, 'locale').select USER_PROFILE[:new_admin_user][:local]
    @BROWSER.input(:id, 'wa_subdomain').wait_until_present
    wa_subdomain = "#{USER_PROFILE[:new_admin_user][:wa_subdomain]}" + "#{@COUNTER_INDEX}"  
    @BROWSER.input(:id, 'wa_subdomain').to_subtype.clear
    sleep(0.3)
    @BROWSER.input(:id, 'wa_subdomain').send_keys wa_subdomain

    @BROWSER.input(:id, 'address_one').wait_until_present
    @BROWSER.input(:id, 'address_one').send_keys USER_PROFILE[:new_admin_user][:addressList]
    @BROWSER.input(:id, 'address_two').wait_until_present
    @BROWSER.input(:id, 'address_two').send_keys USER_PROFILE[:new_admin_user][:addressListTwo]
    @BROWSER.input(:id, 'city').wait_until_present
    @BROWSER.input(:id, 'city').send_keys USER_PROFILE[:new_admin_user][:city]
    @BROWSER.select(:name, 'address[country]').wait_until_present
    @BROWSER.select(:name, 'address[country]').select USER_PROFILE[:new_admin_user][:country]
    @BROWSER.input(:id, 'post_code').wait_until_present
    @BROWSER.input(:id, 'post_code').send_keys USER_PROFILE[:new_admin_user][:postcode]

    @BROWSER.input(:id, 'first_name').wait_until_present 
    @BROWSER.input(:id, 'first_name').send_keys USER_PROFILE[:new_admin_user][:first_name]
    @BROWSER.input(:id, 'last_name').wait_until_present
    @BROWSER.input(:id, 'last_name').send_keys USER_PROFILE[:new_admin_user][:last_name]
    @BROWSER.input(:id, 'email').wait_until_present
    @BROWSER.input(:id, 'email').send_keys email 
    @BROWSER.input(:id, 'tel_work').wait_until_present
    @BROWSER.input(:id, 'tel_work').send_keys USER_PROFILE[:new_admin_user][:phone]
    @BROWSER.input(:id, 'job_title').wait_until_present
    @BROWSER.input(:id, 'job_title').send_keys  USER_PROFILE[:new_admin_user][:job_title]
    @BROWSER.input(:id, 'password').wait_until_present
    @BROWSER.input(:id, 'password').send_keys USER_PROFILE[:new_admin_user][:password]
    @BROWSER.input(:id, 'password_confirm').wait_until_present
    @BROWSER.input(:id, 'password_confirm').send_keys USER_PROFILE[:new_admin_user][:password]

    @BROWSER.button(:id => 'btn-submit', :text => 'Create').wait_until_present
    @BROWSER.button(:id => 'btn-submit', :text => 'Create').click
    @BROWSER.button(:id => 'btn-submit', :text => 'Create').wait_while_present
    
    file_service = FileService.new
    file_service.insert_to_file('new_company_url:', ("#{URL[:hermes]}".gsub! '[company_wa_subdomain]' , "#{URL[:password]}" + "@" + "#{wa_subdomain}") )
    file_service.insert_to_file('new_admin_email:', "#{email}")

    return @COUNTER_INDEX
  end

  # Create the next email account
  def next_email_account
    file_service = FileService.new

    # counter is use to create a different email address
    @COUNTER_INDEX = "#{rand(36**6).to_s(36)}"
    file_service.insert_to_file("admin_account_counter:", @COUNTER_INDEX)

    email_address = "#{USER_SIGNUP_INVITE_EMAIL[:local_part]}+ADMIN#{@COUNTER_INDEX}@lifeworks.com"
    return email_address
  end

  # Change company to the given state
  # @param state 
  def change_company_state (state)
    @BROWSER.a(:id, 'state').wait_until_present
    @BROWSER.a(:id, 'state').click
    @BROWSER.select.wait_until_present
    @BROWSER.select.select state
    @BROWSER.th(:text, 'Account state').parent.div.button(:class, %w(btn btn-primary btn-sm editable-submit)).wait_until_present
    @BROWSER.th(:text, 'Account state').parent.div.button(:class, %w(btn btn-primary btn-sm editable-submit)).click
    @BROWSER.th(:text, 'Account state').parent.div.button(:class, %w(btn btn-primary btn-sm editable-submit)).wait_while_present

    @BROWSER.a(:id => 'state', :text => state).wait_until_present
  end

  # Create new badge
  def create_new_badge
    @BROWSER.a(:text, 'Create new').wait_until_present
    @BROWSER.a(:text, 'Create new').click
    @BROWSER.h2(:text, 'Custom Badge: Create').wait_until_present
    @BROWSER.input(:name, /name/).wait_until_present

    locales = @BROWSER.labels(:class, 'locale').count
    upload_index = 0
    @locale = Array.new

    for i in 0..locales - 1
      @BROWSER.label(:class => 'locale', :index => i).click
      Watir::Wait.until(30) { @BROWSER.input(:name => /name/, :index => i).value == '' }
      @locale[i] = @BROWSER.label(:class => 'locale', :index => i).text

      @BROWSER.input(:name => /name/, :index => i).send_keys "#{NEW_BADGE[:name]} #{@locale[i]}"
      @BROWSER.input(:name => /tag/, :index => i).wait_until_present
      @BROWSER.input(:name => /tag/, :index => i).send_keys "#{NEW_BADGE[:tag]} #{@locale[i]}"
      @BROWSER.textarea(:name => /description/, :index => i).wait_until_present
      @BROWSER.textarea(:name => /description/, :index => i).send_keys "#{NEW_BADGE[:description]} #{@locale[i]}"

      @BROWSER.file_field(:index, upload_index).set eval(IMAGE_FILES[:badges][:social_butterfly][:colour])
      upload_index += 1
      @BROWSER.file_field(:index, upload_index).set eval(IMAGE_FILES[:badges][:social_butterfly][:black_and_white])
      upload_index += 1
      puts "Locale array is = #{@locale.to_s}"
    end  
    
    @BROWSER.button(:text, 'Save').wait_until_present
    @BROWSER.button(:text, 'Save').click
    @BROWSER.div(:class, %w(alert alert-dismissable alert-success)).wait_until_present
  end

  # Searches for badge in Arch badge tab by name
  # if should_be_in_list flag = false, then test will fail if the badge is NOT found 
  # if should_be_in_list flag = false, then test will fail if the badge is found 
  def search_for_badge (should_be_in_list = true, badge_name)
    @BROWSER.ul(:class, 'pagination').wait_until_present
    i = 0
    while @BROWSER.tr(:index, i).present?
      if @BROWSER.tr(:index, i).td(:text, /#{badge_name}/).present?
        if should_be_in_list
          return badge_list_index = i
          break
        else
          fail(msg = "Error. search_for_badge - Badge name '#{badge_name}' was found, but it should not be in the list of available badges")
        end
      else
        i += 1
        if !@BROWSER.tr(:index, i).present?
          puts "No more rows to search on current page. Checking to see if ther are more pages to search"
          if @BROWSER.ul(:class => 'pagination').li(:text => '»', :class => 'disabled').present?
            if should_be_in_list
              fail(msg = "Error. search_for_badge - Badge name '#{badge_name}' could not be found")
            else
              puts "After iterating through the list of all available badges, badge with name - '#{badge_name}' is correctly not available to select from this list"
            end
          else
            puts "Resetting i to 0 and navigating to next page of search results"
            @BROWSER.ul(:class => 'pagination').a(:text, '»').click
            @BROWSER.ul(:class, 'pagination').wait_until_present
            i = 0
          end
        end  
      end
    end
  end

  # Iterates through every translation of a badge (these translation are stored in an array that is created in the create_new_badge method)
  # Validates that when each translation is veiwed, a unique name/description/tag is displayed as per the chosen locale
  def validate_new_badge_in_list 
    badge_index = search_for_badge("#{NEW_BADGE[:name]}")

    i = 0
    @locale.each do |locale|
      @BROWSER.label(:class => 'locale', :text => locale).click
      @BROWSER.table(:class => 'table' , :index => i).tr(:index, badge_index).td(:text, "#{NEW_BADGE[:name]} #{locale}").wait_until_present
      @BROWSER.table(:class => 'table' , :index => i).tr(:index, badge_index).td(:text, "#{NEW_BADGE[:tag]} #{locale}").wait_until_present
      @BROWSER.table(:class => 'table' , :index => i).tr(:index, badge_index).td(:text, "#{NEW_BADGE[:description]} #{locale}").wait_until_present
      i += 1
    end

  end  

  # Delete the new badge and validate that it is not in list of badges after deletion
  def delete_new_badge (badge_to_delete)
    badge_index = search_for_badge(badge_to_delete)

    @BROWSER.tr(:index, badge_index).a(:text, 'Delete').click
    @BROWSER.h2(:text, /Delete the badge: #{badge_to_delete}/).wait_until_present
    @BROWSER.div(:class, 'thumbnail').p(:text, 'Are you sure you want to delete this?').wait_until_present
    @BROWSER.div(:class, 'thumbnail').p(:text, /#{badge_to_delete}/).wait_until_present
    @BROWSER.input(:class => %w(btn btn-danger), :value => 'Yes').wait_until_present
    @BROWSER.input(:class => %w(btn btn-danger), :value => 'Yes').click
    @BROWSER.div(:class, %w(alert alert-dismissable alert-success)).wait_until_present
    
    @BROWSER.a(:text, 'Create new').wait_until_present

    #Setting the first argument to false will make the method 'search_for_badge' iterate through all badges in the badge tab. If the badge is found, the test will fail
    search_for_badge(false, badge_to_delete)
  end
  
  # Add users by using CSV upload
  # @param number_of_users - number of new user to add in the CSV
  # @param email_or_id - which value is first in the CSV file
  def add_users_by_csv_upload (number_of_users, email_or_id)
    csv_file = create_csv_file(number_of_users, email_or_id)

    @BROWSER.file_field.set File.expand_path(csv_file)
    puts "File:#{File.expand_path(csv_file)}"
    if email_or_id == 'email' 
      @BROWSER.input(:id, 'optionsRadios1').click
      @BROWSER.input(:name, 'send_invitation_emails').click
      sleep(1)
    elsif email_or_id == 'id'
      @BROWSER.input(:id, 'optionsRadios3').click
      sleep(1)
    end
    
    click_button('Submit CSV')
    File.delete(csv_file);
  end

  # Upload CSV file
  # @param number_of_users - number of new user to add in the CSV
  # @param email_or_id - which value is first in the CSV file
  def remove_users_by_csv_upload (number_of_users, email_or_id)
    csv_file = create_csv_file(number_of_users, email_or_id, true)

    @BROWSER.fieldset(:class => %w(panel panel-default js-users-container), :index => 1).file_field.set File.expand_path(csv_file)

    if email_or_id == 'email' 
      @BROWSER.fieldset(:class => %w(panel panel-default js-users-container), :index => 1).input(:id, 'optionsRadios1').click
      sleep(1)
    elsif email_or_id == 'id'
     @BROWSER.fieldset(:class => %w(panel panel-default js-users-container), :index => 1).input(:id, 'optionsRadios3').click
      sleep(1)
    end
    
    @BROWSER.fieldset(:class => %w(panel panel-default js-users-container), :index => 1).button(:text, 'Submit').wait_until_present
    @BROWSER.fieldset(:class => %w(panel panel-default js-users-container), :index => 1).button(:text, 'Submit').click
    @BROWSER.div(:class, %w(alert alert-dismissable alert-success)).ul.li(:text, 'CSV processing complete').wait_until_present
    File.delete(csv_file)
  end


  # Create CSV file 
  # @param number_of_users - number of new user to add in the CSV
  # @param email_or_id - which value is first in the CSV file
  def create_csv_file (number_of_users, email_or_id, only_email = false)
    puts "only_email:#{only_email}"
    file = File.new("user.csv", 'w+')
    for i in 1..number_of_users.to_i
      if email_or_id == 'email' 
        if only_email
          puts "only_email"
          line = "#{USER_SIGNUP_INVITE_EMAIL[:local_part]}+csv#{i}@#{USER_SIGNUP_INVITE_EMAIL[:subdomain]}"
          file.write(line)
        else
          line = "#{USER_SIGNUP_INVITE_EMAIL[:local_part]}+csv#{i}@#{USER_SIGNUP_INVITE_EMAIL[:subdomain]},user#{i} csv, user#{i} csv,Csv Job Title,28/04/1971,Male,15/01/2017,0208-364-1234,(0208)-364-1234,GB"
          file.puts(line)
        end
        
      elsif email_or_id == 'id'
        line = "#{i},user#{i} csv, user#{i} csv,,new user,28/04/1971,Male,15/01/2017,0208-364-1234,(0208)-364-1234,GB"
        file.puts(line)
      end
   end

   file.close
   return file
  end

  # Set total rewards
  def set_total_rewards
    @total_budget_uploaded = (@BROWSER.th(:text, 'Total Budget Uploaded').parent.td.text)[1..-1].to_f
    @total_rewards_issued = (@BROWSER.th(:text, 'Total Rewards Issued').parent.td.text)[1..-1].to_f
    @rewards_budget = (@BROWSER.th(:text, 'Rewards Budget').parent.td.text)[1..-1].to_f
  end

  # Validate total rewards after update
  # @param operation - add or subtract
  # @param amount
  def validate_total_rewards_after_update (operation, amount)
    if operation == 'Add'
      # if (@BROWSER.th(:text, 'Total Budget Uploaded').parent.td.text)[1..-1].to_f != @total_budget_uploaded + amount
      #   fail(msg = "Error. validate_total_rewards_after_update. 'Total Budget Uploaded' should be #{@total_budget_uploaded + amount}")
      # end

      # if (@BROWSER.th(:text, 'Total Rewards Issued').parent.td.text)[1..-1].to_f != @total_rewards_issued
      #   fail(msg = "Error. validate_total_rewards_after_update. 'Total Rewards Issued' should be #{@total_budget_uploaded + amount}")
      # end
      
      # if (@BROWSER.th(:text, 'Rewards Budget').parent.td.text)[1..-1].to_f != @rewards_budget + amount
      #   fail(msg = "Error. validate_total_rewards_after_update. 'Total Rewards Issued' should be #{@total_budget_uploaded + amount}")
      # end
    else
      # if (@BROWSER.th(:text, 'Total Budget Uploaded').parent.td.text)[1..-1].to_f != @total_budget_uploaded - amount
      #   fail(msg = "Error. validate_total_rewards_after_update. 'Total Budget Uploaded' should be #{@total_budget_uploaded - amount}")
      # end

      # if (@BROWSER.th(:text, 'Total Rewards Issued').parent.td.text)[1..-1].to_f != @total_rewards_issued
      #   fail(msg = "Error. validate_total_rewards_after_update. 'Total Rewards Issued' should be #{@total_budget_uploaded - amount}")
      # end

      # if (@BROWSER.th(:text, 'Rewards Budget').parent.td.text)[1..-1].to_f != @rewards_budget - amount
      #   fail(msg = "Error. validate_total_rewards_after_update. 'Total Rewards Issued' should be #{@total_budget_uploaded - amount}")
      # end
    end
  end

  # Add or subtract reward amount
  # @param operation - add or subtract
  # @param amount
  def rewards_budget (operation, amount)
    @BROWSER.a(:text, /Budget/).wait_until_present
    @BROWSER.a(:text, /Budget/).click
    @BROWSER.h3(:text, 'Budget').wait_until_present

    set_total_rewards
    @BROWSER.select(:id, 'spotRewards-uploadBudget-operation').wait_until_present
    @BROWSER.select(:id, 'spotRewards-uploadBudget-operation').select operation
    
    @BROWSER.input(:id, 'spotRewards-uploadBudget-amount').wait_until_present
    @BROWSER.input(:id, 'spotRewards-uploadBudget-amount').send_keys amount.to_i

    @BROWSER.button(:text, 'Upload budget').click
    validate_total_rewards_after_update(operation, amount)
  end

  # Validate transactions details visible in the table after giving award to user
  def validate_transactions(admin_name, user_name, state, amount, retailer = nil, provider = nil)
    @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:text, 'Transaction info Issuer Recipient Status Amount Item info Provider Date redeemed').wait_until_present
    @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).td(:text, admin_name).wait_until_present
    @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).td(:text, user_name).wait_until_present
    @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).td(:text, state).wait_until_present
    @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).span(:text, /#{Time.at(Time.new).to_date.strftime("%d/%m/%Y").to_s}/).wait_until_present
    @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).td(:text, /#{amount}/).wait_until_present

    if state == 'Claimed'
      @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).td(:text, /#{retailer}/).wait_until_present
      @BROWSER.table(:class, %w(table table-bordered table-hover table-with-header)).tr(:index, 1).td(:text, provider).wait_until_present
    end
  end

  # Set gift cards feature key
  # @param degraded_or_not
  # @param feed - type of feed
  # @param shipping - 'Excluded'/'Included'
  def set_gift_cards_feature_key (degraded_or_not, feed, shipping)
    @BROWSER.execute_script(%{jQuery("select").show();})

    @BROWSER.select(:id, 'feature-benefit_gift_card-is_degraded').wait_until_present

    @BROWSER.select(:id, 'feature-benefit_gift_card-is_degraded').select degraded_or_not
    
    class_name = @BROWSER.div(:text, 'Shipping').parent.parent.parent.td(:index, 2).div.class_name
  
    if shipping == 'Excluded'
      if class_name.include? 'switch-on'
        @BROWSER.div(:text, 'Shipping').parent.parent.parent.td(:index, 2).div.div.click
        Watir::Wait.until { @BROWSER.div(:text, 'Shipping').parent.parent.parent.td(:index, 2).div.class_name.include? 'switch-off'}
      end 
    elsif shipping == 'Included'
      if class_name.include? 'switch-off'
        @BROWSER.div(:text, 'Shipping').parent.parent.parent.td(:index, 2).div.div.click
        Watir::Wait.until { @BROWSER.div(:text, 'Shipping').parent.parent.parent.td(:index, 2).div.class_name.include? 'switch-on'}
      end
    end

    @BROWSER.select(:id, 'feature-benefit_gift_card_feed-value').select /#{feed}/

    click_button('Save')
  end

  # Set grouping feature key
  # @param state - 'Disabled'/'Enabled'
  # @param managed_by - 'Admin'/'Account'
  def set_grouping_feature_key (state, managed_by)
    @BROWSER.div(:text, 'Grouping main').wait_until_present
    @BROWSER.div(:text, 'Grouping main').scroll.to 
    @BROWSER.execute_script(%{jQuery("select").show();})

    if !@BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).present?
      @BROWSER.div(:text, 'Grouping main').scroll.to :bottom
      @BROWSER.div(:text, 'Grouping main').click
      Watir::Wait.until { @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).present? }
    end

    class_name = @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.class_name
  
    if state == "Disabled"
      if class_name.include? 'switch-on'
        @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.scroll.to :bottom
        @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.click
        Watir::Wait.until { @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.class_name.include? 'switch-off'}
      end 
    elsif state == "Enabled"
      if class_name.include? 'switch-off'
        @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.span(:class, %w(bootstrap-switch-handle-off bootstrap-switch-danger)).scroll.to :bottom
        @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.span(:class, %w(bootstrap-switch-handle-off bootstrap-switch-danger)).click
        Watir::Wait.until { @BROWSER.div(:id, 'collapse_grouping_virtual').tr(:index, 1).td(:index, 2).div.class_name.include? 'switch-on'}
      end
    end

    @BROWSER.select(:id, 'feature-grouping-value').select /#{managed_by}/
    click_button('Save')
  end

  # Search for user by the given name
  # @param user_name
  def search_for_user (user_name, select_user = true)
    file_service = FileService.new

    if user_name == 'current limited user'
      user_name = file_service.get_from_file('limited_account_name:').chomp
    elsif user_name == 'current upgraded user'
      user_name = file_service.get_from_file('upgraded_personal_account_name:').chomp
    end

    @BROWSER.input(:id, 'search_term').wait_until_present
    @BROWSER.input(:id, 'search_term').send_keys user_name
    @BROWSER.input(:id, 'search_term').send_keys :enter
    @BROWSER.table(:id, 'user-list').wait_until_present
    Watir::Wait.until { @BROWSER.table(:id, 'user-list').td(:text => user_name).exist? }
    
    i = 0
    while ! @BROWSER.table(:id, 'user-list').td(:text => user_name).exists?
      @BROWSER.send_keys :space
      sleep(1)

      i += 1

      if i == 10
        fail(msg = "Error. search_for_user. #{user_name} was not found in the users list")
      end
    end
    
    @BROWSER.table(:id, 'user-list').td(:text, user_name).scroll.to :bottom
    
    if select_user
      @BROWSER.table(:id, 'user-list').td(:text, user_name).a.click
      @BROWSER.div(:class, %w(col-md-7 col-md-offset-1)).h4(:text => user_name).wait_until_present
    end
  end

  # Credit user
  # @param amount - to credit
  # @param currency_name - GBP,USD,CAD
  def cerdit_user (amount, currency_name)
    @BROWSER.ul(:class, %w(nav nav-tabs)).a(:text, 'Transactions').wait_until_present
    @BROWSER.ul(:class, %w(nav nav-tabs)).a(:text, 'Transactions').click

    @BROWSER.a(:text, "Credit user's wallet").wait_until_present
    @BROWSER.a(:text, "Credit user's wallet").click

    @BROWSER.select(:name, 'currency').wait_until_present
    #@BROWSER.select(:name, 'currency').select /#{currency_name}/
    @BROWSER.select(:name, 'confirm_currency').wait_until_present
    #@BROWSER.select(:name, 'confirm_currency').select /#{currency_name}/

    @BROWSER.input(:name, 'amount').wait_until_present    
    @BROWSER.input(:name, 'amount').send_keys amount

    @BROWSER.input(:name, 'confirm_amount').wait_until_present
    @BROWSER.input(:name, 'confirm_amount').send_keys amount

    @BROWSER.button(:text, 'Save').wait_until_present
    @BROWSER.button(:text, 'Save').click

    @BROWSER.div(:class, %w(alert alert-dismissable alert-success)).ul(:text, 'Credit created successfully.').wait_until_present
  end

# @params add_or_delete
# @params locales_to_add
# Adds x amount of cms contact numbers to a company. These numbers will appear on the life Employee assistance page if the user locale matches the cms locale
  def add_delete_company_locales (add_or_delete, locales_to_add)
    click_button('Details')
    i = 0
    if add_or_delete == 'add'
      locales_to_add.split(',').each do |locale|
        @BROWSER.button(:id, 'newCmsContactBtn').wait_until_present
        
        if !@BROWSER.div(:id, 'cmsContactWrapper').strong(:text, LOCALES[:"#{locale}"][:label]).present?
          @BROWSER.button(:id, 'newCmsContactBtn').wait_until_present
          @BROWSER.button(:id, 'newCmsContactBtn').scroll.to :bottom
          @BROWSER.button(:id, 'newCmsContactBtn').click
          Watir::Wait.until { @BROWSER.div(:id, 'cms_contact_overrides').a(:text, 'Empty').exist? }
          @BROWSER.div(:id, 'cms_contact_overrides').a(:text, 'Empty').fire_event('click')
          @BROWSER.text_field(:name, 'label').wait_until_present
          @BROWSER.text_field(:name, 'label').send_keys LOCALES[:"#{locale}"][:label]
          @BROWSER.text_field(:name, 'telno').wait_until_present
          @BROWSER.text_field(:name, 'telno').send_keys LOCALES[:"#{locale}"][:tel_no]
          @BROWSER.span(:text, 'Locale:').parent.label(:text, LOCALES[:"#{locale}"][:locale]).wait_until_present
          @BROWSER.span(:text, 'Locale:').parent.label(:text, LOCALES[:"#{locale}"][:locale]).scroll.to :bottom
          @BROWSER.span(:text, 'Locale:').parent.label(:text, LOCALES[:"#{locale}"][:locale]).click
          sleep(2)
          @BROWSER.span(:class, %w(editable-container editable-inline)).div(:class, %w(editable-buttons)).button(:class, %w(btn btn-primary btn-sm editable-submit)).wait_until_present
          @BROWSER.span(:class, %w(editable-container editable-inline)).div(:class, %w(editable-buttons)).button(:class, %w(btn btn-primary btn-sm editable-submit)).scroll.to :bottom
          @BROWSER.span(:class, %w(editable-container editable-inline)).div(:class, %w(editable-buttons)).button(:class, %w(btn btn-primary btn-sm editable-submit)).click
          @BROWSER.span(:class, %w(editable-container editable-inline)).div(:class, %w(editable-buttons)).button(:class, %w(btn btn-primary btn-sm editable-submit)).wait_while_present
          @BROWSER.button(:class => %w(btn btn-danger removeContactBtn), :index => i).wait_until_present
          i += 1
        end
      end
    else
      @BROWSER.button(:id, 'newCmsContactBtn').wait_until_present

      while @BROWSER.button(:class => %w(btn btn-danger removeContactBtn), :index => 0).present?
        @BROWSER.button(:class => %w(btn btn-danger removeContactBtn), :index => 0).fire_event('click')
        @BROWSER.div(:text, 'Deleted CMS contact information.').wait_until_present
        @BROWSER.div(:text, 'Deleted CMS contact information.').wait_while_present
      end

      Watir::Wait.until{ !@BROWSER.button(:class => %w(btn btn-danger removeContactBtn)).present? }
    end
  end

  # @params add_or_delete
  # Adds a new shared account user or deletes the lates shared account user
  def add_or_delete_shared_account_user (add_or_delete)
    @file_service = FileService.new
    default_locale = COMPANY_PROFILE[:profile_1][:locale]

    click_button('Shared Accounts')

    if add_or_delete == 'add'
      @file_service.insert_to_file('shared_account_user_name:', "sharedaccount#{LOCALES[:"#{default_locale}"][:label].downcase.gsub('_','')}#{rand(36**6).to_s(36)}")
   
      @SHARED_ACCOUNT_USERNAME = @file_service.get_from_file('shared_account_user_name:')[0..-2]
      click_button('Create Shared Account')
      @BROWSER.text_field(:name, 'login').send_keys @SHARED_ACCOUNT_USERNAME
      @BROWSER.text_field(:name, 'password').send_keys ACCOUNT[:"#{$account_index}"][:valid_account][:password]
      @BROWSER.select_list(:name, 'country_code').select LOCALES[:"#{default_locale}"][:country]
      @BROWSER.label(:text, 'Locale*').parent.select_list.select LOCALES[:"#{default_locale}"][:language]
      @BROWSER.button(:text, 'Save').click
      @BROWSER.button(:text, 'Save').wait_while_present
      @BROWSER.a(:text, 'Delete').wait_until_present
    else 
      current_page =  @BROWSER.li(:class => 'active', :text => /\d+/).text.to_i
      @SHARED_ACCOUNT_USERNAME = @file_service.get_from_file('shared_account_user_name:')[0..-2]

      while !@BROWSER.a(:text, @SHARED_ACCOUNT_USERNAME).present?
        current_page = current_page + 1

        if @BROWSER.ul(:class, 'list-ini pagination pagination-sm').a(:text, "#{current_page}").present?
          @BROWSER.ul(:class, 'list-ini pagination pagination-sm').a(:text, "#{current_page}").click
          @BROWSER.li(:class => 'active', :text => "#{current_page}").wait_until_present
        else
          fail(msg = "Error. add_or_delete_shared_account_user - Shared account user '#{@SHARED_ACCOUNT_USERNAME}' cannot be found")
        end
      end

      @BROWSER.a(:text, @SHARED_ACCOUNT_USERNAME).click
      @BROWSER.a(:text, 'Delete').wait_until_present
      @BROWSER.a(:text, 'Delete').click
      @BROWSER.alert.wait_until_present
      @BROWSER.alert.ok
      @BROWSER.a(:text, 'Create Shared Account').wait_until_present
      @file_service.insert_to_file('shared_account_user_name:', '')
      $LATEST_DELETED_USER = @SHARED_ACCOUNT_USERNAME

      if !@BROWSER.li(:class => 'active', :text => "#{current_page}").present?
        @BROWSER.ul(:class, 'list-ini pagination pagination-sm').a(:text, "#{current_page}").click
        @BROWSER.li(:class => 'active', :text => "#{current_page}").wait_until_present
      end
      
      if @BROWSER.a(:text, @SHARED_ACCOUNT_USERNAME).present?
        fail(msg = "error. add_or_delete_shared_account_user. #{@SHARED_ACCOUNT_USERNAME} has not been deleted and is still visible on the 'Shared Account' user list and has therefore not been deleted")
      end
    end
  end

  def upgrade_limited_user_to_personal_user
    file_service = FileService.new

    @BTN_CHANGE_TO_PERSONAL_ACCOUNT.wait_until_present
    @BTN_CHANGE_TO_PERSONAL_ACCOUNT.click
    Watir::Wait.until { @BROWSER.alert.present? }
    @BROWSER.alert.ok

    Watir::Wait.until { 
      !@BROWSER.alert.present?
      # !@BTN_CHANGE_TO_PERSONAL_ACCOUNT.present? 
    }
    
    @BROWSER.ol(:class, 'breadcrumb').a(:text, 'Users').wait_until_present
    @BROWSER.ol(:class, 'breadcrumb').a(:text, 'Users').fire_event('click')
    file_service.insert_to_file('upgraded_personal_account_username:', "#{file_service.get_from_file('limited_account_user_name:').chomp}")
    file_service.insert_to_file('upgraded_personal_account_name:', "#{file_service.get_from_file('limited_account_name:').chomp}")
    file_service.insert_to_file('limited_account_user_name:', '')
    file_service.insert_to_file('limited_account_name:', '')
    validate_limited_user_upgraded_to_personal
  end

  def validate_limited_user_upgraded_to_personal
    file_service = FileService.new
    user_name = file_service.get_from_file('upgraded_personal_account_name:').chomp

    search_for_user('current upgraded user', false)

    if @BROWSER.a(:text, user_name).parent.parent.td(:index, 7).text != 'personal'
      fail(msg = "Error. validate_limited_user_upgraded_to_personal. User should be a 'personal', but is being displayed as #{@BROWSER.a(:text, user_name).parent.parent.td(:index, 7).text}")
    elsif @BROWSER.a(:text, user_name).parent.parent.td(:index, 6).text != 'active'
      fail(msg = "Error. validate_limited_user_upgraded_to_personal. User should be a 'active', but is being displayed as #{@BROWSER.a(:text, user_name).parent.parent.td(:index, 6).text}")
    end

    @BROWSER.table(:id, 'user-list').td(:text, user_name).a.click
    @BROWSER.div(:class, %w(col-md-7 col-md-offset-1)).h4(:text => user_name).wait_until_present
    # Watir::Wait.until { @BROWSER.h4(:text, 'User Information').parent.tbody.tr(:index, 7).td(:index, 1).text == 'personal' }
  end

  def set_dependant_account_invite_limit (invite_limit)
    @BROWSER.a(:id, 'dependant_accounts_limit').wait_until_present
    if ! @BROWSER.a(:id => 'dependant_accounts_limit', :text => invite_limit).present?
      click_button('Edit Dependant Account Limit')
      @BROWSER.td(:text, 'Dependant Accounts').parent.text_field.set invite_limit
      click_button('Save Dependant Account Limit')
      @BROWSER.a(:id => 'dependant_accounts_limit', :text => invite_limit).wait_until_present
    end
  end
end
