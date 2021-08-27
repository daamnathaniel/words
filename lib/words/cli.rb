# frozen_string_literal: true
require 'pry'

module Words
  class CLI

    def call
      start
    end

    def start
      endpoint_query      = Words::Query.new(%q(
  words - returns a list of words based upon a given constraint.
  sug - will return a list of words based upon a partial word given.
    _______
  words or sug?"), { 'words': "words", 'suggestions': "sug" } )
      constraint_query    = Words::Query.new( 'which constraint? I.e you are looking for words...', DataMuse::CONSTRAINTS )
      variable_query      = Words::Query.new( 'which word or partial word to base your search on?' )
      second_query        = Words::Query.new( 'would you like to see [more] info? search [again] or [quit]?',  { 'more info on a particular word': :more, 'search again': :again, 'quit program': :quit  } )
      extended_query      = Words::Query.new( 'which word?', :resuts )
      third_query         = Words::Query.new( 'search [again) or [quit]?', { 'search again': :again, 'quit program': :quit } ) 

      first_menu          = Words::FirstMenu.new(endpoint_query, constraint_query, variable_query)
      first_menu.prompt
      @first_response = first_menu.call
      S.columns(@first_response)

      second_menu         = Words::SecondMenu.new(second_query, @first_response.payload)
      second_menu.prompt
      response = second_menu.call
      S.individual(response)

      third_menu          = Words::ThirdMenu.new(third_query)
      third_menu.prompt
    end

    def finish
      puts "bye"
      exit
    end
  end
end












# module Words
#   class CLI
#     def call
#       greet
#       prep
#       self.firstprompt
#       second
#       third
#       bye
#     end
    
#     def greet
#       say('Welcome to words. words finds words.')
#     end

#     def prep
#       @endpoint         = Endpoint.new
#       @constraint       = Constraint.new
#       @variable         = Variable.new
#       @second_menu      = SecondMenu.new
#       @second_extended  = SecondExtended.new
#       @third_menu       = ThirdMenu.new
#     end

#     def firstprompt
#       @endpoint.prompt
#       case @endpoint.answer
#       when 'words'  then @constraint.prompt
#       when 'sug'    then @constraint.answer = 's'
#       end
#       @variable.prompt

#       @answer = DataMuse.send(@endpoint.answer).send(@constraint.answer, @variable.answer).fetch
#       Show.word(@answer)
#       second
#     end

#     def second
#       @second_menu.prompt
#       case @second_menu.answer
#       when 'quit'   then bye
#       when 'again'  then first
#       when 'more'   then @second_extended.prompt
#       end

#       @answer = DataMuse.send('words').send('spelled_like', @second_extended.answer).fetch
#       Show.detail(@answer[0])
#       third
#     end

#     def third
#       @third_menu.prompt
#       case @third_menu.answer
#       when 'quit'   then bye
#       when 'again'  then first
#       end
#     end

#     def bye
#       exit
#     end

#   end
# end    
