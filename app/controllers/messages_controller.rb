class MessagesController < ApplicationController

	def index
		@messages = Message.all
		@tasks = Task.all
	end

	def show
	end

	def new
	end

	def create
		message = Message.new(message_params.merge(source: "user"))


		respond_to do |format|
		    if message.save
				
		    	reply = ChatGtpAssistantMessage.new.send_message(message.body)

				response = Message.create(body: reply, source: "thinker")

		      	format.turbo_stream do
		      		
			      	render turbo_stream: [
			      		turbo_stream.append('messages', message),
			      		turbo_stream.append('messages', response),
			      	] 
			      end
		    else
		      render :new
		    end
		end
	end

	private

	def message_params
		params.require(:message).permit(:body)
	end

end
