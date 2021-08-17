
module Words

  Ask = proc { |question| puts question ; gets.strip }

  Say = proc { |statement| puts statement }

  WORDMETHODS = {
    "sounds_like" => "sl",
    "spelled_like" => "sp",
    "means_like" => "ml"
  }

end

module Diction
  module_function

  attr_accessor :ary, :latest

  @@ary = {}
  @@latest = []

  def ary
    @@ary
  end

  def latest
    @@latest
  end

  def add(key, value)
    Diction.ary.store(key.to_sym, FancyOpenStruct.new(value))
    Diction.latest.append(key)
  end
end


class Numbered
  def list
    Diction.latest.each.with_index(1) { |e, index| puts "#{index}. #{e}" }
  end
end

class Word
  def list
    Diction.latest.each { |e| puts e }
  end
end

class Detailed
  def list(words)
    w = Diction.ary[words]
    w[]
