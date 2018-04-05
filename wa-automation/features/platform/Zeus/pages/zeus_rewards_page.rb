# -*- encoding : utf-8 -*-
class ZeusRewardPage
  def initialize (browser)
    @BROWSER = browser
    @BTN_REWARD_COLLEAGUE = @BROWSER.a(:text, ZEUS_STRINGS["rewards"]["give"]["reward_btn"])
    @BTN_DOWNLOAD = @BROWSER.a(:text, ZEUS_STRINGS["rewards"]["history_panel"]["download_btn"])
    @BTN_SEARCH = @BROWSER.i(:class, 'icon-search-small')
    @BTN_BACK = @BROWSER.span(:text, ZEUS_STRINGS["rewards"]["give_modal"]["back_btn"])
    @BTN_CANCEL = @BROWSER.a(:text, ZEUS_STRINGS["rewards"]["give_modal"]["cancel"])
    @BTN_NEXT = @BROWSER.a(:text, ZEUS_STRINGS["rewards"]["give_modal"]["next"])
    @BTN_REWARD = @BROWSER.a(:text, ZEUS_STRINGS["rewards"]["give_modal"]["reward"])
  end

  def is_visible(page)
    @BROWSER.div(:text, 'Remaining budget').wait_until_present
    @BROWSER.span(:class, 'title-3').wait_until_present
    
    if @BROWSER.span(:class, 'title-3').text.to_i == 0
      @BROWSER.div(:class => %w(caption-3 text-error), :text => 'To be able to issue rewards you need to add funds to your budget')
    end
    
    @BROWSER.div(:text, 'Add Funds').wait_until_present
    @BROWSER.div(:class => 'caption-1', :text => ZEUS_STRINGS["rewards"]["widget"]["add_funds"]).wait_until_present
    
    case page  
    when 'main'   
      @BROWSER.tr(:class, 'body-3').td(:text => /#{ZEUS_STRINGS["rewards"]["history_panel"]["download_history"]}/).wait_until_present
      #TO ADD THE TABLE
    when 'reward a colleague'
      @BROWSER.span(:text, ZEUS_STRINGS["rewards"]["rewarding_panel"]["title"]).wait_until_present
      @BTN_BACK.wait_until_present
      sleep(1)

      if @BROWSER.div(:text, ZEUS_STRINGS["rewards"]["first_visit_bubble"]["title"]).exists?
        @BROWSER.i(:class, 'icon-close2').click
        @BROWSER.i(:class, 'icon-close2').wait_while_present
      end

    end
  end

  def click_button(button)
    case button
    when 'Reward Colleague'
      @BTN_REWARD_COLLEAGUE.wait_until_present
      @BTN_REWARD_COLLEAGUE.click
      @BTN_REWARD_COLLEAGUE.wait_while_present
      #is_visible('reward a colleague')
    when 'Download'
      @BTN_DOWNLOAD.wait_until_present
      @BTN_DOWNLOAD.click
      @BTN_DOWNLOAD.wait_while_present
    when 'Reward'
      @BTN_REWARD.wait_until_present
      @BTN_REWARD.click
    when 'Next'
      @BTN_NEXT.wait_until_present
      @BTN_NEXT.click
      @BTN_REWARD.wait_until_present
    end
  end

  # Select user to reward
  # @param user_name
  def select_user_to_reward(user_name)
    puts "user_name #{user_name}"
    click_button('Reward Colleague')
    @BROWSER.i(:class, 'icon-close2').wait_until_present
    @BROWSER.i(:class, 'icon-close2').click
    @BROWSER.a(:text, user_name).parent.parent.a(:class, %w(btn btn-primary)).wait_until_present
    sleep(2)
    @BROWSER.a(:text, user_name).parent.parent.a(:class, %w(btn btn-primary)).hover
    @BROWSER.a(:text, user_name).parent.parent.a(:class, %w(btn btn-primary)).click
  end

  # Reward colleague
  # @param user_name
  # @param amount
  def reward_colleague(user_name, amount)
    set_remaining_budget

    @BROWSER.div(:class => 'title-2', :text => ZEUS_STRINGS["rewards"]["give_modal"]["send_to"]).wait_until_present
    @BROWSER.div(:class => 'title-2', :text => user_name).wait_until_present
    sleep(1)
    puts "amount #{amount}"
    @BROWSER.div(:class, %w(caption-3 text-dark)).parent.div(:text,/#{amount}/).wait_until_present
    @BROWSER.div(:class, %w(caption-3 text-dark)).parent.div(:text,/#{amount}/).click

    remaining_money = @BROWSER.div(:class, %w(caption-2 text-dark)).text.split(ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]).last
    remaining_new_budget = (((@BROWSER.div(:class, %w(caption-2 text-dark)).text.split(ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]).last).scan(/\d+/).join().to_i)/100).to_f
    reward_amount = amount.to_f 
    if remaining_new_budget != ($remaining_budget - reward_amount).to_f
      fail(msg = "Error reward_colleague. Remaining budget does not match with the exisiting budget - reward amount")
    end    

    click_button('Next')
    @BROWSER.div(:class, 'title-2').wait_until_present
    @BROWSER.div(:class => 'title-2', :text => user_name).wait_until_present
    @BROWSER.div(:class => %w(display-3 text-action), :text => /#{amount}/).wait_until_present
    @BROWSER.div(:class, 'modal-content').a(:class, %w(btn btn-primary)).click
    @BROWSER.span(:class => 'title-3',:text => /#{remaining_money}/).wait_until_present
  end

  # Set remaining budget
  def set_remaining_budget
    $remaining_budget = (((@BROWSER.div(:class, %w(caption-2 text-dark)).text.split("£").last).scan(/\d+/).join().to_i)/100).to_f
    puts "remaining_budget:#{$remaining_budget}"
  end

  # Validate date in historic rewards
  # @param user_name 
  # @param admin_name 
  # @param amount
  # @param reward_state
  def validate_date_in_historic_rewards (user_name, admin_name, amount, reward_state)
    @BROWSER.tr(:text, /#{ZEUS_STRINGS["rewards"]["history_panel"]["download_history"]}/).wait_until_present
    table_headers = ZEUS_STRINGS["rewards"]["history_panel"]["date"] + ' ' +
      ZEUS_STRINGS["rewards"]["history_panel"]["recipient"]  + ' ' +
      ZEUS_STRINGS["rewards"]["history_panel"]["sender"] + ' ' +
      ZEUS_STRINGS["rewards"]["history_panel"]["value"]
    
    @BROWSER.tr(:text, /#{table_headers}/).wait_until_present
    @BROWSER.tr(:text, /#{Date.today.strftime("%d/%m/%Y")} #{user_name} #{admin_name} #{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{amount}.00 #{reward_state}/).wait_until_present
  end

  def validate_empty_state
    @BROWSER.span(:class => 'title-3', :text => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}0.00").wait_until_present
    @BROWSER.td(:text, /#{ZEUS_STRINGS["rewards"]["history_panel"]["appear_here"]}/).wait_until_present
  end
end
