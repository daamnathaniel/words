# frozen_string_literal: true
module Words
  class CLI
    def call
      @endpoint = Endpoint.new
      @constraint = Constraint.new
      @variable = Variable.new
      @second_menu = SecondMenu.new
      @second_menu_extended = SecondMenuExtended.new
      @third_menu = ThirdMenu.new
      start
    end

    def start
      @endpoint.prompt
      if @endpoint.answer == 'words'
        @constraint.prompt
      else @endpoint.answer == 'sug'
        @constraint.answer = 's'
      end
      @variable.prompt

      @answer = DataMuse.send(@endpoint.answer).send(@constraint.answer, @variable.answer).fetch
      Show.word(@answer)

      @second_menu.prompt
      case @second_menu.answer
      when 'quit' then exit
      when 'again' then start
      when 'more' then @second_menu_extended.prompt
      end

      @answer = DataMuse.send('words').send('spelled_like', @second_menu_extended.answer).fetch
      Show.detail(@answer[0])

      @third_menu.prompt
      case @third_menu.answer
      when 'quit' then exit
      when 'again' then start
      end
        # exit if @third_menu.answer == 'quit'
        # start if @third_menu.answer == 'again'
    end
  end
end
