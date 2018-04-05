# -*- encoding : utf-8 -*-
class ZeusSettingsPage
  def initialize (browser)
    @BROWSER = browser
    @BTN_GENERATE_NEW = @BROWSER.div(:class => %w(btn btn-primary btn-block), :text => ZEUS_STRINGS["settings"]["invitation"]['generate_new'])
    @BTN_INVITATIONS = @BROWSER.a(:text, ZEUS_STRINGS["settings"]["menu"]["invitations"])
    @BTN_APPEARANCE = @BROWSER.a(:text, ZEUS_STRINGS["settings"]["menu"]["appearance"])
    @ARW_APPEARANCE_DROPDOWN = @BROWSER.div(:class, 'sidebar-dropdown-module__sidebar-dropdown-header-icon___3svvd')
    
  end

  def is_visible
    @BROWSER.h2(:text, ZEUS_STRINGS["post_login"]["settings"]).wait_until_present
    @BROWSER.a(:text, ZEUS_STRINGS["settings"]["menu"]["appearance"]).wait_until_present

    if ($ADMIN_FEATURE_LIST['grouping']).to_i != 0
      fail(msg = "Error. @Z9.1 Test case can't be tested when Grouping is on")
    else
      @BTN_INVITATIONS.wait_until_present
    end
    
    @BROWSER.a(:text, ZEUS_STRINGS["settings"]["menu"]["emails"]).wait_until_present
    @BROWSER.a(:text, ZEUS_STRINGS["settings"]["menu"]["timeline"]).wait_until_present
  end

  def click_button (button)
    case button
    when 'Generate new'
      @BROWSER.span(:text, /#{(ZEUS_STRINGS["settings"]["invitation"]["current_code"])[0..12]}/).wait_until_present
      @BTN_GENERATE_NEW.wait_until_present
      @BTN_GENERATE_NEW.click
      @BROWSER.span(:text, /#{(ZEUS_STRINGS["settings"]["invitation"]["current_code"])[0..12]}/).wait_while_present
    when 'Invitations'
      @BTN_INVITATIONS.wait_until_present
      @BTN_INVITATIONS.click
      @BROWSER.h4(:text, /#{(ZEUS_STRINGS["settings"]["invitation"]["panel_title"])[0..20]}/).wait_until_present
    when 'Appearance'
      @BTN_APPEARANCE.wait_until_present
      @BTN_APPEARANCE.click
      @BROWSER.h2(:text, ZEUS_STRINGS['settings']['hero']['title']).wait_until_present
    when 'Edit information' 
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['edit_btn']).present? ? @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['edit_btn']).click : nil
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['save_btn']).wait_until_present
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['cancel_btn']).wait_until_present
    when 'Save appearance settings'    
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['save_btn']).wait_until_present
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['save_btn']).click
      @BROWSER.div(:class => 'toast-message', :text => ZEUS_STRINGS['settings']['appearance']['updated']).wait_until_present
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['edit_btn']).wait_until_present
      @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['save_btn']).wait_while_present
    else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Create new invitation code
  def create_new_invitation
    @BROWSER.span(:text, /#{(ZEUS_STRINGS["settings"]["invitation"]["current_code"])[0..12]}/).wait_until_present
    current_invitation_code = @BROWSER.strong(:class, 'ng-binding').text
    
    click_button('Generate new')
    Watir::Wait.until { @BROWSER.strong(:class, 'ng-binding').text != current_invitation_code }
    new_company_code = @BROWSER.strong(:class, 'ng-binding').text

    file_service = FileService.new
    file_service.insert_to_file("company_invitation_code:", new_company_code)
    puts "New invitation code is #{new_company_code}"
  end 

  # Validates each image upload section on the appearance page by uploading a new image, then deleting it
  def verify_image_upload_and_deletion (image_format_to_upload)
    (@BROWSER.h4s(:class => 'text-semibold').map &:text).each do |image_type|
      if image_type != ZEUS_STRINGS['settings']['nickname']['title']
        puts "image_type being verified = #{image_type}, image format to upload = #{image_format_to_upload}"
        delete_image(image_type)
        add_image(image_type, image_format_to_upload)
        # delete_image(image_type)
      end
    end
  end

  # Deletes an image. Pass in the image name as the variable in order to delete the image associated with that section Eg 'Cover image'
  # @param = image_type
  def delete_image (image_type)
    image = @BROWSER.h4(:text, image_type)
    image.wait_until_present

    click_button('Edit information')
    
    if image.parent.parent.button(:text, ZEUS_STRINGS['settings']['image']['remove']).present?
      image.parent.parent.button(:text, ZEUS_STRINGS['settings']['image']['remove']).click
      image.parent.parent.button(:text, ZEUS_STRINGS['settings']['image']['remove']).wait_while_present
      image.parent.parent.div(:class, %w(icon icon-add-picture)).wait_until_present
      image.parent.parent.button(:text, /#{ZEUS_STRINGS['settings']['image']['add'].delete(' %{type}')}/).wait_until_present
      click_button('Save appearance settings')
      click_button ('Invitations')
      click_button ('Appearance')
      capture_image_in_hash(image_type, "v1\/common\/static_image")
      image.parent.parent.div(:class, %w(icon icon-add-picture)).wait_until_present
    end
  end

  # Adds an image. Pass in the image name as the variable in order to add the image associated with that section. Eg 'Cover image'
  # @param = image_type eg - 'Company Logo', 'Square logo' or  'Cover Image'
  # @param = image_format_to_upload, eg - 'gif', 'jpg' or 'png'
  def add_image (image_type, image_format_to_upload)
    image = @BROWSER.h4(:text, image_type)
    image_type == ZEUS_STRINGS['settings']['appearance']['cover_image']['label'] ? add_or_change = ZEUS_STRINGS['settings']['image']['change'].delete(' %{type}') : add_or_change = ZEUS_STRINGS['settings']['image']['add'].delete(' %{type}')
    image.wait_until_present

    click_button('Edit information')

    image.parent.parent.button(:text, /#{add_or_change}/).wait_until_present
    image.parent.parent.button(:text, /#{add_or_change}/).click
    @BROWSER.a(:text, /#{ZEUS_STRINGS['cropping_tool']['step_1']['input_label']}/).wait_until_present
    @BROWSER.file_field(:index, (@BROWSER.h4s(:class => 'text-semibold').map &:text).find_index(image_type) - 1).set eval(IMAGE_FILES[:company_appearance][:allowed_image_types][:"#{image_format_to_upload}"])
    @BROWSER.div(:text, ZEUS_STRINGS['cropping_tool']['step_2']['title']).parent.parent.div(:class, %w(btn btn-primary)).wait_until_present
    # Save image upload
    @BROWSER.div(:text, ZEUS_STRINGS['cropping_tool']['step_2']['title']).parent.parent.div(:class, %w(btn btn-primary)).click
    @BROWSER.div(:text, ZEUS_STRINGS['cropping_tool']['step_2']['title']).parent.parent.div(:class, %w(btn btn-primary)).wait_while_present
    image_type == ZEUS_STRINGS['settings']['appearance']['cover_image']['label'] ? image.parent.parent.button(:text, ZEUS_STRINGS['settings']['image']['remove']).wait_while_present : image.parent.parent.button(:text, ZEUS_STRINGS['settings']['image']['remove']).wait_until_present
    image.parent.parent.button(:text, /#{ZEUS_STRINGS['settings']['image']['change'].delete(' %{type}')}/).wait_until_present
    image.parent.parent.div(:class, %w(icon icon-add-picture)).wait_while_present
    image.parent.parent.img(:src, /https:\/\//).wait_until_present
    @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['edit_btn']).present? ? @BROWSER.button(:text, ZEUS_STRINGS['settings']['appearance']['edit_btn']).click : nil
    click_button('Save appearance settings')
    image.parent.parent.img(:src, /https:\/\//).wait_until_present
    image.parent.parent.button(:text, /#{ZEUS_STRINGS['settings']['image']['change'].delete(' %{type}')}/).wait_while_present
    image.parent.parent.button(:text, /#{add_or_change}/).wait_while_present
    click_button ('Invitations')
    click_button ('Appearance')
    image_identifier = image.parent.parent.img(:index, 1).src.match(/v1.*/)[0].to_s
    image_identifier = image_identifier.gsub('/','\/')
    capture_image_in_hash(image_type,image_identifier)
  end

  def capture_image_in_hash (image_type, image_identifier)
    @ARW_APPEARANCE_DROPDOWN.present? ? locale = @BROWSER.div(:class, 'sidebar-dropdown-module__sidebar-dropdown-item___2eSN9 sidebar-dropdown-module__selected___T6n_e').text.gsub(' ', '_').downcase.to_sym : locale = ACCOUNT[:"#{$account_index}"][:valid_account][:user_locale].downcase.gsub('-', '_').to_sym
    $IMAGE_HASH.nil? ? $IMAGE_HASH = {} : nil
    $IMAGE_HASH[locale].nil? ? $IMAGE_HASH[locale] = {} : nil
    $IMAGE_HASH[locale][image_type.to_sym] = image_identifier
  end
end
