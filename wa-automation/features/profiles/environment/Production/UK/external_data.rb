# -*- encoding : utf-8 -*-
URL = {
  :hermes => 'http://[company_wa_subdomain].lifeworks.com',
  :zeus => 'http://zeus.test.lifeworks.com',
  :zeus_shop => ENV['URL_ADMIN_PANEL_SIGNUP'],
  :arch => ENV['URL_ARCH'],
  :api => 'http://api.test.lifeworks.com',
  :zeus_password => 'wam:wamadmin007',
  :sso => ENV['URL_SSO'],
  :password => 'wamqa:N1mbus-20o1',
}

# CAPITA = {
#   :user1 => {
#     :capita_user_name => 'test6 workangel',
#     :capita_user_password => 'P@55w0rd',
#     :capita_user_uuid => 'a0efe698-f53e-4aea-b701-9c03a13f9241',
#     :capita_user_email => 'lifeworkstesting+capita1@lifeworks.com',
#     :user_name => 'user1',
#   }
# }

USER_PROFILE = {
  :user1 => {
    :role_title => 'Role 1',
    :phone => '222222222',
    :gender => 'Male',
    :gender_code => '0',
    :b_day_date => '3',
    :b_day_month => 'Jan',
    :b_day_month_code => '1',
    :b_day_year => '1980',
    :date_join_day => '3',
    :date_join_month => 'Jan',
    :date_join_month_code => '1',
    :date_join_year => '2000',
    :about => 'I love the world 1'
  },

  :user2 => {
    :role_title => '01',
    :phone => '11111111111',
    :gender => 'Female',
    :gender_code => '1',
    :b_day_date => '1',
    :b_day_month => 'Feb',
    :b_day_month_code => '2',
    :b_day_year => '1980',
    :date_join_day => '3',
    :date_join_month => 'Feb',
    :date_join_month_code => '2',
    :date_join_year => '2000',
    :about => 'I love the world 2'
  },

  :new_user => {
    :first_name => 'user',
    :last_name => 'user',
    :job_title => 'Secret agent',
    :password => 'testtest456!',
    :phone => '02035675901',
    :mobile => '02035675901',
    :birth_day => '1',
    :birth_month => 'Feb',
    :birth_year => '1987',
    :joined_day => '1',
    :joined_month => 'Feb',
    :joined_year => '2012',
    :company_name => 'Work Angel',
    :country => 'United Kingdom',
    :card_holder_name => 'Mr James Bond',
    :expiry_month => 'April',
    :expiry_year => '2017',
    :cvc => '213',
    :gender => 'Male'
  },

  :new_admin_user => {
    :first_name => 'user0',
    :last_name => 'user0',
    :job_title => 'Secret agent',
    :password => 'testtest456!',
    :phone => '02035675900',
    :mobile => '02035675900',
    :birth_day => '1',
    :birth_month => '2',
    :birth_year => '1987',
    :joined_day => '1',
    :joined_month => '2',
    :joined_year => '2012',
    :email => 'e@e.com',
    :company_name => 'LifeWorksTesting',

    :card_holder_name => 'Mr James Bond',
    :expiry_month => 'April',
    :expiry_year => '2017',
    :cvc => '213',
    :santander_sort_code => {
      :part_1 => '20',
      :part_2 => '00',
      :part_3 => '00',
    },
    :santander_account_number => '55779911',
    :company_nickname => 'WAM',
    :wa_subdomain => 'lifeworkstesting',
    :industry_type => 'Armed Forces',
    :country => 'United Kingdom',
    :postcode => 'ID1 1QD',
    :addressList => '2 Barons Court Road',
    :addressListTwo => '',
    :city => 'London',
    :county => 'Greater London',
    :local => 'English (UK)',
    :how_heard => 'Search engine',
    :industryType => 'Accountancy, Banking and Finance',
  }
}

COMPANY_PROFILE = {
  :profile_1 => {
    :nickname => 'Work Angel Testing',
    :founded_day => '1',
    :founded_month => 'Feb',
    :founded_year => '2001',
    :date_founded => 'February 1, 2001',
    :industry_type => 'Retail',
    :vat_number => '3333334',
    :phone_number => '02035675902',
    :address_line_1 => '2 Barons Court Road',
    :address_line_2 => 'Address 2',
    :city => 'LONDON',
    :postcode => 'ID1 1QD',
    :country => 'United Kingdom'
  },
  :profile_2 => {
    :nickname => 'company 2',
    :founded_day => '2',
    :founded_month => 'Apr',
    :founded_year => '2002',
    :date_founded => 'April 2, 2002',
    :industry_type => 'Other',
    :vat_number => '3333333',
    :phone_number => '02035675903',
    :address_line_1 => 'Address 3',
    :address_line_2 => 'Address 4',
    :city => 'city 2',
    :postcode => 'CB1 7SY',
    :country => 'United Kingdom'
  }
}

CREDIT_CARD = {
  :visa => '4242424242424242',
  :mastercard => '5555555555554444',
  :amex => '378282246310005',
  :credit_card_for_gift_card => {
    :type => 'Visa Debit',
    :card_number => '5404 0000 0000 0001',
    :card_cv2_value => '123',
  }
}

