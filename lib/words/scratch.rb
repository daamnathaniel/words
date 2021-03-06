# frozen_string_literal: true
require 'tty-prompt'
require 'blanket'

module DataMuse
  def self.words
    Request.new('words')
  end
  
  def self.sug
    Request.new('sug')
  end
end
  
  # DataMuse constraints serves as 
module DataMuse
  CONSTRAINTS = {
    "that sound like":    :sl,
    "with similar meanings":     :ml,
    "spelled like":   :sp,
    "usually modified by the nouns": :rel_jja,
    "adjectives that modify": :rel_jjb,
    "that are synonyms with": :rel_syn,
    "triggered by":     :rel_trg,
    "that have antonyms of":   :rel_ant,
    "that are a kind of":        :rel_spc,
    "more general kind": :rel_gen,
    "that comprise":       :rel_com,
    "that are a part of":        :rel_par,
    "frequently following": :rel_bga,
    "that frequently preceed": :rel_bgb,
    "that rhyme with":    :rel_rhy,
    "that kind of rhyme with": :rel_nry,
    "that sound alike":    :rel_hom,
    "with matching consonants": :rel_cns,
    "normally left of":   :lc,
    "normally right of":  :rc,
    "max results":            :max,
    "topics related to":         :topic,
    "suggest": :s,
    "vocabulary": :vo
  }
end




  # frozen_string_literal: true

module DataMuse
  class Request
    def initialize(path)
      @path = path
    end

    def fetch
    # response = HTTP.get(full_path)
    # JSON.parse(response)
      damu = Blanket.wrap(full_path)
      damu.get
    end

    DataMuse::CONSTRAINTS.each do |k, v|
      define_method k do |variable|
        self.class.new(@path + "?#{v}=#{variable}&md=dpsrf")
      end
    end

    DataMuse::CONSTRAINTS.each do |k, v|
      define_method v do |variable|
        self.class.new(@path + "?#{v}=#{variable}&md=dpsrf")
      end
    end

    #private

    def full_path
      "http://api.datamuse.com/#{@path}"
    end
  end
end
  
module S
  extend self
  
  def words_fetch(endpoint, constraint, variable) 
    DataMuse.send(endpoint).send(constraint, variable).fetch
  end 

  def ift(this, that, something=nil)
    if this
      that
    else
      something
    end
  end

  def columns(response)  
    response_array = []
    response.each do |resp|
      spaced = resp.word + "#{' ' * (24 - resp.word.length) }"
      response_array << spaced
    end
  
    response_array.each_slice(5) do |res|
      puts res * ""
    end
  end

  def individual(response)
    r = response
    puts " #{r.word} | #{r.defHeadword}              #{r.tags} #{r.score} #{r.numSyllables} "
    r.defs.each{|r| puts r if r}
  end


end
  
module Words
    
  class BaseService
    attr_reader :answer
    
    def initialize(query)
      self.question = query[:question]
      self.options = query[:options]
    end
    
    def self.call(*args)
      new(*args).call
    end
    
    private
    
    private_class_method :new
    
    attr_accessor :question, :options
  end
    
  class PromptSelect < BaseService
    def call
      prompt = TTY::Prompt.new(active_color: :green)
      @answer = prompt.select(@question, per_page: 15, filter: true, cycle: true) do |menu|
        @options.each do |k,v|
          menu.choice k, v 
        end
      end
    end
  end

  class PromptAsk < BaseService
    def call
      prompt = TTY::Prompt.new(active_color: :yellow)
      @answer = prompt.ask(@question)
    end
  end
    
  class FirstMenu
    def initialize(endpoint, constraint, variable)
      @endpoint = endpoint
      @constraint = constraint
      @variable = variable
    end
    
    def prompt
      @endpoint_answer      = PromptSelect.call(@endpoint)
      @constraint_answer    = PromptSelect.call(@constraint) if @endpoint_answer == 'words'
      @constraint_answer    = 's' if @endpoint_answer == 'sug'
      @variable_answer      = PromptAsk.call(@variable)
    end  
      
    def call
      response = S.words_fetch(@endpoint_answer, @constraint_answer, @variable_answer)
    end
  end
    
  class SecondMenu
    def initialize(second, results)
      @second = second
      @results = results
      self.extend
    end
    
    def extend
      res = @results.reduce({}) {| r, item| r.update(item.word => item.word) }
      @extended = Query.new( "which word?", res )
    end
    
    def prompt
      @second_answer        = PromptSelect.call(@second)
      case @second_answer
      when :again then CLI.new.call
      when :quit then CLI.new.finish
      when :more then self.extend  
      end
      @extended_answer      = PromptSelect.call(@extended)
      call
    end
      
    def call
      resp = S.words_fetch("words", "spelled_like", @extended_answer).payload[0]
    end
  end

    
  class ThirdMenu
    def initialize(third)
      @third = third
    end

    def prompt
      @third_answer         = PromptSelect.call(@third)
      case @third_answer
      when :again then CLI.new.call
      when :quit then CLI.new.finish
      end
    end
  end

  Query = Struct.new( :question, :options )




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

