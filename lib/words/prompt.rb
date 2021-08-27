# # frozen_string_literal: true

  
# module S
#   extend self

#   def words_fetch(endpoint, constraint, variable) 
#     DataMuse.send(endpoint).send(constraint, variable).fetch
#   end 

#   def ift(this, that, something=nil)
#     if this
#       that
#     else
#       something
#     end
#   end
# end



# module Words

#   class BaseService
#     attr_reader :answer
  
#       def initialize(query)
#         self.question = query[:question]
#         self.options = query[:options]
#       end
  
#       def self.call(*args)
#         new(*args).call
#       end
  
#       private
  
#       private_class_method :new
  
#       attr_accessor :question, :options
#     end
  
#   class PromptSelect < BaseService
#     def call
#       prompt = TTY::Prompt.new
#       @answer = prompt.select(@question) do |menu|
#         @options.each do |k,v|
#           menu.choice k, v 
#         end
#       end
#     end
#   end
  
#   class PromptAsk < BaseService
#     def call
#       prompt = TTY::Prompt.new
#       @answer = prompt.ask(@question)
#     end
#   end
  
  
#   class FirstMenu
#     def initialize(endpoint, constraint, variable)
#       @endpoint = endpoint
#       @constraint = constraint
#       @variable = variable
#     end
  
#     def prompt
#       @endpoint_answer = PromptSelect.call(@endpoint)
#       @constraint_answer =PromptSelect.call(@constraint) if @endpoint_answer == 'words'
#       @constraint_answer = 's' if @endpoint_answer == 'sug'
#       @variable_answer = PromptAsk.call(@variable)
#     end  
    
#     def call
#       S.words_fetch(@endpoint_answer, @constraint_answer, @variable_answer)
#     end
#   end
  
#   class SecondMenu
#     def initialize(second, results)
#       @second = second
#       @results = results
#       self.extend
#     end
  
#     def extend
#       res = @results.reduce({}) {| r, item| r.update(item.word => item.word) }
#       @extended = Query.new( "which word?", res )
#     end
  
#     def prompt
#       @second_answer = PromptSelect.call(@second)
#       case @second_answer
#       when :again then SOMETHINGFIRST
#       when :quit then quit
#       when :more then self.extend  
#       end
#       @extended_answer = PromptSelect.call(@extended)
#     end
    
#     def call
#       resp = S.words_fetch("words", "spelled_like", @extended_answer)
#       resp[0]
#     end
#   end
# end
  
  
  
  
  
#   # CONSTRAINTS = {
#   #   sounds_like: :sl,
#   #   means_like: :ml,
#   #   spelled_like: :sp,
#   #   nouns_modified_by: :rel_jja,
#   #   adjectives_that_modify: :rel_jjb,
#   #   synonymous_with: :rel_syn,
#   #   trigger_by: :rel_trg,
#   #   antonymns_of: :rel_ant,
#   #   kind_of: :rel_spc,
#   #   more_general_than: :rel_gen,
#   #   comprise: :rel_com,
#   #   part_of: :rel_par,
#   #   frequently_follow: :rel_bga,
#   #   frequently_preceed: :rel_bgb,
#   #   rhymes_with: :rel_rhy,
#   #   kinda_rhymes_with: :rel_nry,
#   #   sound_alike: :rel_hom,
#   #   consonants_match: :rel_cns,
#   #   left_context: :lc,
#   #   right_context: :rc,
#   #   max: :max,
#   #   topics: :topic,
#   #   s: :s,
#   #   v: :vocabulary
#   # }
  
#   Words::Query = Struct.new( :question, :options )
  
#   endpoint_query  = Words::Query.new(%q(
#     words - returns a list of words based upon a given constraint.
#     sug - will return a list of words based upon a partial word given.
#     words or sug?"
#     ), { 'words': "words", 'suggestions': "sug" } )
#   constraint_query = Words::Query.new( 'which constraint? I.e you are looking for words that...', DataMuse::CONSTRAINTS )
#   variable_query = Words::Query.new( 'which word or partial word to base your search on?' )
  
#   second_query = Words::Query.new( 'would you like to see [more] info? search [again] or [quit]?',  { 'more info on a particular word': :more, 'search again': :again, 'quit program': :quit  } )
#   extended_query = Words::Query.new( 'which word?', :resuts )
  
#   third_query = Words::Query.new( 'search [again) or [quit]?', { 'search again': :again, 'quit program': :quit } ) 
  
  
  
  
  
#   first_menu = Words::FirstMenu.new(endpoint_query, constraint_query, variable_query)
#   first_menu.prompt
#   first_menu.call
  
