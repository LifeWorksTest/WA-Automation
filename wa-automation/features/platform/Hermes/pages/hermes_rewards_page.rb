# -*- encoding : utf-8 -*-
class WebAppRewardsPage
  def initialize (browser)
    @BROWSER = browser
  	@BTN_AVAILABLE_REWARDS = @BROWSER.div(:text, HERMES_STRINGS["rewards"]["available_reward"]["title_2"])
  	@BTN_REDEEMED = @BROWSER.div(:text, HERMES_STRINGS["rewards"]["redeemed_reward"]["redeemed"])
  	@BTN_CHOOSE_REWARD = @BROWSER.span(:text, HERMES_STRINGS["rewards"]["available_reward"]["choose_reward"])
  	@BTN_CHOOSE = @BROWSER.a(:text, HERMES_STRINGS["rewards_catalog"]["reward_offer"]["choose_btn"])
  	@BTN_INFO = @BROWSER.a(:text, HERMES_STRINGS["rewards_catalog"]["reward_offer"]["info_btn"])
  end

  def is_visible(page)
  	case page
  	when 'main'
  		@BTN_AVAILABLE_REWARDS.wait_until_present
  		@BTN_REDEEMED.wait_until_present
  	when 'Choose your reward'
  		@BROWSER.span(:text, HERMES_STRINGS["rewards"]["available_reward"]["title_2"]).wait_until_present
  	end
  end

  # Validate state of the Available Rewards screen
  # @param no_rewards_yet - boolean
  def available_rewards (no_rewards_yet)
  	if no_rewards_yet
       @BROWSER.div(:text, HERMES_STRINGS["rewards"]["available_reward"]["title"]).exists?
       @BROWSER.div(:text, HERMES_STRINGS["rewards"]["available_reward"]["subtitle"]).exists?
  	else 
  		@BROWSER.div(:text, /#{HERMES_STRINGS["rewards"]["available_reward"]["title_2"]}/).wait_until_present
  		@BROWSER.span(:text, HERMES_STRINGS["rewards"]["available_reward"]["rewarded"]).wait_until_present
  		@BTN_CHOOSE_REWARD.wait_until_present

      @available_rewards_amount = @BROWSER.span(:text, HERMES_STRINGS["rewards"]["available_reward"]["title_2"]).parent.span(:index, 1).span(:index, 1).text.to_i
      puts "available_rewards_amount:#{@available_rewards_amount}"

      i = 0 
      while @BROWSER.span(:text => HERMES_STRINGS["rewards"]["available_reward"]["rewarded"], :index => i).exists?
        i += 1

        if i % 3 == 0
          @BROWSER.div(:id, 'view').send_keys :space
          sleep(0.5)
        end
      end

      if i + 1 != @available_rewards_amount
        fail(msg = "Error. available_rewards. Expected to see #{@available_rewards_amount} in the reward list")
      end
  	end
  end

  def click_button (button)
  	case button 
  	when 'Available Rewards'
	  	@BTN_AVAILABLE_REWARDS.wait_until_present
	  	@BTN_AVAILABLE_REWARDS.click
      @BROWSER.div(:text, /#{HERMES_STRINGS["rewards"]["available_reward"]["title_2"]}/).wait_until_present
  	when 'Redeemed'
  		@BTN_REDEEMED.wait_until_present
  		@BTN_REDEEMED.click
      sleep(2)
      @BROWSER.div(:text, "#{HERMES_STRINGS["rewards"]["available_reward"]["choose_reward"][0..-4]}" + ':').wait_until_present
  	else
      fail(msg = "Error. click_button. The option #{button} is not defined in menu.")
    end
  end

  # Validate redeemed reward data
  def validate_redeemed_reward (retailer, amount)
    click_button('Redeemed')

    @BROWSER.div(:text, /#{HERMES_STRINGS["rewards"]["available_reward"]["title_2"]}/).span.wait_until_present
    amount_of_redeemed_rewards = (/\d+/.match (@BROWSER.div(:text, /#{HERMES_STRINGS["rewards"]["available_reward"]["title_2"]}/).span.text))[0].to_i
    i = 0

    while amount_of_redeemed_rewards > i 
      latest_redeemed_reward = @BROWSER.div(:text => 'Rewarded:', :index => i).parent.parent.text
      
      expected_redeemed_reward_value = "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}" + 
          "#{amount}" + "\n" + "#{HERMES_STRINGS["rewards"]["available_reward"]["rewarded"][0..-4]}" + ':' + "\n" + 
          "#{Time.now.strftime("%d/%m/%Y")}" + "\n" + HERMES_STRINGS["rewards"]["available_reward"]["choose_reward"][0..-4] + ':' + 
          "\n" + "#{retailer}" + "\n" + "#{HERMES_STRINGS["rewards"]["available_reward"]["redeemed"]}" + 
          "\n" + "#{HERMES_STRINGS["rewards"]["available_reward"]["on"]}" + "#{Time.now.strftime("%d/%m/%Y")}"
      
      if expected_redeemed_reward_value == latest_redeemed_reward
        return
      end

      i += 1
      if i % 3 == 0
        @BROWSER.div(:id, 'view').send_keys :space
        sleep(0.5)
      end
    end

    fail("Error. validate_redeemed_reward. Expecting for:#{expected_redeemed_reward_value}\nFound:#{latest_redeemed_reward}")
  end

  # Choose reward stpes
  # @param retailer
  # @param amount_expected
  def choose_reward (retailer, amount_expected)
    #set_redeemed_rewards_amount
    click_button('Available Rewards')
    @BROWSER.a(:class => 'btn btn--flat', :index => 0).parent.span(:text => /#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{amount_expected}/).wait_until_present
    @BROWSER.a(:class => 'btn btn--flat', :index => 0).i(:class, 'icon-web_arrow_right').click
    choose_your_reward(retailer, amount_expected)
    click_button('Available Rewards')
  end

  # User choose his reward
  # @param retailer
  # @param amount_expected
  def choose_your_reward (retailer, amount_expected)
    @BROWSER.div(:text, /#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{amount_expected}/).wait_until_present
    @BROWSER.div(:text, /Available Rewards/).wait_until_present
    @BROWSER.a(:class => 'btn btn--flat').parent.div(:text => /#{retailer}/).parent.a(:index => 1).wait_until_present
    sleep(2)
    @BROWSER.a(:class => 'btn btn--flat').parent.div(:text => /#{retailer}/).parent.a(:index => 1).click

    @BROWSER.div(:text, /#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_sign]}#{amount_expected}/).wait_until_present
    sleep(2)
    
    @BROWSER.button(:text => 'Confirm', :index => 0).wait_until_present
    @BROWSER.button(:text => 'Confirm', :index => 0).click
    @BROWSER.div(:text, "£#{amount_expected}").wait_until_present
    @BROWSER.div(:text, "#{Date.today.strftime("%d/%m/%Y")}").wait_until_present
    @BROWSER.div(:text, "on #{Date.today.strftime("%d/%m/%Y")}").wait_until_present
    @BROWSER.a(:text, "#{retailer}").wait_until_present
    @BROWSER.div(:text, "Redeemed").wait_until_present
  end
  
end