#   def columns(response)  
#     response_array = []
#     response.each do |resp|
#       spaced = resp.word + "#{' ' * (24 - resp.word.length) }"
#       response_array << spaced
#     end
  
#     response_array.each_slice(5) do |res|
#       puts res * ""
#     end
#   end

#   def individual(response)
#     r = response
#     puts " #{r.word} | #{r.defHeadword}              #{r.tags} #{r.score} #{r.numSyllables} "
#     r.defs.each{|r| puts r if r}
#   end


# end
  



# # require 'blanket'
# # require 'tty-prompt'


# # module DataMuse
# #   def self.words
# #     Request.new('/words?')
# #   end

# #   def self.sug
# #     Request.new('/sug?')
# #   end
# # end

# # module DataMuse
# #   CONSTRAINTS = {
# #     sounds_like: :sl,
# #     means_like: :ml,
# #     spelled_like: :sp,
# #     nouns_describing: :rel_jja,
# #     adjectives_describing: :rel_jjb,
# #     synonymos_with: :rel_syn,
# #     trigger: :rel_trg,
# #     antonyms_of: :rel_ant,
# #     kind_of: :rel_spc,
# #     more_general_than: :rel_gen,
# #     comprise: :rel_com,
# #     part_of: :rel_par,
# #     frequently_follow: :rel_bga,
# #     frequently_preceed: :rel_bgb,
# #     rhyme_with: :rel_rhy,
# #     kinda_rhyme_with: :rel_nry,
# #     sound_alike: :rel_hom,
# #     consonants_match: :rel_cns,
# #     left_context: :lc,
# #     right_context: :rc,
# #     max: :max,
# #     topics: :topic,
# #     s: :s,
# #     v: :vocabulary
# #   }
# # end

# # module DataMuse
# #   class Request
# #     def initialize(path)
# #       @path = path
# #     end

# #     def fetch
# #       Blanket.wrap(full_path).get
# #     end

# #     DataMuse::CONSTRAINTS.each do |k, v|
# #       define_method k do |variable|
# #         self.class.new(@path + "&#{v}=#{variable}&md=dpsrf")
# #       end
# #     end

# #     private

# #     def full_path
# #       "http://api.datamuse.com#{@path}"
# #     end
# #   end
# # end

# # # module DataMuse
# # #   class Response
# # #     attr_reader :payload, :list

# # #     def initialize(response)
# # #       @payload = response.payload
# # #       @list = @payload.map(&:word)
# # #     end
# # #   end
# # # end

# # module User
# #   def self.make_request
# #     Prompt::Request.new.answer.send
# #   end

# #   def self.get_(response)
# #     Prompt::Response.new(response).answer
# #   end

# #   def self.more_(response)
# #     Prompt.select(response)
# #   end
# # end


# # module Prompt
# #   class Request
# #     attr_accessor :endpoint, :constraint, :variable

# #     def initialize()
# #       @endpoint = endpoint
# #       @constraint = constraint
# #       @variable = variable
# #     end

# #     def answer
# #       prompt = TTY::Prompt.new
# #       choices = DataMuse::CONSTRAINTS.keys.map(&:to_s)
# #       @endpoint = prompt.select('words or sug?', %w[words sug])
# #       @constraint = prompt.select('choose a constraint', choices, per_page: 15) if @endpoint == 'words'
# #       @constraint = 's' if @endpoint == 'sug'
# #       @variable = prompt.ask('what word?')
# #       self
# #     end

# #     def send
# #       response = DataMuse.send(@endpoint).send(@constraint, @variable).fetch
# #       Show.response(response)
# #     end
# #   end
# # end

# # module Prompt
# #   class Response
# #     attr_reader :list, :selected

# #     def initialize(response)
# #       @response = response
# #     end

# #     def answer
# #       prompt = TTY::Prompt.new
# #       choices = %w[again more quit]
# #       more = prompt.select('Would you like more info on a word?, search again?, or quit', choices, per_page: 15)
# #       if more == 'quit'
# #         exit
# #       elsif more == 'again'
# #         response = Prompt::Request.new.answer.send
# #         self.class.new(response).answer
# #       elsif more == 'more'
# #         Prompt.select(@response)
# #       end
# #     end
# #   end
# # end

