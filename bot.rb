require 'yaml'
require './wordplay'

class Bot
  attr_reader :name

  def initialize(options)
    @name = options[:name] || "Bot without name"
    begin
      @data = YAML.load(File.read(options[:data_file]))
    rescue
      raise "Missing data file"
    end
  end

  def greeting
    random_response :greeting
  end

  def farewell
    random_response :farewell
  end

  def response_to(input)
    prepared_input = preprocess(input).downcase
    sentences = best_sentence(prepared_input)
    responses = possible_responses(sentences)
    responses[rand(responses.length)]
  end


  private
    def random_response(key)
      random_index = rand(@data[:responses][key].length)
      @data[:responses][key][random_index].gsub(/\[name\]/, @name)
    end

    def preprocess(input)
      perform_substitutions input
    end

    def perform_substitutions(input)
      @data[:presubs].each { |s| input.gsub!(s[0], s[1]) }
      input
    end

    def best_sentence(input)
      hot_words = @data[:responses].keys.select do |k|
        k.class == String && k =~ /^\w+$/
      end

      WordPlay.best_sentence(input.sentences, hot_words)
    end

    def possible_responses(sentence)
      responses = []

      #find all patterns that can be matched
      @data[:responses].keys.each do |pattern|
        next unless pattern.is_a?(String)

        #Check all patterns that are in sentence
        #Before check remove * symbol
        #Put responses to array responses
        if sentence.match('\b' + pattern.gsub(/\*/, '') + '\b')
          # if pattern contains symbols for replacement
          if pattern.include?('*')
            responses << @data[:responses][pattern].collect do |phrase|
              #Remove all words before symbol of replacement
              matching_section = sentence.sub(/^.*#{pattern}\s+/, '')

              #Replace text after symbol of replacement
              phrase.sub('*', WordPlay.switch_pronouns(matching_section))
            end
          else
            #No symbol for replacement
            responses << @data[:responses][pattern]
          end
        end
      end

      #if no response found use default response
      responses << @data[:responses][:default] if responses.empty?
      #one dimension array
      responses.flattern
    end 
end