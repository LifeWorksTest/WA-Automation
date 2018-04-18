# -*- encoding : utf-8 -*-
require 'calabash-android/abase'

class AndroidCinemasPage < Calabash::ABase
  TXV_CINEMAS = "AppCompatTextView marked:'Cinemas'"
  
  BTN_BUY_NOW = "android.widget.Button marked:'Buy Now'"
  BTN_LOCATION_SELECT = "AppCompatCheckedTextView index:0"
  BTN_CHOOSE_LOCATION = "AppCompatTextView id:'view_cinema_details_pick_location_spinner'"
  BTN_REMOVE = "AppCompatTextView marked:'Remove'"
  BTN_PAY_WITH_CARD = "AppCompatButton id:'fragment_checkout_pay_button'"
  BTN_CLOSE = "android.widget.ImageButton"
 

  def trait
    TXV_CINEMAS
  end

  # Purchase cinema tickets
  # @param cinema_name
  # @param cinema_location
  # @param purchase_order_array - 2 dimension array of tickets to purchase and amounts
  def purchase_ticket (cinema_name, cinema_location, purchase_order_array)
    @CINEMA_NAME = cinema_name
    
    wait_poll(:until_exists => "AppCompatTextView marked:'#{cinema_name}'", :timeout => 15) do
      scroll("android.support.v7.widget.RecyclerView", :down)
    end
    
    wait_for_elements_exist("AppCompatTextView marked:'#{cinema_name}'")
    touch ("AppCompatTextView marked:'#{cinema_name}'")

    wait_for(:timeout => 30,:post_timeout => 2){element_exists("AppCompatTextView marked:'#{cinema_name}'")}

    choose_cinema_location(cinema_name)
    select_ticket(purchase_order_array)
    touch(BTN_BUY_NOW)
    checkout(cinema_name, cinema_location,purchase_order_array)
    conformation(cinema_name, cinema_location,purchase_order_array) 
  end

  # Choose location screen
  # @param cinema_location
  def choose_cinema_location(cinema_location)
    wait_for(:timeout => 30,:post_timeout => 2){element_exists(BTN_CHOOSE_LOCATION)}
    touch(BTN_CHOOSE_LOCATION)
    wait_for(:timeout => 30,:post_timeout => 2){element_exists(BTN_LOCATION_SELECT)}
    touch(BTN_LOCATION_SELECT)
  end

  # Select tickets and amount
  # @param purchase_order_array - holds the ticket type and the quantity
  def select_ticket(purchase_order_array)

    purchase_order_array.each do |amount,ticket_type|
      puts "amount:#{amount}  ticket_type:#{ticket_type}"

      wait_poll(:retry_frequency => 0.5, :until_exists => "AppCompatTextView marked:'#{ticket_type}'", :timeout => 30) do
        scroll("android.support.v7.widget.RecyclerView", :down)
      end

      touch("AppCompatTextView marked:'#{ticket_type}' parent * index:0 descendant * marked:'view_cinema_ticket_counter_minus'")

      for i in 0..amount
        touch("AppCompatTextView marked:'#{ticket_type}' parent * index:0 descendant * marked:'view_cinema_ticket_counter_add'")
      end
    end
  end


  # Complete conformation screen
  # @param cinema_name
  # @param cinema_location
  # @param purchase_order_array
  def checkout(cinema_name, cinema_location, purchase_order_array)
    
    wait_for(:timeout => 30,:post_timeout => 2){element_exists("AppCompatEditText")}

    @user_email = query("AppCompatEditText id:'fragment_checkout_email_edit_text'")

    if @user_email == ''
      fail('Error. checkout. User email is blank')
    end


    if element_exists("SavedCardView marked:'fragment_checkout_saved_card_view'")  
      touch(BTN_REMOVE)
      wait_for_elements_exist("DialogTitle marked:'Remove card details'")
      touch("AppCompatButton id:'button1'")
      scroll("android.support.v4.widget.NestedScrollView", :down)
    end

    wait_for_elements_exist(BTN_PAY_WITH_CARD)
    insert_card_details
    touch(BTN_PAY_WITH_CARD)  
    sleep(4) 
  end

  # Insert card details
  def insert_card_details
    
    enter_text("android.widget.EditText id:'fragment_checkout_email_edit_text'", 'lifeworkstesting+uk@workivate.com')
    hide_soft_keyboard

    enter_text("android.widget.EditText id:'view_credit_card_layout_card_number_edit_text'", '4242424242424242')
    hide_soft_keyboard
    

    enter_text("android.widget.EditText id:'view_credit_card_layout_card_month_edit_text'", '11')
    hide_soft_keyboard

    enter_text("android.widget.EditText id:'view_credit_card_layout_card_year_edit_text'", '20')
    hide_soft_keyboard

    enter_text("android.widget.EditText id:'view_credit_card_layout_card_cvc_edit_text'", '123')
    hide_soft_keyboard
  end

  # Complete conformation screen
  # @param cinema_name
  # @param cinema_location
  # @param purchase_order_array
  def conformation(cinema_name, cinema_location,purchase_order_array)
    
    element_exists("AppCompatTextView index:3")
    order_id_label = query("AppCompatTextView index:3",:text)[0]
    order_id_label = (/[^.]*/.match order_id_label)[0].sub("AppCompatTextView index:3 text: [0][0,9]",'')
    

    if order_id_label == ""
      fail(msg = 'Error. confirmation. Order ID was empty')
    end
  end
end
