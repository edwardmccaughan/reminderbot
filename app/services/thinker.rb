class Thinker

	def initialize
		access_token = "32JNFLWKYKN5GBKNMN5YIANAQH2DHG34"
		@client = Wit.new(access_token: access_token)
	end

	def ponder(message)
		res = @client.message(message)

		intent = res["intents"][0]["name"]

		# this is probably not the right way to do this, reminder_item:reminder_item might change 
		body = res["entities"]["reminder_item:reminder_item"][0]["body"]
		
		# binding.break

		if intent == "create_reminder"
			"ok, I'll remind you to #{body}"

			# TODO: create some reminder record
		else
			"sorry, I'm not sure how to do that"
		end 
	end

end