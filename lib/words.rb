# frozen_string_literal: true

#require 'blanket'
require 'highline/import'
require 'http'
require 'recursive-open-struct'

require_relative 'words/version'
require_relative 'words/damu'
require_relative 'words/prompt'
require_relative 'words/request'
require_relative 'words/cli'

  module Show
    extend self

    def detail(word)
      @word = RecursiveOpenStruct.new(word)
        puts %(
      #{@word.word}  #{@word.tags}  #{@word.score}  #{@word.numSyllables}
      #{@word.defHeadword}
      )
      @word.defs.each{ |e| puts e }
    end

    def word(words)
      words.each do |e|
        @word = RecursiveOpenStruct.new(e)
        puts @word.word
      end
    end
  end