# # module Prompt
# #   extend self
# #   attr_reader :response, :selection

# #   def select(response)
# #     prompt = TTY::Prompt.new
# #     choices = response.map(&:word)
# #     selection = prompt.select('which word?', choices, per_page: 15)
# #     @selection = response.payload.select { |s| s[:word] == selection }[0]
# #     Show.response(@selection)
# #   end
# # end

# # module Show
# #   extend self
# #   def self.response(response)
# #     puts response.payload.map(&:word)
# #   end

# #   def self.word(word)
# #     word.each
# #     word.tap do |w|

# #     w.defs.each { |e| puts e } if w.defs && w.defs.length.positive?
# # detail = <<-EOF
# # #{w.word} #{w.tags[0]}   #{w.tags[1]}
# # #{w.defHeadword}
# # score: #{w.score}   syllables: #{w.numSyllables}  frequency: #{w.tags[2]}
# # #{wdefs}
# # _______________________
# # EOF
# # puts detail
# #     end
# #   end
# # end





# # loop do
# #   @response = Prompt::Request.new.answer.send
# #   Prompt::Response.new(response).answer
# #   Prompt.select(@response)
# # end


# # @response = Prompt::Request.new.answer.send
# # Prompt::Response.new(@response).answer
# # Prompt::select(@response)





# # # class BaseService
# # #   private_class_method :new

# # #   def self.call(*args)
# # #     new(*args).call
# # #   end
# # # end

# # # class YourService < BaseService

# # #   def initialize(first_var, second_var)
# # #     self.first_var = first_var
# # #     self.second_var = second_var
# # #   end

# # #   def call
# # #     puts first_var
# # #     puts second_var
# # #   end

# # #   private

# # #   attr_accessor :first_var, :second_var
# # # end



# # require 'blanket'
# # require 'tty-prompt'


# # module DataMuse
# #   def self.words
# #     Request.new('/words?')
# #   end

# #   def self.sug
# #     Request.new('/sug?')
# #   end
# # end

# # module DataMuse
# #   CONSTRAINTS = {
# #     sounds_like: :sl,
# #     means_like: :ml,
# #     spelled_like: :sp,
# #     nouns_describing: :rel_jja,
# #     adjectives_describing: :rel_jjb,
# #     synonymos_with: :rel_syn,
# #     trigger: :rel_trg,
# #     antonyms_of: :rel_ant,
# #     kind_of: :rel_spc,
# #     more_general_than: :rel_gen,
# #     comprise: :rel_com,
# #     part_of: :rel_par,
# #     frequently_follow: :rel_bga,
# #     frequently_preceed: :rel_bgb,
# #     rhyme_with: :rel_rhy,
# #     kinda_rhyme_with: :rel_nry,
# #     sound_alike: :rel_hom,
# #     consonants_match: :rel_cns,
# #     left_context: :lc,
# #     right_context: :rc,
# #     max: :max,
# #     topics: :topic,
# #     s: :s,
# #     v: :vocabulary
# #   }
# # end

# # module DataMuse
# #   class Request
# #     def initialize(path)
# #       @path = path
# #     end

# #     def fetch
# #       Blanket.wrap(full_path).get
# #     end

# #     DataMuse::CONSTRAINTS.each do |k, v|
# #       define_method k do |variable|
# #         self.class.new(@path + "&#{v}=#{variable}&md=dpsrf")
# #       end
# #     end

# #     private

# #     def full_path
# #       "http://api.datamuse.com#{@path}"
# #     end
# #   end
# # end


# # module RequestPrompt
# #   extend self
# #   def select
# #     prompt = TTY::Prompt.new
# #     choices = DataMuse::CONSTRAINTS.keys.map(&:to_s)
# #     endpoint = prompt.select('words or sug?', %w[words sug])
# #     constraint = prompt.select('choose a constraint', choices, per_page: 15) if endpoint == 'words'
# #     constraint = 's' if endpoint == 'sug'
# #     variable = prompt.ask('what word?')
# #     response = DataMuse.send(endpoint).send(constraint, variable).fetch
# #     Show.response(response)
# #   end
# # end


# # module ResponsePrompt
# #   extend self

