# -*- encoding : utf-8 -*-
class ArchGiftCardsPage
	def initialize (browser)
    @BROWSER = browser
  end

	def is_visible
		@BROWSER.table(:class, %w(table table-striped table-hover table-with-header)).wait_until_present
	end

	def enable_disable_all_gift_card (on_off)
	    @BROWSER.table(:class, %w(table table-striped table-hover table-with-header)).wait_until_present
	    current_page = 1
	    @BROWSER.ul(:class, 'pagination').li(:text, "#{current_page + 1}").wait_until_present

	    while @BROWSER.ul(:class, 'pagination').li(:text, "#{current_page + 1}").exists?
	    	i = 0
	    	while @BROWSER.div(:class => 'bootstrap-switch-container', :index => i).exists?
	    		if on_off == "ON" && !@BROWSER.div(:class => 'bootstrap-switch-container', :index => i).input.checked?
	    			@BROWSER.div(:class => 'bootstrap-switch-container', :index => i).click
	    		elsif on_off == "OFF" && @BROWSER.div(:class => 'bootstrap-switch-container', :index => i).input.checked?
	    			@BROWSER.div(:class => 'bootstrap-switch-container', :index => i).click
	    		end

	    		sleep(0.2)
	    		i += 1
	    	end
	    	
	    	current_page += 1
	    	@BROWSER.ul(:class, 'pagination').a(:text, "#{current_page}").click
	    end
	end
end

