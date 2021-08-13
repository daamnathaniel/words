require 'http'
require 'fancy-open-struct'

Ask =-> question { puts question; gets.strip }
Say =-> statement { puts statement }


  module WordMethods
  word_methods = %w(sounds_like spelled_like means_like described_by often_describing synonymous_with triggered_by antonyms_of kind_of more_general_than comprised_of part_of frequently_follow frequently_preceed rhymes_with approximately_rhymes sound_alike consonants_match often_follow often_followed_by topics s)
  
  word_shorts = %w(sl sp ml rel_jja rel_jjb rel_syn rel_trg rel_ant rel_spc rel_gen rel_com rel_par rel_bga rel_bgb rel_rhy rel_nry rel_hom rel_cns lc rc topics s)

  zipped = word_methods.zip(word_shorts)
  Constraints = Hash[*zipped.flatten]
  end

  class Request < Struct.new(:base, :endpoint, :constraint, :variable, :path) 
  end

  class Make
    attr_accessor :request, :response
    def initialize
      @request = Request.new
	  @request.base = "https://api.datamuse.com"
    end
    
    def self.call
      new
    end
    
    def set_endpoint(endpoint = Ask.("choose [words] or [sug]getions."))
      @request.endpoint = endpoint
    end

    def set_constraint(constraint = Ask.("which constraint?"))
      @request.constraint = WordMethods::Constraints[constraint]
    end

    def set_variable(variable = Ask.("which variable?"))
      @request.variable = variable
    end
    
    def request
      @request
    end
     
    def build_path
      @request.path = "#{@request.base}/#{request.endpoint}?#{request.constraint}=#{request.variable}&md=dpsrf"
    end
    
    def get_response
      response = HTTP.get(@request.path)
      @response = JSON.parse(response, {:symbolize_names => true})
    end
    
    def wait_for_response
	  self.request
      self.build_path
      self.get_response
    end
  end
 
 
class Words
  attr_accessor :all
  @@all = {}
  
  def self.all
    @@all
  end
  
  def self.add(response)
    response.each do |result|
      word = result[:word]
      @word = word.gsub(" ", "_").to_sym
      @@all[@word] = FancyOpenStruct.new(result)
    end
  end
end
 
 
class Recent
  attr_accessor :all
  
  def self.all
    @@all
  end
  
  def self.add(response)
    @@all = []
    response.each do |result|
      @@all << result[:word]
    end
  end 
end 


class Presenter
  def initialize(words)
    @words = words
  end
  
  def words
    @words
  end
  
  def list
    @list = @words
    @list.each.with_index(1) do |item, index|
      puts "#{index}.#{item[:word]}"
    end
  end
  
  def list_select(index)
    select = index.to_i - 1
    @list[select]
  end
  
  def word
    @words.tap do |w|
      puts %Q(
#{w[:word]}  #{w[:tags]} #{w[:defHeadword]} 
#{w[:defs]}  
#{w[:score]} #{w[:numSyllables]}
	)
	end
  end
end
  
  
module Present
  extend self
  def self.words(words)
    @words = words 
    case @words
    when @words.is_a?(Array)
      @words.each.with_index do |index, w| 
      puts "#{index}. #{w}"
      end
    when @words.is_a?(Hash)
      @words_keys = @words.keys
      Present.words(@words_keys)
    when @words.is_a?(String)
      puts @words.split("")
    else
      puts @words
    end
  end
end
  
  
  
  
  
  

  have_user = Make.new
  
  have_user.set_endpoint
  have_user.set_constraint
  have_user.set_variable
  have_user.wait_for_response
  response = have_user.response

  Words.add(response)
  Recent.add(response)
  present = Presenter.new(response)
  present.list
  
    
    
    module SearchAgain
      extend self
      def present
        puts "search again"
      end
      
      def execute
        puts "searching again"
      end  
    end
    
    
    module MoreInfo
      extend self
      def present
        puts "more info"
      end
      
      def execute
        answer = Ask.("more info on which word (select a number)?")
        menu.present.list_select(answer.to_i)
      end
    end
    
    module Quit
      extend self
      def present
        puts "exit program"
      end
      
      def execute
        Say.("goodbye")
      end
    end
    
    class Menu
      def initialize(options)
        @options = [options]
        @present = Presenter.new(@options)
      end
      
      def present
        @present
      end
      
      
      def chosen(mod)
        @chosen = mod
        @chosen.present
        @chosen.execute
      end
    end
    
    
 module Menu
   extend self
    def select(selection)
	 case selection
	 when selection == "more info" then puts "more info"
	 when selection == "search again" then puts "search again"
	 when selection == "quit" then puts "quit"
	 else
     end
 end 



