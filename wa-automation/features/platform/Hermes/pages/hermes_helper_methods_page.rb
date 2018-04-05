class HermesHelperMethodsPage
  
  def initialize (browser)
    @BROWSER = browser
  end 

  def verify_external_redirection
    @BROWSER.windows.last.use 
    Watir::Wait.until {@BROWSER.title.length > 0 }
    external_page_title = @BROWSER.title
    external_page_title_string = @BROWSER.title.split("|").first[0..-2]
    puts "Current page title: #{external_page_title}"
    
    if external_page_title_string == "#{ACCOUNT[:"#{$account_index}"][:valid_account][:company_name]}"
      fail(msg = "Error. verify_external_redirection. External redirection failed. Current page title: #{external_page_title}.")
    end

    Watir::Wait.until(30) { !@BROWSER.url.include? 'about:blank' }
    @BROWSER.window.close
  end
end