class TaskManagerController < ApplicationController

    def index

    end

    # Note: ths is a test hack since in dev mode, Actioncable can only receive from the same process, so instead hit
    # this with js manually or every x seconds
    def scheduler
        dummy_message = Message.new(body: "What are you working on today?", source: "thinker") 
        
        html = ApplicationController.render(
            partial: 'messages/message',
            locals: {message: dummy_message}
        )
        
        ActionCable.server.broadcast("global_channel", {html: html})
        
        render plain: "done"
    end

end
