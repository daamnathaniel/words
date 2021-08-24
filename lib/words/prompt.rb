# frozen_string_literal: true

module Words
  class Prompt
    attr_accessor :question, :choices, :answer

    def prompt(choices=nil)
      @answer = ask(question, choices)
    end
  end

  class Endpoint < Prompt
    def question
      'words or sug?'
    end

    def choices
      %w[words sug]
    end

    def prompt
      puts '[words] returns a list of words based upon a given constraint. [sug] will return a list of words based upon a partial word given.'
      super
    end
  end

  class Constraint < Prompt
    def question
      'which constraint?'
    end

    def choices
      DataMuse::CONSTRAINTS.keys.map(&:to_s)
    end

    def prompt
      puts choices * ", "
      super
    end
  end

  class Variable < Prompt
    def question
      'which word?'
    end
  end

  class SecondMenu < Prompt
    def question
      'would you like to see [more] info? search [again] or [quit]?'
    end

    def choices
      %w[more again quit]
    end
  end

  class SecondMenuExtended < Prompt
    def question
      'which word?'
    end

    def choices(choices)
      choices.payload.map(&:word)
    end
  end

  class ThirdMenu < Prompt
    def question
      'search again or quit?'
    end

    def choices
      %w[again quit]
    end
  end
end