EMAILS = {
  :your_gift_card => {
    :subject => 'Your LifeWorks Gift Card',
    :return_value => 'nil'
  },

  :account_was_edited => {
    :subject => 'Your workangel™ profile has been edited by the network administrator',
    :return_value => nil
  },

  :approved => {
    :subject => 'approved',
    :return_value => nil
  },

  :cashback_query_received => {
    :subject => 'Cashback query received',
    :return_value => nil
  },

  :cashback_withdrawal_failed => {
    :subject => 'Cashback withdrawal failed',
    :return_value => nil
  },

  :cashback_withdrawal_received => {
    :subject => 'Cashback withdrawal received',
    :return_value => nil
  },

  :has_joined_lifeworks => {
    :subject => 'a rejoint LifeWorks',
    :return_value => nil
  },

  :how_to_get_cashback_with_lifeworks => {
    :subject => 'Comment obtenir une remise sur LifeWorks',
    :return_value => nil
  },

  :join => {
    :subject => 'Rejoignez',
    :return_value => 'invitation_code'
  },

  :new_campaign_notice => {
    :subject => 'New campaign notice',
    :return_value => nil
  },

  :order_confirmation => {
    :subject => 'Order Confirmation',
    :return_value => nil
  },

  :password_change_confirmation => {
    :subject => 'Confirmation de changement de mot de passe',
    :return_value => nil
  },

  :rejected => {
    :subject =>  'rejected',
    :return_value => nil
  },

  :reminder_to_sign_up => {
    :subject => 'You_haven\'t_signed_up_to_workangel',
    :return_value => nil
  },

  :top_performer => {
    :subject => "#{(Time.new().to_datetime<< 1).strftime("%B")}'s top performers at #{ACCOUNT[:"#{$account_index}"][:valid_account][:company_nick_name]}",
    :return_value => nil
  },

  :user_email_address_is_entered_in_to_the_individual_address_field_on_admin_panel => {
    :subject => 'user_signup_invite_by_admin_panel',
    :return_value => nil
  },

  :wallet_withdrawal_request_confirmed => {
    :subject => 'Wallet withdrawal request confirmed',
    :return_value => nil
  },

  :welcome_to_lifeworks => {
    :subject => 'Bienvenue sur LifeWorks',
    :return_value => 'welcome_to_wam'
  },

  :welcome_to_lifeworks_for => {
    :subject => 'Bienvenue sur LifeWorks pour',
    :return_value => nil
  },

  :welcome_to_wam => {
    :subject => 'Welcome to WAM',
    :return_value => 'webapp_link'
  },

  :weve_tracked_the_cashback_from_your_recent_purchase_at => {
    :subject => 'We\'ve tracked the cashback from your recent purchase at',
    :return_value => nil
  },

  :you_havent_signed_up_to_lifeworks_yet => {
    :subject => 'You haven\'t signed up to LifeWorks yet!',
    :return_value => nil
  },

  :your_account_has_been_reactivated => {
    :subject =>   'Your account has been reactivated',
    :return_value => nil
  },

  :your_account_has_been_deactivated => {
    :subject =>   'Your account has been deactivated',
    :return_value => nil
  },

  :your_cashback_has_been_declined => {
    :subject => 'Your cashback has been declined',
    :return_value => nil
  },

  :your_forgotten_password_request => {
    :subject => 'Votre demande de mot de passe oublié',
    :return_value => 'reset_password_link'
  },

  :your_reward_confirmation => {
    :subject => 'Your Reward Confirmation',
    :return_value => nil
  },

  :youve_been_recognised_on_lifeworks => {
    :subject =>     'You\'ve been recognised on LifeWorks!',
    :return_value => nil
  },

  # :user_has_been_approved_by_the_admin_of_the_network => {
  #   :subject => 'user_signup_approved'
  #   :return_value => nil
  # }
}

AFFILIATE = {
  :name => 'LifeWorks Testing',
  :email => 'lifeworkstesting@lifeworks.com'
}

ACCOUNT = {
  :account_1 => {
    :user_email_to_make_as_admin => 'lifeworkstesting+uk2@lifeworks.com',
    :user_name_to_make_as_admin => 'user1 user1',

    :user_email_to_delete => 'lifeworkstesting+uk2@lifeworks.com',
    :user_name_to_delete => 'user1 user1',

    :valid_account => {
      :email_domain => 'lifeworks.com',
      :email_subdomain => 'lifeworkstesting',
      :email => 'lifeworkstesting+uk@lifeworks.com',
      :password => 'testtest456',

      :user_name => 'user0 user0',

      :company_nick_name => 'LifeWorksTesting UK',

      :company_name => 'LifeWorksTesting UK',
      :workangel_subdomain => 'lifeworkstesting-uk',

      :country_code => 'GB',
      :currency_name => 'GBP',
      :currency_sign => '£',
      :local => 'en_GB',
      :defaut_language => 'English (UK)',
    },

    :reset_password_email => {
      :email => 'lifeworkstesting+uk@lifeworks.com',
      :new_password => '1a1a1a1a',
      :old_password => 'testtest456!'
    },

    :arch => {
      :email => 'lifeworkstesting@lifeworks.com',
      :password => 'testtest456'
    }
  }
}

