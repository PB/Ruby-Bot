require 'webrick'
require './bot'

#HTTP request and bot communication
class BotServlet < WEBrick::HTTPServlet::AbstractServlet

  #Simple template of html page with form
  @@html = %q{
    <html><body>
      <form method="get">
        <h1>Talk whit Bot</h1>
        %RESPONSE%
        <p>
          <b>User says:</b> <input type="text" name="line" size="40" />
          <input type="submit" />
        </p>
      </form>
    </body></html>
  }

  def do_GET(request, response)
    #Set request as good and set mime as html
    response.status = 200
    response.content_type = "text/html"

    #if user write some text response to id
    if request.query['line'] && request.query['line'].length > 1
      bot_text = $bot.response_to(request.query['line'].chomp)
    else
      bot_text = $bot.greeting
    end

    #Place response in form
    bot_text = %Q{<p><b>Bot says:</b> #{bot_text}</p>}
    response.body = @@html.sub(/\%RESPONSE\%/, bot_text)
  end
end

#Create HTML server 
server = WEBrick::HTTPServer.new( Port: 1234 )
$bot = Bot.new( name: "Fred", data_file: "./fred.bot")
server.mount "/", BotServlet
trap("INT"){ server.shutdown }
server.start