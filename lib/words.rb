# frozen_string_literal: true

require 'recursive-open-struct'
require 'pry'
require 'tty-prompt'
require 'blanket'

require_relative 'words/version'
require_relative 'words/damu'
require_relative 'words/prompt'
require_relative 'words/request'
require_relative 'words/s'
require_relative 'words/service'
require_relative 'words/menu'
require_relative 'words/cli'

  # module Show
  #   extend self
  #   def detail(word)
  #     @word = RecursiveOpenStruct.new(word)
  #       puts %( #{@word.word}  #{@word.tags}  #{@word.score}  #{@word.numSyllables}
  # #{@word.defHeadword} )
  # puts @word.defs if @word.methods.include?(:defs)
  #   end

  #   def word(words)
  #     words.each do |e|
  #       @word = RecursiveOpenStruct.new(e)
  #       puts @word.word
  #     end
  #   end
  # end

