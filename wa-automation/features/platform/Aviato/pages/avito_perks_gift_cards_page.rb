# -*- encoding : utf-8 -*-
class AviatoPerksGiftCardsPage
  def initialize (browser)
    @BROWSER = browser

    @BTN_SEARCH = @BROWSER.input(:id, 'input-search')
    @BTN_SAVE_ENABLE = @BROWSER.button(:text, 'Save and enable')

    @BROWSER.send_keys [:command, :subtract]*10
  end

  def is_visible (page)
    case page
    when 'main'
      @BROWSER.h1(:text, 'Gift Cards').wait_until_present
      @BTN_SEARCH.wait_until_present
      @BROWSER.table(:class, 'ui celled table selectable').wait_until_present
      @BROWSER.table(:class, 'ui celled table selectable').tr(:text, /Merchant Categories Status Actions/).wait_until_present
      Watir::Wait.until {@BROWSER.table(:class, 'ui celled table selectable').tbody.trs.count > 3}
    when 'edit'
      @BROWSER.h2.wait_until_present
      @BROWSER.h5(:text, /Provided by/).wait_until_present
      @BROWSER.div(:text, 'English').wait_until_present
      @BROWSER.input(:id, 'input-:title').wait_until_present
      @BROWSER.textarea(:id, 'input-:description').wait_until_present
      @BROWSER.textarea(:id, 'input-:terms_and_conditions').wait_until_present
      @BROWSER.div(:class, /ui search selection dropdown fluid multiple/).i.wait_until_present
      @BROWSER.input(:id, 'input-:discount_tier_1').wait_until_present
      @BROWSER.input(:id, 'input-:discount_tier_2').wait_until_present
      @BTN_SAVE_ENABLE.wait_until_present
    end
  end

  # Select Gift Card from table by index
  # @param index
  def open_by_index (index)
    puts "index:#{index}"
    @BROWSER.tbody.tr(:index, index - 1).td.wait_until_present
    Watir::Wait.until { @BROWSER.tbody.tr(:index, index - 1).td.text.size > 0 }

    gift_card_name = @BROWSER.tbody.tr(:index, index - 1).td.text
    @BROWSER.tbody.tr(:index, index - 1).click

    FileService.new.insert_to_file('current_gift_card:', gift_card_name)
    @BROWSER.h2(:text,gift_card_name).wait_until_present
  end

  # @param gift_card_name
  # @param gift_card_exists - if gift card is exists in the DB or not.
  def search_for_gift_card (gift_card_name, gift_card_exists = true)
    @BROWSER.input(:id, 'input-search').wait_until_present
    @BROWSER.input(:id, 'input-search').send_keys gift_card_name
    @BROWSER.thead(:text, /Merchant Categories Status Actions/).wait_until_present

    if gift_card_exists
      @BROWSER.td(:text, gift_card_name).wait_until_present
      @BROWSER.td(:text, gift_card_name).click
      @BROWSER.h2(:text,gift_card_name).wait_until_present
      is_visible('edit')
    else
       @BROWSER.td(:text, 'No results').wait_until_present
    end
  end

  # Edit Gift Card with random info
  def edit_gift_card_page
    @BROWSER.textarea(:id, 'input-:description').to_subtype.clear
    @BROWSER.textarea(:id, 'input-:description').send_keys description = "description #{rand(36**6).to_s(36)}"

    @BROWSER.file_field.set eval(IMAGE_FILES[:giftcard][:png])
    @BROWSER.button(:class, 'ui blue button').wait_until_present
    @BROWSER.button(:class, 'ui blue button').click
    @BROWSER.button(:class, 'ui blue button').wait_while_present

    # If there are any categories that are already selected, then remove them
    (@BROWSER.as(:class, 'ui label').map &:text).each { |category_to_delete| 
      @BROWSER.a(:class => 'ui label', :text => category_to_delete).parent.i(:class, 'delete icon').fire_event('click') 
      @BROWSER.a(:class => 'ui label', :text => category_to_delete).wait_while_present 
    }

    # Picks a random category from the category dropdown
    @BROWSER.div(:class, /ui search selection dropdown fluid multiple/).i.fire_event('click') 
    @BROWSER.div(:class, 'menu transition visible').wait_until_present
    Watir::Wait.until { @BROWSER.div(:class, 'menu transition visible').divs(:class, 'item').count > 1 }
    category = (@BROWSER.div(:class, 'menu transition visible').divs(:class, 'item').map &:text).sample  
    @BROWSER.div(:class => 'item', :text => category).wait_until_present
    @BROWSER.div(:class => 'item', :text => category).fire_event('click')
    @BROWSER.a(:class => 'ui label transition visible', :text => category).wait_until_present
    @BROWSER.div(:class, /ui search selection dropdown fluid multiple/).i.click
    @BROWSER.div(:class, 'menu transition visible').wait_while_present

    @BROWSER.textarea(:id, 'input-:terms_and_conditions').wait_until_present
    @BROWSER.textarea(:id, 'input-:terms_and_conditions').to_subtype.clear
    @BROWSER.textarea(:id, 'input-:terms_and_conditions').send_keys terms_and_conditions = "terms_and_conditions #{rand(36**6).to_s(36)}"
    Watir::Wait.until { @BROWSER.textarea(:id, 'input-:terms_and_conditions').value == terms_and_conditions }

    # Select 2 random amountst between 1 and 20 and put them in an array so that there is no chance of tier 1 or 2 being the same amount
    (10..30).to_a.sample(2).each_with_index { |amount, i| 
      @BROWSER.input(:id, "input-:discount_tier_#{i + 1}").to_subtype.clear
      @BROWSER.input(:id, "input-:discount_tier_#{i + 1}").send_keys instance_variable_set("@tier_#{i + 1}_value", amount)
    }

    @BTN_SAVE_ENABLE.click

    @BROWSER.p(:text, 'Your Gift Card has been enabled.').wait_until_present
    @BROWSER.p(:text, 'Your Gift Card has been enabled.').wait_while_present 

    $GIFT_CARD_HASH = {:description => description, :terms_and_conditions => terms_and_conditions, :category => category, :tier_1 => @tier_1_value, :tier_2 => @tier_2_value}
  end

  def enable_disable_giftcard (index, enabled_disabled)
    @BROWSER.tbody.tr(:index, index - 1).td.wait_until_present
    Watir::Wait.until { @BROWSER.tbody.tr(:index, index - 1).td.text.size > 0 }
    gift_card_name = @BROWSER.tbody.tr(:index, index - 1).td.text
    category = @BROWSER.tbody.tr(:index, index - 1).td(:index, 1).span.text.split(',').first
    $GIFT_CARD_HASH = {:gift_card_name => gift_card_name, :category => category, :enabled_disabled => enabled_disabled}

    if ! @BROWSER.tbody.tr(:index, index - 1).div(:class, 'ui toggle checkbox').input(:id => /input-gift-card/, :class => enabled_disabled).present?
      @BROWSER.tbody.tr(:index, index - 1).div(:class, 'ui toggle checkbox').input(:id, /input-gift-card/).click
      @BROWSER.tbody.tr(:index, index - 1).div(:class, 'ui toggle checkbox').input(:id => /input-gift-card/, :class => enabled_disabled).wait_until_present
    end
  end
end