#   second_menu = Words::SecondMenu.new(second_query, extended_query)
#   second_menu.prompt
#   second_menu.extend
#   second_menu.call
  







# #   ADDSPACE = proc do |word, array|
# #     space = proc {|word| "#{word}#{' ' * ( 24 - word.length) } "}
# #     array << space.(word)
# #   end


# # #   class Prompt
# # #     attr_accessor :question, :choices, :answer

# # #     def prompt( choices = nil )
# # #       @answer = ask( question, choices )
# # #       puts " > #{ @answer }"
# # #       puts
# # #     end
# # #   end

# # #   class Endpoint < Prompt
# # #     def question
# # #       'words - returns a list of words based upon a given constraint.'
# # #       'sug - will return a list of words based upon a partial word given.'
# # #       'words or sug?'
# # #     end

# # #     def choices
# # #       %w[words sug]
# # #     end
# # #   end

# # #   class Constraint < Prompt
# # #     def question
# # #       'which constraint?'
# # #     end

# # #     def choices
# # #       DataMuse::CONSTRAINTS.keys.map(&:to_s)
# # #     end

# # #     def prompt
# # #       choices = DataMuse::CONSTRAINTS.keys.map(&:to_s)
# # #       self.choices.each do |choice|
# # #         choice_array = []
# # #         ADDSPACE.(choice, choice_array)
# # #         choice_array.each_slice(6){|choice| puts choice * " "}
# # #       end
# # #       super
# # #      end
# # #     end

# # #   class Variable < Prompt
# # #     def question
# # #       'which word?'
# # #     end
# # #   end

# # #   class SecondMenu < Prompt
# # #     def question
# # #       'would you like to see [more] info? search [again] or [quit]?'
# # #     end

# # #     def choices
# # #       %w[more again quit]
# # #     end
# # #   end

# # #   class SecondExtended < Prompt
# # #     def question
# # #       'which word?'
# # #     end

# # #     def choices(choices)
# # #       @choices = choices
# # #       @choices.payload.map(&:word)
# # #     end
# # #   end

# # #   class ThirdMenu < Prompt
# # #     def question
# # #       'search [again] or [quit]?'
# # #     end

# # #     def choices
# # #       %w[again quit]
# # #     end
# # #   end
# # # end




# # #     answers_array.each_slice(5) do |answer|
# # #       puts answer * ' ' 
# # #     end
# # #   end

# # # response.each do |resp|
# # #   spaced = resp.word + "#{' ' * (24 - resp.word.length)}"
# # #   response_array.push(spaced)
# # # end

# # # response_array.each_slice(5) do |resp|
# # #   puts resp * ""
# # # end


# # # choices = DataMuse::CONSTRAINTS.keys.collect(&:to_s)
# # # choice_array = []
# # # choices.each do |choice|
# # #   spaced =  choice + "#{' ' * (24 - choice.length)}"
# # #   choice_array.push(spaced)





# # prompt = TTY::Prompt.new

# #   class Prompt
# #     include Words
# #     attr_accessor :question, :choices, :answer, :prompt

# #   @@prompt = PROMPT
  
# #   def initialize()
# #     @question = question
# #     @choices = choices
# #   end

# #   def prompt_select(question=nil, choices=nil)
# #     @answer = @@prompt.select(@question) do |menu|
# #       @choices.each do |k,v|
# #         menu.choice = k, v
# #       end
# #     end
# #   end

# #   def prompt_ask
# #     @answer = @@prompt.ask(@question)
# #   end
# # end

# # class Endpoint < Prompt
# #   def initialize()
# #     @choices = {"words": "words", "sug": "suggestions"}
# #     @question = %(
# #     words - returns a list of words based upon a given constraint.
# #     sug - will return a list of words based upon a partial word given.
# #     words or sug?
# #     )
# #   end

# #   def prompt_select(question, choices)
# #     super
# #   end
# # end

# # class Constraint < Prompt
# #   def prompt_select(choices = DataMuse::CONSTRAINTS)
# #     question = "which constraint?"
# #     super
# #   end  
# # end

# # class Variable < Prompt
# #   def prompt_ask
# #     question = 'which word?'
# #     super
# #   end
# # end

# # class SecondMenu < Prompt
# #   def prompt_select(choices = {"search again": "again", "quit program": "quit", "more info on a particular word": "more"} )
# #     question = 'would you like to see [more] info? search [again] or [quit]?'
# #     super
# #   end
# # end

# # class SecondExtended < Prompt
# #   def prompt_ask
# #     question = 'which word?'
# #   end
# # end

# # class ThirdMenu < Prompt
# #   def prompt_select(choices={"search again": "again", "quit program": "quit"})
# #     question = 'search [again] or [quit]?'
# #   end
# # end
# # end






