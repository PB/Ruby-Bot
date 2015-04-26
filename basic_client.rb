require './bot'

bot = Bot.new(name: "Botty", date_file: './botty.bot')

puts bot.greeting
while input = gets and input.chomp != 'goodbye'
  puts '>> ' + bot.response_to(input)
end
puts bot.farewell