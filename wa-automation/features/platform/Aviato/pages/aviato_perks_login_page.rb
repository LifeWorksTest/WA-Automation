# -*- encoding : utf-8 -*-
class AviatoPerksLoginPage
  def initialize (browser)
    @BROWSER = browser
    @BROWSER.goto $AVIATO

    @TXF_EMAIL = @BROWSER.input(:name, 'email')
    @TXF_PASSWORD = @BROWSER.input(:name, 'password')

    @BTN_LOGIN = @BROWSER.button(:text, 'Log In')
  end

  def is_visible
  	@BROWSER.form.wait_until_present
  	@TXF_EMAIL.wait_until_present
  	@TXF_PASSWORD.wait_until_present
  end

  # Login
  # @param - email
  # @param - password
  def login (email, password, country_code)
  	@TXF_EMAIL.wait_until_present
  	@TXF_PASSWORD.wait_until_present

  	@TXF_EMAIL.send_keys email
  	@TXF_PASSWORD.send_keys password

    @BTN_LOGIN.wait_until_present
    @BTN_LOGIN.click

    @BROWSER.h1(:text, 'Select Country').wait_until_present
    @BROWSER.div(:class => 'ui form', :text => /Canada\nUnited States\nUnited Kingdom/).wait_until_present
    @BROWSER.input(:id, country_code).click
    @BROWSER.div(:class, 'ui search selection dropdown fluid').i(:class, /flag #{country_code}/i).wait_until_present
  end
end
