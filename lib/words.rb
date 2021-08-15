# frozen_string_literal: true

require 'http'
require 'pry'

require_relative 'words/version'
require_relative 'words/request'
require_relative 'words/menu'
require_relative 'words/response'
require_relative 'words/session'
require_relative 'words/cli'

module Words
  class Error < StandardError; end
  # Your code goes here...

  Ask = Proc.new { |question| puts question ; gets.strip }
end
