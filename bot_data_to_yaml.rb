require 'yaml'

bot_data = {
  presub: [
    ['dont', 'do not'],
    ["don't", 'do not'],
    ['youre', "you're"]
  ],

  response: {
    default: 
    ["I don't understand.", 
    "What?",
    "Huh?"],
    greeting: ["Hi. I'm [name]. Want to chat?"],
    farewell: ["Good bye!"],
    'hello' => [
      "How's it going?",
      "How do you do?"
    ],
    'i like *' => [
      "Why do you like *?",
      "Wow! I like * too!"
    ]
  }
}

#Present user yaml structure
puts bot_data.to_yaml

#Save file in yaml
f = File.open(ARGV.first || 'bot_data', 'w')
f.puts bot_data.to_yaml
f.close