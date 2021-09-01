module Words

  Query = Struct.new(:question, :options)

  
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
      @extended = Query.new('which word?', res)
    end
    
    def prompt
      @second_answer = PromptSelect.call(@second)
      case @second_answer
      when :again then CLI.new.call
      when :quit then CLI.new.finish
      when :more then extend
      end
      @extended_answer = PromptSelect.call(@extended)
      call
    end
    
    def call
      resp = S.words_fetch('words', 'spelled_like', @extended_answer).payload[0]
    end
  end
  
  
  class ThirdMenu
    
    def initialize(third)
      @third = third
    end

    def prompt
      @third_answer = PromptSelect.call(@third)
      case @third_answer
      when :again then CLI.new.call
      when :quit then CLI.new.finish
      end
    end
  end

end