# -*- encoding : utf-8 -*-
require 'net/http'
require 'json'
require 'date'
require 'net/ssh'

class Api
  # Create request to the API
  # @param http_mathod
  # @param uri
  # @param parameters
  # @param user_token
  # @param api_version 
	def request_from_api (http_mathod, end_point , parameters = nil, user_token = nil, api_version = 'v1.3', resailer_key = false)
    uri = URI.parse("#{URL[:api]}" + '/' + "#{end_point}")

    case http_mathod  
		when 'Post'
			req = Net::HTTP::Post.new(uri.to_s)
		when 'Put'
			req = Net::HTTP::Put.new(uri.to_s)
		when 'Get'
			req = Net::HTTP::Get.new(uri.to_s)
		end
		
    req.add_field(API[:header][:accept], API[:version][:"#{api_version}"])
    
		if user_token != nil 
			req.add_field(API[:header][:wam_token], "#{user_token}")
		end

    if resailer_key
      req.add_field(API[:header][:reseller_key], 'orbit')
    end

		@payload = parameters.to_json

		req.body = @payload

    puts "**********API REQUESET***************"
    puts "Request URI:#{uri}"
    puts "Request body:#{req.body}"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(req)

    puts "**********API RESPONSE***************"
    puts "Response code:#{res.code}"
    puts "Response message:#{res.message}"
    puts "Response class.name:#{res.class.name}"
    puts "Response body.text:#{res.body}"
   
    result_json = res.body
		result_json = JSON.parse(res.body)

    puts "*******API RESPONSE JSON FORMAT******"
    puts "Response:#{result_json}"
    puts "*************************************"
		
    return result_json
	end

  # Get user
  # Get /users/user_id
  def get_user(user_id)
    end_point = "users/#{user_id}"
    result_json = request_from_api('Get', end_point, nil, nil, 'v1.4', true)

    if API[:print_response]
      puts "GET_USER:#{result_json}"
    end

    return result_json
  end

	# Allows a benefit app client application to obtain an request token
	# POST /auth/mobile
	def get_user_token(email = $current_user_email, password = ACCOUNT[:"#{$account_index}"][:valid_account][:password], return_all_object = false)
		parameters = {	
      "email" => "#{email}",
			"password" => "#{password}"
    }

		result_json = request_from_api('Post', 'auth/mobile', parameters)

    if API[:print_response]
      puts "GET_USER_TOEKN:#{result_json}"
    end
		
    if return_all_object
      result = result_json
    else
      result = result_json['body']['token']
    end
  
		return result
	end

	# Allows a admin panel client application to obtain an request token
	# POST /auth/admin-panel
	def get_admin_token(email, password, return_all_object = false)
		parameters = {	
      "email" => "#{email}",
			"password" => "#{password}"
    }

		result_json = request_from_api('Post', 'auth/admin-panel',parameters)
		
    if API[:print_response]
      puts "GET_ADMIN_TOEKN:#{result_json}"
    end

    if return_all_object
      result = result_json
    else
      result = result_json['body']['token']
    end
  
    return result
	end

	# Insert new wallet transaction (Set transaction status to Tracked)
	# POST /users/:user_id/wallet/transactions
	# @param user_id
	# @param date - purchase data in UNIX time
	# @param purchase_amount
	# @param cashback_earned
	def insert_transaction_cashback (provider, retailer_offer_id, user_id, date, purchase_amount, cashback_earned, merchant_name = nil)
    @provider = provider
    @retailer_offer_id= retailer_offer_id 
    @user_id = user_id
    @date = date 
    @purchase_amount = purchase_amount 
    @cashback_earned = cashback_earned
    @email = nil
    @merchant_name = merchant_name
  
    @order_id = DateTime.now.strftime('%s').to_i 
    @tran_id = @order_id + 1
  
    case provider
    when 'Incentive Networks'
      parameters = {	
  			"type" => 1,
  			"state" => 1,
  			"cashback" => {
  	    	"incentive_networks" => {
            "order_id" => @order_id,
            "retailer_id" => "#{@retailer_offer_id}",
            "transaction_history" => {
              "state" => "loaded",
              "reconcile_date" => "2015-01-26",
              "sale" => @purchase_amount.to_f / 100,
                "partner_member_id" => @user_id,
                "payment_eligible" => "0",
                "load_date" => "2014-11-26",
                "tranx_reconcile_id" => "18231312",
                "commission" => 1.23,
                "tx_date" => @date.to_i,
                "currency_id" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}",
                "browser_id" => "391037401",
                "tran_id" => @tran_id,
                "merchant_id" => "9058",
                "consumer_commission" => 1.23,
                "order_id" => @order_id,
                "merchant_name" => "#{@merchant_name}",
                "paid" => nil,
                "partner_commission" => @cashback_earned.to_f / 100,
                "reseller_commission" => "0.00",
                "is_fraud_review" => nil,
                "final_commission" => 1.23,
                "payment_eligible_date" => nil
            }
          },
  	     "share" => 1,
  	     "source" => 1,
  	     "wa_retain_cashback" => 0,
  	     "sale_price" => {
           	"amount" => @purchase_amount.to_i,
            "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
          }
  		  },
  		  "partner" => {
  		    "amount" => @cashback_earned.to_i,
  		    "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
  		  },
  		  "transaction_date" => @date.to_i,
      }
    when 'Bownty'
      parameters = { 
        "type" => 1,
        "state" => 1,
        "cashback" => {
          "bownty" => {
            "deal_id" => "#{retailer_offer_id}",
            "order_id" => @order_id,
            "bownty_commission" => {
                "amount" => 0,
                "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
            },
            "wa_commission" => {
                "unit" => "percentage",
                "amount" => 0,
                "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
            },
            "link_visited_time" => 1376130000,
            "validation_time" => 1376130000
          },
          "share" => 1,
          "source" => 3,
          "wa_retain_cashback" => 0,
          "sale_price" => {
            "amount" => purchase_amount.to_i,
            "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
          }
        },
        "partner" => {
          "amount" => (purchase_amount * 0.075).to_i,
          "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
        },
        "transaction_date" => date.to_i
      }
    when 'BAT'
      email = ACCOUNT[:"#{$account_index}"][:valid_account][:email]
      parameters = { 
        "type" => 1,
        "state" => 1,
        "cashback" => {
          "bat" => {
            "booking_id" => 123456,
            "booking_email" => email,
            "booking_reference" => "12fff3",
            "covers" => 2,
            "booking_time" => 1376130000,
            "restaurant_id" => "#{retailer_offer_id}"
          },
          "share" => 0,
          "source" => 2,
          "wa_retain_cashback" => 0,
          "sale_price" => {
            "amount" => purchase_amount.to_i,
            "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
          }
        },
        "partner" => {
          "amount" => cashback_earned.to_i,
          "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
        },
        "transaction_date" => date.to_i
      }
    end

    end_point = "users/#{user_id}/wallet/transactions"
    puts "Post 1.4"
    puts "#{end_point}"
    puts "#{parameters}"
    result_json = request_from_api('Post', end_point, parameters, nil, 'v1.4')
    
    if API[:print_response]
      puts "insert_transaction_cashback:#{result_json}"
    end

    puts "*****************#{user_id}"
    post_notify_user(user_id, result_json['body']['transaction_id'])

    return result_json
  end
	# Update wallet transaction
	# PUT /users/:user_id/wallet/transactions/:transaction_id
	# @param transaction_id
	def update_transaction_cashback (user_id, transaction_id, state = 2)
    if @provider == 'Incentive Networks'
      tran_id = DateTime.now.strftime('%s').to_i 
      
      if state == 4
        puts "DECLINE_STATE"
        decline = -1
      else 
        decline = 1
      end

      parameters = { 
        "type" => 1,
        "state" => state.to_i,
        "cashback" => {
          "incentive_networks" => {
            "order_id" => @order_id,
            "retailer_id" => "#{@retailer_offer_id}",
            "transaction_history" => {
              "state" => "payment_completed",
              "reconcile_date" => "2015-01-26",
              "sale" => @purchase_amount.to_f / 100 * decline,
              "partner_member_id" => @user_id,
              "payment_eligible" => "0",
              "load_date" => "2014-11-26",
              "tranx_reconcile_id" => "18231312",
              "commission" => 1.23,
              "tx_date" => @date.to_i,
              "currency_id" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}",
              "browser_id" => "391037401",
              "tran_id" => tran_id,
              "merchant_id" => "9058",
              "consumer_commission" => @cashback_earned.to_f / 100  * decline,
              "order_id" => @order_id,
              "merchant_name" => "#{@merchant_name}",
              "paid" => nil,
              "partner_commission" => @cashback_earned.to_f / 100 * decline,
              "reseller_commission" => "0.00",
              "is_fraud_review" => nil,
              "final_commission" => 1.23 * decline,
              "payment_eligible_date" => nil
            }
          },
         "share" => 1,
         "source" => 1,
         "wa_retain_cashback" => 0,
         "sale_price" => {
            "amount" => @purchase_amount.to_i,
            "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
          }
        },
        "partner" => {
          "amount" => @cashback_earned.to_i,
          "currency" => "#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}"
        },
        "transaction_date" => @date.to_i,
      }
    else
      parameters = { 
        "state" => state.to_i
      }
    end
  	  
		end_point = "users/#{user_id}/wallet/transactions/#{transaction_id}"

		result_json = request_from_api('Put', end_point, parameters, nil, 'v1.4')
		
    if API[:print_response]
      puts "UPDATE_TRANSACTION_CASHBACK: #{result_json}"
    end

    post_notify_user(user_id, transaction_id)
    @user_id = user_id
		
    return result_json
	end

	# Approve or decline a withdrawal transaction, edit note
	# PUT /internal/user/wallet/transaction/withdraw/5318933f9a816d896f0_TEST/approve
	# @param transaction_id
	# @param approve_or_decline - 'approve' or 'decline'
	def approve_or_decline_withdraw (transaction_id, approve_or_decline)
		parameters = {
	    "actionned_by_arch_user_id_ref" => "53072db129c48cc07f3cb634",
	    "paypal_ref" => "PAYPAL123"
		}

		end_point = "internal/user/wallet/transaction/withdraw/#{transaction_id}/#{approve_or_decline}"
		puts "#{end_point}"
		result_json = request_from_api('Put', end_point, parameters)
		
    if API[:print_response]
      puts "APPROVE_OR_DECLINE_WITHDRAW:#{result_json}"
    end

    post_notify_user(@user_id, transaction_id)

		return result_json
	end

	# Create user withdrawal 
	# POST /user/wallet/withdraw
	# @param password
	# @param email
	# @param method - 'Paypal' or 'Bank account'
	def create_user_withdrawal (email, password, method, user_token)
		parameters = { 
			"password" => "#{password}",
			"method" => "#{method}",
			"paypal_email" => "#{email}"
		}

		end_point = 'user/wallet/withdraw'
		result_json = request_from_api('Post', end_point, parameters, user_token)
		
    if API[:print_response]
      puts "CREATE_USER_WITHDRAWAL:#{result_json}"
    end

		if result_json['error'] != nil
			return result_json['error']['message']
		else
      post_notify_user(@user_id, result_json['body']['transaction_id'])
			return result_json['body']['transaction_id']
		end
	end

  def approve_users (user_token)
    end_point = 'admin-panel/user/awaiting-approval/approve'
    parameters = { }
    result_json = request_from_api('Put', end_point, parameters, user_token)

    if API[:print_response]
      puts "POST_APPROVE_USERS:#{result_json}"
    end

    if result_json['error'] != nil
      return result_json['error']['message']
    else
      post_notify_user(@user_id, result_json['body']['transaction_id'])
      return result_json['body']['transaction_id']
    end
  end

  # Get user transactions list
  # @param user_token
  # @param get_latest_transaction_id - if not true return all transactions
  def get_user_transaction (user_token, get_latest_transaction_id = false)
    parameters = {}

    end_point = 'user/wallet/transaction'
    result_json = request_from_api('Get', end_point, parameters, user_token)
    
    if API[:print_response]
      puts "GET_USER_TRANSACTION:#{result_json}"
    end

    if get_latest_transaction_id
      return result_json['body'][0]['transaction_id']
    else
      return result_json
    end
  end

  # Update company analystics
  # @param company_id
	def update_company_analystics (company_id)
    end_point = "internal/company/#{company_id}/analytics?force=1"    
    parameters = {}
    result_json = request_from_api('Post', end_point, parameters, nil)  
    
    if API[:print_response]
      puts "UPDATE_COMPANY_ANALYSTICS:#{result_json}"
    end

    return result_json
  end

  # Update company feature keys
  # @param company_id
  # @param package_id
  # @param true_or_false - feature key value True or False

  def set_all_company_features (company_id, package_id, true_or_false = true, perks_cashback_value_array = nil )
    # TODO: to complete logic for the rest of the Perks section e.g BAT, Bownty ...
    if perks_cashback_value_array != nil
      base_cashback_in = perks_cashback_value_array['benefit_cashback_base_incentive_networks_multiple_proc']
      bonus_cashback_in = perks_cashback_value_array['benefit_cashback_bonus_incentive_networks_multiple_proc']
    else
      base_cashback_in = 1
      bonus_cashback_in = 1
    end

    parameters = { 
      "package" => {
        "display_name" => "Enterprise",
        "description" => ""
      },
      "price" => {
        "amount" => 0,
        "currency" => ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]
      },
      "features" => {
       # "employee_id" => {
        #  "key" => "employee_id", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        #}, 
        "benefit" => {
          "key" => "benefit", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_online_shop" => {
          "key" => "benefit_online_shop", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_cashback_base_incentive_networks_multiple_proc" => {
          "key" => "benefit_cashback_base_incentive_networks_multiple_proc", "value" => base_cashback_in, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_cashback_bonus_incentive_networks_multiple_proc" => {
          "key" => "benefit_cashback_bonus_incentive_networks_multiple_proc", "value" => bonus_cashback_in, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_online_shop_special_terms" => {
          "key" => "benefit_online_shop_special_terms", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_gift_card" => {
          "key" => "benefit_gift_card", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_gift_card_shipping" => {
          "key" => "benefit_gift_card_shipping", "value" => true, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => true
        }, 
        "benefit_gift_card_feed" => {
          "key" => "benefit_gift_card_feed", "value" => "premium", "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => true
        }, 
        "benefit_gift_card_digital" => {
          "key" => "benefit_gift_card_digital", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_gift_card_physical" => {
          "key" => "benefit_gift_card_physical", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_restaurant" => {
          "key" => "benefit_restaurant", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_restaurant_bat" => {
          "key" => "benefit_restaurant_bat", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_cashback_base_book_a_table_multiple_proc" => {
          "key" => "benefit_cashback_base_book_a_table_multiple_proc", "value" => 1, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_restaurant_hilife" => {
          "key" => "benefit_restaurant_hilife", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_restaurant_spend" => {
          "key" => "benefit_restaurant_spend", "value" => true, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => true
        }, 
        "benefit_cinema" => {
          "key" => "benefit_cinema", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_cinema_pricing_tier" => {
          "key" => "benefit_cinema_pricing_tier", "value" => 2, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => true
        }, 
        "benefit_local_deal" => {
          "key" => "benefit_local_deal", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        },
        "benefit_cashback_base_bownty_multiple_proc" => {
          "key" => "benefit_cashback_base_bownty_multiple_proc", "value" => 1, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_cashback_bonus_bownty_multiple_proc" => {
          "key" => "benefit_cashback_bonus_bownty_multiple_proc", "value" => 1, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_colleague_offer" => {
          "key" => "benefit_colleague_offer", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_in_store_offer" => {
          "key" => "benefit_in_store_offer", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "benefit_in_store_offer_spend" => {
          "key" => "benefit_in_store_offer_spend", "value" => true, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => true
        }, 
        "social" => {
          "key" => "social", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed" => {
          "key" => "social_feed", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_post" => {
          "key" => "social_feed_post", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_comment" => {
          "key" => "social_feed_comment", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_new_user" => {
          "key" => "social_feed_new_user", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_birthday_user" => {
          "key" => "social_feed_birthday_user", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_anniversary" => {
          "key" => "social_feed_anniversary", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_birthday_company" => {
          "key" => "social_feed_birthday_company", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_milestone_user" => {
          "key" => "social_feed_milestone_user", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_feed_most_recognized" => {
          "key" => "social_feed_most_recognized", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_colleague_directory" => {
          "key" => "social_colleague_directory", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_recognition" => {
          "key" => "social_recognition", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "social_recognition_leaderboard" => {
          "key" => "social_recognition_leaderboard", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "multilingual_emails" => {
          "key" => "multilingual_emails", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "wallet" => {
          "key" => "wallet", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "wallet_withdraw_method_bacs" => {
          "key" => "wallet_withdraw_method_bacs", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "wallet_withdraw_bacs_fee_amount" => {
          "key" => "wallet_withdraw_bacs_fee_amount", "value" => 0, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "wallet_withdraw_method_paypal" => {
          "key" => "wallet_withdraw_method_paypal", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "wallet_withdraw_paypal_fee_amount" => {
          "key" => "wallet_withdraw_paypal_fee_amount", "value" => 0, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "grouping" => {
          "key" => "grouping", "value" => 0, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap" => {
          "key" => "eap", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_assistance" => {
          "key" => "eap_assistance", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_wellness" => {
          "key" => "eap_wellness", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_dependant_accounts" => {
          "key" => "eap_dependant_accounts", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        },
        "eap_counselor" => {
          "key" => "eap_counselor", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_childcare" => {
          "key" => "eap_childcare", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_health_library" => {
          "key" => "eap_health_library", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_chat" => {
          "key" => "eap_chat", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_contact_page_phone_numbers" => {
          "key" => "eap_contact_page_phone_numbers", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_lactcorp" => {
          "key" => "eap_lactcorp", "value" => "", "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "eap_cerner" => {
          "key" => "eap_cerner", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "spot_rewarding" => {
          "key" => "spot_rewarding", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "ap_feed_post" => {
          "key" => "ap_feed_post", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "ap_dashboard_social" => {
          "key" => "ap_dashboard_social", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "ap_user_upload" => {
          "key" => "ap_user_upload", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "ap_dashboard_benefits" => {
          "key" => "ap_dashboard_benefits", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }, 
        "ap_accounting" => {
          "key" => "ap_accounting", "value" => false, "is_enabled" => true_or_false, "is_degraded" => false, "show_in_admin_panel" => false
        }
      },
      "parent_id" => "#{package_id}"
    }

    end_point =  "companies/#{company_id}/packages"
    
    result_json = request_from_api('Post', end_point, parameters, nil, 'v1.4')  
    
    if API[:print_response]
      puts "CHANGE_COMPANY_FEATURE:#{result_json}"
    end

    return result_json
  end

  # Click on retailer offer
  # @param user_id
  # @param retailer_id
  # @param provider
  def click_on_retailer_offer (user_id, retailer_id, provider)
    parameters = { }

    case provider
    when 'Incentive Networks'
      end_point = "uri?user_id=#{user_id}&retailer_id=#{retailer_id}&wa_retain_cashback=0"
    when 'Bownty'
      puts "click_bownty"
      end_point = "uri?user_id=#{user_id}&deal_id=54d87c0129c48cee6ea223da&wa_retain_cashback=0"
    end
    result_json = request_from_api('Get', end_point, parameters, nil, 'v1.4')  
    
    if API[:print_response]
      puts "CLICK_ON_RETAILER_OFFER:#{result_json}"
    end

    return result_json
  end
  
  # Get retailer 
  # @param retailer_id
  # @param user_token
  def get_retailer (retailer_id, user_token)
    parameters = { }
    end_point = "benefit/#{retailer_id}/online-shop"
    result_json = request_from_api('Get', end_point, parameters, user_token)
    
    if API[:print_response]
      puts "GET_RETAILER:#{result_json}"
    end

    return result_json
  end

  def create_company
    parameters = {
      'company' => {
        'name' => ACCOUNT[:account_1][:valid_account][:company_name],
        'nickname' => ACCOUNT[:account_1][:valid_account][:company_nick_name],
        'industry_type' => '0',
        'country' => ACCOUNT[:account_1][:valid_account][:country_code],
        'contact_tel' => '1376130000',
        'contact_email' => 'lifeworkstesting@workivate.com',
        'started_on' => '01/01/2000',
        'domain' => ACCOUNT[:account_1][:valid_account][:email_domain],
        'wa_subdomain' => ACCOUNT[:account_1][:valid_account][:workangel_subdomain],
        'locale' => ACCOUNT[:account_1][:valid_account][:user_locale],
        'vat_number' => 'GB980780684',
        'how_heard' => 'Friend' 
      },
      'address' => { 
        'head_office' => false,
        'address_one' => COMPANY_PROFILE[:profile_1][:address_line_1],
        'address_two' => COMPANY_PROFILE[:profile_1][:address_line_2],
        'city' => COMPANY_PROFILE[:profile_1][:city],
        'post_code' => COMPANY_PROFILE[:profile_1][:postcode],
        'country' => ACCOUNT[:account_1][:valid_account][:country_code] 
      },
      'administrator' => {
        'first_name' => 'user0',
        'last_name' => 'user0',
        'email' => ACCOUNT[:account_1][:valid_account][:email_subdomain] + '+' +
                    ACCOUNT[:account_1][:valid_account][:user_creation_country_code] + 
                    '@' + ACCOUNT[:account_1][:valid_account][:email_domain],
        'tel_work' => '07234456712',
        'job_title' => 'Admin',
        'password' => ACCOUNT[:account_1][:valid_account][:password],
        'password_confirm' => ACCOUNT[:account_1][:valid_account][:password] 
      },
      'subscription' => { 
        'billing_contact_email' => 'lifeworkstesting@lifeworks.com',
        'currency' => ACCOUNT[:account_1][:valid_account][:currency_name],
        'price_per_user' => '8.25',
        'contract_minimum' => 20,
        'account_manager' => 'lifeworkstesting@lifeworks.com',
        'grace_period' => 7 
      },
      'payment' => { 
        'provider_id' => '543fab6cc6dc066c8008413d'  
      },'state' => 1
    }
    
    end_point = "internal/company"
    result_json = request_from_api('Post', end_point, parameters, nil)
    
    if API[:print_response]
      puts "POST_COMPANY:#{result_json}"
    end

    return result_json
  end

  def update_company (company_id, state)
    end_point = "internal/company/#{company_id}"
    parameters = {
      'state' => 1
    }
    result_json = request_from_api('Put', end_point, parameters, nil)
    puts "end_point:#{end_point}"
    if API[:print_response]
      puts "PUT_COMPANY:#{result_json}"
    end

    return result_json
  end

  # def create_group (company_id, group_name)
  #   puts "create_group-company_id:#{company_id}"
  #   end_point = "companies/#{company_id}/groups" 

  #   parameters = {
  #     'name' => group_name
  #   }

  #   result_json = request_from_api('Post', end_point, parameters, nil)

  #   if API[:print_response]
  #     puts "POST_COMPANY_GROUP:#{result_json}"
  #   end

  #   return result_json
  # end

  # def get_company_group (company_id)
  #   parameters = {}

  #   end_point = "companies/#{company_id}/groups" 

  #   result_json = request_from_api('Get', end_point, parameters, nil)

  #   if API[:print_response]
  #     puts "GET_COMPANY_GROUP:#{result_json}"
  #   end

  #   return result_json
  # end

  def create_user(first_name, last_name, email, password, job_title, locale, company_invetation_code)
    parameters = {
      'first_name' => first_name,
      'last_name' => last_name,
      'email' => email,
      'password' => password,
      'company_invitation_code' => company_invetation_code,
      'signup_state' => 25,
      'job_title' => job_title,
      'locale' => locale,
      'authorization_required' => false,
      'email_confirmation_required' => false
    }
    puts "email:#{email}"
    end_point = 'user'
    result_json = request_from_api('Post', end_point, parameters, nil)

    if API[:print_response]
      puts "POST_CREATE_USER:#{result_json}"
    end

    return result_json
  end

  #  company 
  # @param company_id
  def get_company (company_id)
    parameters = { }
    end_point = "internal/company/#{company_id}"
    result_json = request_from_api('Get', end_point, parameters, nil)
    
    if API[:print_response]
      puts "GET_COMPANY:#{result_json}"
    end

    return result_json
  end
  
  # Get cashback value from feature list
  # @param comapany
  # @param feature
  def get_cashback_value_from_feature_list(comapany, feature)
    return comapany['body']['feature_keys']["#{feature}"]['value']
  end

  # Trigger daily report from server
  def trigger_daily
    run_commend_in_server ("APPLICATION_ENV=qa php /www/projects/wam-backend-v13/public/index.php notification trigger daily")
    sleep(5)
  end

  # Trigger monthly report from server
  def trigger_monthly
    run_commend_in_server ("APPLICATION_ENV=qa php /www/projects/wam-backend-v13/public/index.php notification trigger monthly")
    sleep(5)
  end

  # Create transaction
  # @param user_id
  # @param sale
  # @param commission
  # @param tx_date
  # @param currency_id
  # @param method
  # @param order_id
  def create_transaction (user_id, sale, commission, tx_date, currency_id, method, order_id = nil)
    puts "create_transaction:#{user_id},#{sale},#{commission},#{tx_date},#{currency_id},#{method},#{order_id}"
    tran_id = DateTime.now.strftime('%s').to_i 
    
    if order_id == nil
      order_id = tran_id
    end

    puts "order_id_create_transaction:#{order_id} tran_id_create_transaction:#{tran_id}"

    temp_transaction_array = {"sale"=>"#{sale}","partner_member_id" => user_id,"payment_eligible" => "0","load_date" => "2015-02-20","commission" => "#{commission}","tx_date" => "#{tx_date}","currency_id" => "#{currency_id}","is_bonus" => "0","browser_id" => "3488104","tran_id" => "#{tran_id}","merchant_id" => "9058","consumer_commission" => "#{commission}","order_id" => "#{order_id}","merchant_name" => "Hotels.com","paid" => "0","partner_commission" => "#{commission}","reseller_commission" => "0.00","is_fraud_review" => "null","is_adjustment" => "0","parent_tran_id" => "null"}
    transaction_array = ""
    case method
    when 'loaded'
        transaction_array = {"loaded"=>{"tx"=> [temp_transaction_array]},"payment_completed" => {"tx" => []},"approved" => {"tx" => []},"reconciled" => {"tx" => []}}
    when 'payment_completed'
        transaction_array = {"loaded"=>{"tx"=> []},"payment_completed" => {"tx" => [temp_transaction_array]},"approved" => {"tx" => []},"reconciled" => {"tx" => []}}
    when 'approved'
        transaction_array = {"loaded"=>{"tx"=> []},"payment_completed" => {"tx" => []},"approved" => {"tx" => [temp_transaction_array]},"reconciled" => {"tx" => []}}
    when 'reconciled'
        transaction_array = {"loaded"=>{"tx"=> []},"payment_completed" => {"tx" => []},"approved" => {"tx" => []},"reconciled" => {"tx" => [temp_transaction_array]}}
    end

    puts "create_transaction:#{transaction_array}"
    run_commend_in_server("echo '#{transaction_array.to_json}' > eliran.json")
    run_commend_in_server("APPLICATION_ENV=qa php /www/projects/wam-backend-v13/public/index.php transaction incentivenetworks update --local-file=/home/ubuntu/eliran.json") 
    return order_id 
  end

  # Automatic withdrew
  def automatic_withdrew
    run_commend_in_server ("APPLICATION_ENV=qa php /www/projects/wam-backend-v13/public/index.php user wallet auto withdraw")
  end

  # Run the given commend on the server
  # @param commend
  def run_commend_in_server (commend)
    if ENV['CURRENT_CUCUMBER_PROFILE'].include? 'Headless'
      path = "/home/ubuntu/.ssh/wamqa.pem"
    else
      path = "/Users/wangel/.ssh/wam-qa.pem"
    end

    Net::SSH.start('qa.api.lifeworks.com', 'ubuntu',:keys => path) do |ssh| 
      ssh.exec!(commend)
    end
  end
  
  # Get ID and SECRET from SSO server
  def get_id_and_secret_from_sso_server
    if ENV_LOWCASE == 'integration' 
      Net::SSH.start('54.229.56.194', 'ubuntu') do |ssh|        
        @return_value = "#{ssh.exec!("ssh integration < /tmp/ls_int")}"
      end
    elsif  ENV_LOWCASE == 'staging'
      Net::SSH.start('54.229.56.194', 'ubuntu') do |ssh|        
        @return_value = "#{ssh.exec!("ssh -i wamapi_staging.pem ubuntu@10.0.5.98 < /tmp/ls_int")}"
      end
    else
      @return_value = run_commend_in_server('cd /www/projects/sso/current && php app/console wamsso:oauth-server:client:create --redirect-uri="http://workangel.com" --grant-type="refresh_token" --grant-type="token" --grant-type="client_credentials" --reseller-key="orbit"')
    end

    return @return_value
  end
                      
  # Create request from SSO server
  # @param http_mathod
  # @param uri
  # @param parameters
  # @param value_to_return
  def request_from_sso_server (http_mathod, uri, token = nil, parameters = nil, value_to_return = nil)
    uri_temp = uri
    uri = URI.parse(uri)

    case http_mathod  
    when 'Post'
      req = Net::HTTP::Post.new(uri.to_s)
    when 'Put'
      req = Net::HTTP::Put.new(uri.to_s)
    when 'Get'
      req = Net::HTTP::Get.new(uri.to_s)
    when 'Delete'
      req = Net::HTTP::Delete.new(uri.to_s)
    end
    
    req.add_field('Accept', 'application/json')
    
    req.add_field('Content-Type', 'application/json')
    
    if token != nil
      req.add_field('Authorization', "Bearer #{token}")
    end

    if parameters != nil
      @payload = parameters.to_json
      req.body = @payload
    end

    puts "uri:#{uri}, token:#{token}, parameters:#{parameters}, http_mathod:#{http_mathod}"

    if (uri_temp.include? 'integration') || (uri_temp.include? 'staging')
      res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') { |http|
        http.request(req)
      }
    else
      res = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(req)
      }
    end

    result_json = JSON.parse(res.body)

    if API[:print_response]
      puts "REQUEST_FROM_SSO_SERVER:#{result_json}"
    end

    if value_to_return == 'access_token'
      return "#{result_json['access_token']}"
    else
      return result_json
    end
  end

  def create_sso_user (uuid, first_name, last_name, user_email, company_uuid, token)
    parameters = {
      "users" => [
        {
          "uuid" => "#{uuid}",
          "first_name" => "#{first_name}",
          "last_name" => "#{last_name}",
          "locale" => "en_GB",
          "email" => "#{user_email}",
          "job_title" => "api manager",
          "company_uuid" => "#{company_uuid}"
        }
      ]
    }
    
    uri = "#{$SSO}" + "/" + "v1.0/users/save-multiple"
    return_json = request_from_sso_server('Post', uri, token, parameters,nil)
    puts "CREATE_USER:#{return_json}"
    
    if ENV_LOWCASE != 'integration' && ENV_LOWCASE != 'staging'
      sleep(10)
      return_json_get_user = get_user($current_user_uuid)
      puts "return_json_get_user#{return_json_get_user}"
      $current_user_id = return_json_get_user['body']['user_id']
      file_service = FileService.new
      file_service.insert_to_file('latest_sso_new_user_id:', $current_user_id)
    end

    puts "CURRENT_USER_ID:#{$current_user_id}"
    puts "return_json['error']:#{return_json['error']}"
    puts "return_json:#{return_json}"
  end

  # Delete existing SSO user
  # @uuid - user id
  # @comapany_id
  # @token
  def delete_user (uuid, comapany_id, token)
    uri = "#{$SSO}" + "/" + "v1.0/users?uuid=" + "#{uuid}" + '&company_id=' + "#{comapany_id}"
    
    puts "uri:#{uri}"
    puts "TOKEN:#{token}"
    
    return_json = request_from_sso_server('Delete', uri, token, nil, nil)
    
    if API[:print_response]
      puts "DELETE_USER:#{result_json}"
    end

    return return_json
  end

  # Send recognition to user/s
  # @param badge_id
  # @param message - text
  # @param target_list - list of users id
  # @praam token
  def send_recognition (badge_id = nil, message = nil, target_list = nil, token = nil)
    parameters = {  
      "message" => "#{message}",
      "badge_id" => "#{badge_id}",
      "target_list" => ["547f49af29c48c32198b4589"]
    }
    
    return_json = request_from_api('Post', 'recognize', parameters, token)

    if API[:print_response]
      puts "SEND_RECOGNITION:#{result_json}"
    end

    uri = 'recognize'

    return return_json
  end

  # Add funds from Rewards
  # @param company_id
  # @param amount - amount of funds
  # @param currency
  def add_funds (company_id, amount, currency="#{ACCOUNT[:"#{$account_index}"][:valid_account][:currency_name]}")
    # ENV_LOWCASE = 'dev'
    parameters = {    
        "company_id" => "#{company_id}",
        "value" => {
            "amount" => amount,
            "currency" => "#{currency}"
        },
        "comment" => "comment text"
    }
    uri = 'spot-rewards/transactions/budgets'
    return_json = request_from_api('Post', uri, parameters, nil, 'v1.4')
    
    if API[:print_response]
      puts "#{return_json}"
    end

    return return_json
  end

  def post_notify_user (user_id, transaction_id)
#    parameters = { }
 #   uri = "users/#{user_id}/wallet/transactions/#{transaction_id}/notify"
  #  return_json = request_from_api('Post', uri, parameters, nil, 'v1.4')
    
   # if API[:print_response]
    #  puts "post_notify_user#{return_json}"
    #end

   # return return_json
  end
end

