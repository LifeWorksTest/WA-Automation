# -*- encoding : utf-8 -*-
class ZeusCompanyPage

  def initialize (browser)
    @BROWSER = browser
  end

  # Change state of badge by the given state and index
  # @param change_state_to - 'ON' or 'OFF'
  # @param badge_name 
  def change_state_of_badge (change_state_to, badge_name)
    @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).wait_until_present
    @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'badge-list-item').wait_until_present
   
    if change_state_to == 'ON'
      if @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'badge-list-item disabled').exists?
        @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'center-block').label.click
        @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'badge-list-item disabled').wait_while_present
      end
    elsif change_state_to == 'OFF'
  
      if ! @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'badge-list-item disabled').exists?
        @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'center-block').label.click
        @BROWSER.h4(:class => 'text-center text-semibold', :text => badge_name).parent.parent.div(:class, 'badge-list-item disabled').wait_until_present
      end
    end
  end
  
  def check_if_badge_exists (badge_name, badge_description, exists_or_not)
    @BROWSER.div(:class, 'container badge-library ng-scope').wait_until_present
    if exists_or_not == "exists"
      @BROWSER.h4(:text, /#{badge_name}/).parent.div(:class => 'badge-list-item-description', :text => /#{badge_description}/).wait_until_present
    elsif exists_or_not == "not exists"
      if  @BROWSER.h4(:text, /#{badge_name}/).exists?
       fail (msg = "Error. check_if_badge_exists. Badge #{badge_name} was not expected to be exists in badge list")
      end
    end
  end
end
 