# #   attr_reader :response
# #   def select(response)
# #     @response = response
# #     prompt = TTY::Prompt.new
# #     choices = %w[info again quit]
# #     menu = prompt.select('Would you like more info on a word?, search again?, or quit', choices, per_page: 15)
# #     if menu == 'quit'
# #       exit
# #     elsif menu == 'again'
# #       new_response = RequestPrompt.select
# #       ResponsePrompt.select(new_response)
# #     elsif menu == 'info'
# #       puts @response
# #       MorePrompt.select(@response)
# #     end
# #   end
# # end

# # module MorePrompt
# #   extend self
# #   def select(response)
# #     prompt = TTY::Prompt.new
# #     choices = response.map(&:word)
# #     selection = prompt.select('which word?', choices, per_page: 15)
# #     selection = response.payload.select { |s| s[:word] == selection }[0]
# #     Show.response(selection)
# #   end
# # end


# # module Show
# #   extend self
# #   def self.response(response)
# #     puts response.payload.map(&:word)
# #   end

# #   def self.word(word)
# #     word.each
# #     word[0].tap do |w|
# #     w.defs.each { |e| puts e } if w.defs && w.defs.length.positive?
# # detail = <<-EOF
# # #{w.word} #{w.tags[0]}   #{w.tags[1]}
# # #{w.defHeadword}
# # score: #{w.score}   syllables: #{w.numSyllables}  frequency: #{w.tags[2]}
# # _______________________
# # EOF
# # puts detail
# #     end
# #   end
# # end






# # Show = lambda do |word|
# #  word.tap do |w|











# # # class YourService < BaseService

# # #   def initialize(first_var, second_var)
# # #     self.first_var = first_var
# # #     self.second_var = second_var
# # #   end

# # #   def call
# # #     puts first_var
# # #     puts second_var
# # #   end

# # #   private

# # #   attr_accessor :first_var, :second_var
# # # end


# # require 'highline/import'




# # module Choices
# #   extend self
# #   def endpoint
# #     %w[words sug]
# #   end

# #   def constraint
# #     DataMuse::CONSTRAINTS.keys.map(&:to_s)
# #   end

# #   def second_prompt
# #     %w[more again quit]
# #   end

# #   def third_prompt
# #     %w[again quit]
# #   end
# # end

# # module Questions
# #   extend self

# #   def endpoint
# #     ask('words or sug?', Choices.endpoint)
# #   end

# #   def constraint
# #     ask('which constraint?', Choices.constraint)
# #   end

# #   def variable
# #     ask('which word? ')
# #   end

# #   def second_prompt
# #     ask('would you like to see more info? search again or quit?', Choices.second_prompt)
# #   end

# #   def second_prompt_more(response)
# #     ask('which word? ', response.map(&:word))
# #   end

# #   def third_prompt
# #     ask('search again or quit?', Choices.third_prompt)
# #   end
# # end

# # class FirstPrompt
# #   attr_accessor :endpoint, :constraint, :variable
# #   attr_reader :selection

# #   def initialize()
# #     @endpoint, @constraint, @variable, @selection = endpoint, constraint, variable, selection
# #   end

# #   def selection(selection=DataMuse.send(@endpoint).send(@constraint, @variable).fetch)
# #     @selection = selection
# #  #   Show.response(@selection)
# #   end

# #   def endpoint(endpoint=Questions.endpoint)
# #     @endpoint = endpoint
# #   end

# #   def constraint
# #     @endpoint == 'words' ? @constraint = Questions.constraint : @constraint = 's'
# #   end

# #   def variable(variable=Questions.variable)
# #     @variable = variable
# #   end
# # end

# # class SecondPrompt
# #   attr_accessor :selected

# #   def initialize(response)
# #     @response = response
# #   end

# #   def call(selection=Questions.second_prompt)
# #     exit if selection == 'quit'
# #     FirstPrompt.new.call if selection == 'again'
# #     self.more if selection == 'more'
# #   end

# #   def more
# #     selection=Questions.send(second_prompt_more, @response)
# #     Show.word(@response.select{ |s| s.word == selection })
# #   end
# # end

# # class ThirdPrompt

# #   def initialize()
# #   end

# #   def call(selection=Questions.third_prompt)
# #     selection == 'quit' ? exit : FirstPrompt.new.call
# #   end
# # end




# # require 'blanket'
# # require 'highline/import'


# # module DataMuse
# #   def self.words
# #     Request.new('/words?')
# #   end

# #   def self.sug
# #     Request.new('/sug?')
# #   end
# # end

