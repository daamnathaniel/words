
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
    keyn = key
    key = DeepStruct.new(value)
    Diction.ary.store(keyn, key)
    Diction.latest.append(key)
  end
end




class Numbered
  def self.list
    Diction.latest.each.with_index(1) { |e, index| puts "#{index}. #{e}" }
  end
end

class Word
  def self.list
    Diction.latest.each { |e| puts e }
  end
end

class Detailed
  def self.list(word)
    Diction.ary[word].tap do |t|
puts %Q( #{t[:word]}
#{t[:tags]}
)
t[:defs].each{ |r| puts r }

    end
  end
end

class Detailed
  def self.lists(words)
    words.each do |w|
      Detailed.list(w.values[0])
    end
  end
end

# .tap(&method(:puts))



Diction.latest.each{ |e| puts e.values[0] }

Diction.latest.each.with_index(1){ |e, index| puts "#{index} #{e.values[0]}" }


