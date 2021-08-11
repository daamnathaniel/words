class CLI

  def call
    initial
    main_menu
  end

  
  def greeting
    Say.("welcome to words")
  end

  def initial
    greeting
    Say.("your options are either [words] or [sug]gestions.")
    Say.("Words will provide a list of words from a given vocabulary that match a given set of constriants.")
    Say.("The suggestions list is made from a partially-entered query using a combination of the operations described in the '/words' resource above.")
  end

  def main_menu
     make = MakeRequest.new
     @request = make.request
     make.user_choose(:endpoint, Ask.("choose [words] or [sug]gestions" ))
     if @request.endpoint == "words" 
  	   make.user_choose(:constraint, Ask.("which constraint? "))
	   make.constraint(Constraints[constraint])
       make.user_choose(:variable, Ask.("which variable?" ))
     elsif @request.endpoint == "sug"
       make.constraint("s")
       make.user_choose(:variable, Ask.("which variable?" ))
     elsif  @request.endpoint == "quit"
       exit
     end
     make.path
     make.response
   end

end


require 'http'

Ask = Proc.new { |question| puts question; gets.strip }
Say = Proc.new { |statement| puts statement }

Constraints = { "sounds_like" => "sl", "spelled_like" => "sp", "means_like" => "ml" }

class Request < Struct.new(:endpoint, :constraint, :variable, :path)
end

class MakeRequest
   attr_accessor :request, :response
   def initialize
     @request = Request.new
   end

   def endpoint(endpoint)
     @request.endpoint = endpoint
   end

   def constraint(constraint)
     @request.constraint = Constraints[constraint]
   end

   def variable(variable)
     @request.variable = variable
   end

   def request
     @request
   end

   def path
     @request.path = "https://api.datamuse.com/#{@request.endpoint}?#{@request.constraint}=#{@request.variable}&md=dpsrf"
   end

   def response
     response = HTTP.get(@request.path)
     @response = JSON.parse(response, {:serialize_names => true})
   end

   def user_choose(func, args)
     method(func).call(args)
   end
 end


class Word < OpenStruct
end

class Words
  attr_accessor :all, :recent

  @@all = {}

  def initialize(response)
    @recent = []
    @results = response.each do |r|	
      r_word = r["word"]
      r_word = Word.new(r)
      self.add(r_word)
    end
  end

  def self.all
    @@all
  end

  def self.recent
    @recent
  end
      
  def add(word)
    @recent << word[:word] 
    @@all[word[:word]] = word
  end

  def self.find(word)
     @@all[word.to_sym]
  end
end







