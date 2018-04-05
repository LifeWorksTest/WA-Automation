class AviatoPerksMenuPage
	def initialize (browser)
		@BROWSER = browser
	end

	def click_button (button)
		case button
		when 'Gift Cards'
			@BROWSER.a(:class => /item/, :text => button).wait_until_present
			@BROWSER.a(:class => /item/, :text => button).click
			@BROWSER.h1(:text, 'Gift Cards').wait_until_present
		end
	end

  # Logout
  def logout
    @BROWSER.a(:text, 'Logout').wait_until_present
    @BROWSER.a(:text, 'Logout').click
    @BROWSER.a(:text, 'Logout').wait_while_present
    @BROWSER.button(:text, 'Log In').wait_until_present
  end
end