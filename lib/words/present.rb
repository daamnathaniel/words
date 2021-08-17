# def m
# <<-EOT.gsub(/^\s+/, '')

# EOT
# end

# .tap(&method(:puts))

class Results
  attr_accessor :words, :latest

  @@all = {}

  def initialize(words)
    @latest = []
    @words = words
    @latest << @words
  end

  def self.addto
    @words.each do |e|
      w = e.slice(:word, :defs, :tags)
      @latest << w
      @@all.store(w:word, w)
    end
  end

  def self.all
    @@all
  end

  def self.latest
    @latest
  end

  def self.word_list(part)
    @words.map { |e| e.select{|k,_| part.include? k } }
  end

  def self.numbered_list(part)
    @words.map.with_index(1) {|e| e.select{|k,_| part.include? k } }
  end

  def self.word_detail(word)
    detail = <<-EOT.gsub(/^\s+/, '')
      word[:word] word[:defs]
    EOT
    puts detail
  end
end
