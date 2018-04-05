# -*- encoding : utf-8 -*-
class ArchAffiliatesPage
  def initialize (browser)
    @BROWSER = browser
    
    @BTN_CREATE_NEW_CAMPAIGN = @BROWSER.a(:text, 'Create Campaign')
    @BTN_CREATE = @BROWSER.input(:value, 'Create')
    @BTN_CREATE_NEW_AFFILIATE = @BROWSER.button(:id, 'modal-btn-validate')
    @BTN_ACTIVE_STATE = @BROWSER.label(:class => /btn btn-primary/, :text=> /Active/)
    @BTN_INACTIVE_STATE = @BROWSER.label(:class => /btn btn-primary/, :text=> /Inactive/)

    @TXF_CAMPAIGN_NAME = @BROWSER.input(:id, 'name')
    @TXF_CAMPAIGN_CODE = @BROWSER.input(:id, 'code')
    @TXF_DATE_FROM = @BROWSER.input(:id, 'date-from')
    @TXF_DISCOUNT_PERCENTAGE = @BROWSER.input(:id, 'discount')
    @TXF_AFFILIATE_KICKBACK = @BROWSER.input(:id, 'kickback')

  end

  def is_visible (page)
    case page
    when 'main'
      @BROWSER.h2(:text, 'Affiliates').wait_until_present
      @BROWSER.table(:index, 1).tr(:text, 'Affiliate Campaign State No. networks signed up No. paid active users No. trial users Discount Agreed kickback Requested by Authorised by').wait_until_present
      @BROWSER.input(:id, 'search-field').wait_until_present
      @BTN_CREATE_NEW_CAMPAIGN.wait_until_present
    when 'campaign'
      @BROWSER.h4(:text, 'Affiliate Information').wait_until_present
      @BROWSER.select(:id, 'affiliate-name').wait_until_present
      @BROWSER.input(:id, 'affiliate-email').wait_until_present
      @BROWSER.h4(:text, 'Campaign Information').wait_until_present
      @TXF_CAMPAIGN_NAME.wait_until_present
      @TXF_CAMPAIGN_CODE.wait_until_present
      @TXF_DATE_FROM.wait_until_present
      @BROWSER.input(:id, 'date-to').wait_until_present
      @BROWSER.input(:id, 'date-to-none').wait_until_present
      @TXF_DISCOUNT_PERCENTAGE.wait_until_present
      @BROWSER.input(:id, 'discount-date-to').wait_until_present
      @BROWSER.input(:id, 'discount-date-to-none').wait_until_present
      @TXF_AFFILIATE_KICKBACK.wait_until_present
      @BROWSER.input(:id, 'signup-limit').wait_until_present
      @BROWSER.input(:id, 'signup-limit-none').wait_until_present
      @BTN_CREATE.wait_until_present
    end
  end

  def click_button (button)
    case button
    when 'Create Campaign'
      @BTN_CREATE_NEW_CAMPAIGN.wait_until_present
      @BTN_CREATE_NEW_CAMPAIGN.click
      is_visible('campaign')
    when 'Create New Affiliate'
      @BTN_CREATE_NEW_AFFILIATE.wait_until_present
      @BTN_CREATE_NEW_AFFILIATE.click
      @BROWSER.div(:class, 'modal-content').wait_while_present 
    when 'Create'
      @BTN_CREATE.wait_until_present
      @BTN_CREATE.click
      @BROWSER.li(:text, 'Well done! A new campaign was created.').wait_until_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Create new affiliate
  def create_new_affiliate
    click_button('Create Campaign')
    @BROWSER.select(:id, 'affiliate-name').wait_until_present
    @BROWSER.select(:id, 'affiliate-name').select 'Create new'
    
    @BROWSER.h4(:text, 'Create new affiliate').wait_until_present
    @BROWSER.input(:id, 'new-affiliate-name').wait_until_present
    @BROWSER.input(:id, 'new-affiliate-email').wait_until_present

    @BROWSER.input(:id, 'new-affiliate-name').send_keys AFFILIATE[:name]
    @BROWSER.input(:id, 'new-affiliate-email').send_keys AFFILIATE[:email]

    click_button('Create New Affiliate')
  end

 def create_new_campaign
  @file_service = FileService.new
  # counter is use to create a different Campaign name
  @COUNTER_INDEX = @file_service.get_from_file("campaign_name_counter:")
  @COUNTER_INDEX = @COUNTER_INDEX.to_i + 1
  @COUNTER_INDEX = sprintf '%03d', @COUNTER_INDEX
  @file_service.insert_to_file("campaign_name_counter:", @COUNTER_INDEX)

  @TXF_CAMPAIGN_NAME.wait_until_present
  @TXF_CAMPAIGN_NAME.send_keys "#{ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]} #{@COUNTER_INDEX}"
  @TXF_CAMPAIGN_CODE.send_keys @COUNTER_INDEX
  @TXF_DATE_FROM.send_keys Time.now.strftime("%d/%m/%Y")
  @BROWSER.td(:class, %w(active day)).wait_until_present
  @BROWSER.td(:class, %w(active day)).fire_event('click')
  @TXF_DISCOUNT_PERCENTAGE.send_keys '5'
  @TXF_AFFILIATE_KICKBACK.send_keys '5'
  @BTN_ACTIVE_STATE.click
  Watir::Wait.until(30) { @BTN_ACTIVE_STATE.class_name.include? 'active' }
  click_button('Create')
end




end
