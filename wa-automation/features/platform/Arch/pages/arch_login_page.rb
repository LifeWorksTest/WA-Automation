# -*- encoding : utf-8 -*-
class ArchLoginPage
        
  def initialize (browser)
  	@BROWSER = browser
    @BROWSER.goto $ARCH

    @BROWSER.send_keys [:command, :subtract]*20
    @BROWSER.send_keys [:command, :add]*1
    sleep(2)
  end

  def is_visible (page)
  	case page
  	when 'login'
  		@BROWSER.input(:placeholder, 'Email address').wait_until_present
    	@BROWSER.input(:placeholder, 'Password').wait_until_present
  	end
  end

  def login (email, password)
  	@BROWSER.input(:placeholder, 'Email address').send_keys email
  	@BROWSER.input(:placeholder, 'Password').send_keys password

    click_button('Sign in')
  end

  def click_button (button)
  	case button
  	when 'Sign in'
  		@BROWSER.button(:class, 'btn btn-lg btn-primary btn-block').wait_until_present
  		@BROWSER.button(:class, 'btn btn-lg btn-primary btn-block').click
  		@BROWSER.button(:class, 'btn btn-lg btn-primary btn-block').wait_while_present
  	end 
  end
 end
