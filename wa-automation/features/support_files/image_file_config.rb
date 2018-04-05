IMAGE_FILES = {

	:company_appearance => {
		:allowed_image_types => {
			:png => "File.expand_path('features/support_files/images/test_upload_file.png')",
			:gif => "File.expand_path('features/support_files/images/test_upload_file.gif')",
			:jpg => "File.expand_path('features/support_files/images/test_upload_file.jpg')"
		},
	},

	:cinema => {
		:png => "File.expand_path('features/support_files/images/Popcorn-Box.png')"
	},

	:badges => {
		:social_butterfly => {
			:colour => "File.expand_path('features/support_files/images/Social butterfly.png')",
			:black_and_white => "File.expand_path('features/support_files/images/Social butterfly b&w.png')"
		},
	 },

	:offers => {
		:png => "File.expand_path('features/support_files/images/golden_ticket.png')"
	},

	:newsfeed => {
		:png =>  "File.expand_path('features/support_files/images/newsfeed.png')"
	},

	:giftcard => {
		:png =>  "File.expand_path('features/support_files/images/gift-card.png')"
	}
}