# # module DataMuse
# #   CONSTRAINTS = {
# #     sounds_like: :sl,
# #     means_like: :ml,
# #     spelled_like: :sp,
# #     nouns_describing: :rel_jja,
# #     adjectives_describing: :rel_jjb,
# #     synonymos_with: :rel_syn,
# #     trigger: :rel_trg,
# #     antonyms_of: :rel_ant,
# #     kind_of: :rel_spc,
# #     more_general_than: :rel_gen,
# #     comprise: :rel_com,
# #     part_of: :rel_par,
# #     frequently_follow: :rel_bga,
# #     frequently_preceed: :rel_bgb,
# #     rhyme_with: :rel_rhy,
# #     kinda_rhyme_with: :rel_nry,
# #     sound_alike: :rel_hom,
# #     consonants_match: :rel_cns,
# #     left_context: :lc,
# #     right_context: :rc,
# #     max: :max,
# #     topics: :topic,
# #     s: :s,
# #     v: :vocabulary
# #   }
# # end

# # module DataMuse
# #   class Request
# #     def initialize(path)
# #       @path = path
# #     end

# #     def fetch
# #       Blanket.wrap(full_path).get
# #     end

# #     DataMuse::CONSTRAINTS.each do |k, v|
# #       define_method k do |variable|
# #         self.class.new(@path + "&#{v}=#{variable}&md=dpsrf")
# #       end
# #     end

# #     private

# #     def full_path
# #       "http://api.datamuse.com#{@path}"
# #     end
# #   end
# # end

# # class Prompt
# #   attr_accessor :question, :choices, :answer

# #   def prompt(choices=nil)
# #     @answer = ask(question, choices)
# #   end
# # end

# # class Endpoint < Prompt
# #   def question
# #     'words or sug?'
# #   end

# #   def choices
# #     %w[words sug]
# #   end

# #   def prompt
# #     puts '[words] returns a list of words based upon a given constraint. [sug] will return a list of words based upon a partial word given.'
# #     super
# #   end
# # end

# # class Constraint < Prompt
# #   def question
# #     'which constraint?'
# #   end

# #   def choices
# #     DataMuse::CONSTRAINTS.keys.map(&:to_s)
# #   end

# #   def prompt
# #     puts choices * ", "
# #     super
# #   end
# # end

# # class Variable < Prompt
# #   def question
# #     'which word?'
# #   end
# # end

# # class SecondMenu < Prompt
# #   def question
# #     'would you like to see [more] info? search [again] or [quit]?'
# #   end

# #   def choices
# #     %w[more again quit]
# #   end
# # end

# # class SecondMenuExtended < Prompt
# #   def question
# #     'which word?'
# #   end

# #   def choices(choices)
# #     choices.payload.map(&:word)
# #   end
# # end

# # class ThirdMenu < Prompt
# #   def question
# #     'search again or quit?'
# #   end

# #   def choices
# #     %w[again quit]
# #   end
# # end


# # class CLI
# #   def call
# #     @endpoint = Endpoint.new
# #     @constraint = Constraint.new
# #     @variable = Variable.new
# #     @second_menu = SecondMenu.new
# #     @second_menu_extended = SecondMenuExtended.new
# #     @third_menu = ThirdMenu.new
# #     start
# #   end

# #   def start
# #     @endpoint.prompt
# #     @constraint.prompt if @endpoint.answer == 'words'
# #     @variable.prompt

# #     @answer = DataMuse.send(@endpoint.answer).send(@constraint.answer, @variable.answer).fetch
# #     puts @answer.map(&:word)

# #     @second_menu.prompt
# #       case @second_menu.answer
# #       when 'quit' then exit
# #       when 'again' then start
# #       when 'more' then @second_menu_extended.prompt
# #       end

# #     @answer = DataMuse.send('words').send('spelled_like', @second_menu_extended.answer).fetch
# #     @answer[0].tap do |t|
# #         puts t.map(&:word)
# #         puts t.map(&:defs)
# #         puts t.map(&:tags)
# #       end

# #     @third_menu.prompt
# #     exit if @third_menu.answer == 'quit'
# #     start if @third_menu.answer == 'again'
# #   end

# # end







# # fix where if select 'sug' it doesn't ask for constraint


# # fix where if more is selected after sug...it will provide the entire word options..not just the word and score





# # choices = DataMuse::CONSTRAINTS.keys.map(&:to_s)
# #       add_spaces = -> (word) { "#{word}#{' ' * (24 - word.length)}" }         
# #       newchoices = []
# #       choices.each{ |choice| newchoices << add_spaces.(choice) }
# #       newchoices.each_slice(5){ |choice| puts choice * "" }
# #     end


# # newchoices = []

# # def choices(choices)
# #   @choices = choices
# # end

# # def add_spaces(word)
# #    "#{word}#{' ' * (24 - word.length)}"
# # end

