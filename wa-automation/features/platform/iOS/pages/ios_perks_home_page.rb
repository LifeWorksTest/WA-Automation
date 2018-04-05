require 'calabash-cucumber/ibase'

class IOSPerksHomePage < Calabash::IBase
  BTN_ALL_PERKS = "UIButtonLabel marked: 'All Perks'"


  LBL_PERKS = "UILabel marked:'Perks'"
  LBL_WAYS_TO_SAVE = "UILabel marked:'Ways To Save'"

  def trait
    LBL_PERKS
  end

  def navigate_to_a_page (page)
  	wait_for(:timeout => 30,:post_timeout => 1){element_exists(BTN_ALL_PERKS)}
  	touch(BTN_ALL_PERKS)
  	wait_for(:timeout => 30,:post_timeout => 1){element_does_not_exist(BTN_ALL_PERKS)}
  	wait_for(:timeout => 30,:post_timeout => 1){element_exists("UILabel marked: '#{page}'")}
  	touch("UILabel marked: '#{page}'")
  	wait_for(:timeout => 30,:post_timeout => 1){element_does_not_exist(LBL_WAYS_TO_SAVE)}
  end 	 	
end