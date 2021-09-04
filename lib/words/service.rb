# frozen_string_literal: true

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

  # prompts with choices
  class PromptSelect < BaseService

    def call
      prompt = TTY::Prompt.new(active_color: :green)
      @answer = prompt.select(@question, per_page: 15, filter: true, cycle: true) do |menu|
        @options.each do |k, v|
          menu.choice k, v
        end
      end
    end
  end

  # prompts without choices
  class PromptAsk < BaseService

    def call
      prompt = TTY::Prompt.new(active_color: :yellow)
      @answer = prompt.ask(@question)
    end
  end
end