USER_TO_DEACTIVATE = {
  :user_name => 'user1 user1',
  :email => 'lifeworkstesting+uk2@lifeworks.com',
  :password => 'testtest456!'
}

USER_SIGNUP_INVITE_EMAIL = {
  :email => 'lifeworkstesting+uk@lifeworks.com',
  :password => 'testtest456',
  :local_part => 'lifeworkstesting+uk',
  :subdomain => 'workivate.com'
}

SUPPORT_FILES = {
  :invite_email_counter => 'invite_email_counter',
  :admin_account_counter => 'admin_account_counter',
  :admin_panel_settings_score => 'admin_panel_settings_score',
  :company_invitation_code => 'company_invitation_code'
}

PROMOTION_CODES = {
  :sign_up => 'WORKIVATE'
}

VALIDATION = {
  :check_email => false,
  :to_delete_email => false,
  :check_notification => false
}

API = {
  :version => {
    :'v1.3' => 'application/vnd.wam-api-v1.3+json',
    :'v1.4' => 'application/vnd.wam-api-v1.4+json',
  },

  :header => {
    :accept => 'Accept',
    :wam_token => 'Wam-Token',
    :reseller_key => 'X-Reseller-Key',
  },

  :print_response => true
}

BADGES = {
  'Newbie' => 'welcome',
  'welcome' => 'Newbie',

  'Recognition' => 'recognition',
  'recognition' => 'Recognition',

  'Presentation Skills' => 'presentable',
  'presentable' => 'Presentation Skills',

  'Mathematician' => 'mathematician',
  'mathematician' => 'Mathematician',

  'Superstar' => 'superstar',
  'superstar' => 'Superstar',

  'Inspired' => 'inspired',
  'inspired' => 'Inspired',

  'Creative' => 'creative',
  'creative' => 'Creative',

  'Leadership' => 'leadership',
  'leadership' => 'Leadership',

  'Passion' => 'passionate',
  'passionate' => 'Passion',

  'Helpful' => 'helpful',
  'helpful' => 'Helpful',

  'Customer Is Always Right' => 'customerfocus',
  'customerfocus' => 'Customer Is Always Right',

  'Positive Attitude' => '#positive',
  '#positive' => 'Positive Attitude',

  'Full Of Energy' => 'energetic',
  'energetic' => 'Full Of Energy',

  'Genius' => 'einstein',
  'einstein' => 'Genius',

  'Star' => 'star',
  'star' => 'Star',

  'Organised' => 'organised',
  'organised' => 'Organised',

  'Late Worker' => 'nightowl',
  'nightowl' => 'Late Worker',

  'Team Player' => 'teamwork',
  'teamwork' => 'Team Player',

  'Social Butterfly' => 'sociable',
  'sociable' => 'Social Butterfly'
}

BADGE_TO_KEEP = {
  :badge_name => 'Creative',
  :BadgeTag => 'creative'
}

NEW_BADGE = {
  :name => 'Badge Test',
  :tag => 'BadgeTag',
  :description => 'Badge Description'
}

SHOP_ONLINE_RETAILERS = {
  :retailer_1 => {
    :name => 'John Lewis Car Insurance',
    :id => '543e84cb537464044e8b4648',
    :category => 'Insurance'
  },
  :retailer_2 => {
    :name => 'anyvan',
    :id    => '51c877b3537464f97b0014cc',
    :category => 'Travel',
  },
  :retailer_3 => {
    :name => 'AA UK Breakdown',
    :id    => '51c877b4537464f97b0018c7',
    :category => 'Insurance',
  }
}

SHOP_ONLINE_CATEGORIES = {
  :"Home" => "Home",
  :"Featured" => "Featured",
  :"Popular" => "Popular",
  :"Recommended" => "Recommended",
  :"Favourites" => "Favourites",
  :"Electronics" => "Electronics",
  :"Fashion" => "Fashion",
  :"Food & Beverage" => "Food & Beverage",
  :"Gifts & Gift Cards" => "Gifts & Gift Cards",
  :"Health & Beauty" => "Health & Beauty",
  :"Home & Garden" => "Home & Garden",
  :"Insurance" => "Insurance",
  :"Media" => "Media",
  :"Sports" => "Sports",
  :"Tickets" => "Tickets",
  :"Travel" => "Travel",
  :"Utilities" => "Utilities",
}

SHOP_ONLINE_SORT_OPTIONS = {
  :"Highest Cashback" => "Highest Cashback",
  :"Alphabetical Order" => "Alphabetical (Retailer)",
}

DAILY_DEAL_OFFERS = {
  :offer_1 => {
    :id => '57b35f4cfc1bc7ae73168b62'
  }
}

RESTAURATS_OFFERS = {
  :restaurant_1 => {
    :id => '54ca14ab29c48ce0638c9ee2',
    :name => ''
  }
}
