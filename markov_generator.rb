# USAGE:
# ./markov_generator file1 file2 file3 seed_word

require 'pry'
PRECISION = 10000
ROUND_VALUE = Math.log(PRECISION, 10).round

class Word
  attr_accessor :count
  def initialize
    @count = 0
  end

  def prob total_count
    @count.to_f / total_count
  end
end
class Entry
  attr_accessor :total_words
  def initialize preceding_word
    @words = Hash.new
    @preceding_word = preceding_word
    @total_words = 0
    @determiner = Array.new PRECISION, nil
  end

  def add_word word
    # access internal entry for word
    # and increment counter and adjust probability
    @total_words += 1

    if @words[word].nil?
      @words[word] = Word.new
    end
    @words[word].count += 1
  end

  def recalculate_determiner
    current_end = 0
    puts "Preceding Word: #{@preceding_word}"
    @words.each_pair do |key, value|
      new_end = current_end + (value.prob(@total_words).round(ROUND_VALUE) * PRECISION).round
      puts "\t#{key}\t prob\t#{value.prob(@total_words).round(ROUND_VALUE)}\t [#{current_end}, #{new_end}]"
      @determiner.fill(key, current_end..new_end)
      current_end = new_end
    end
    if current_end != PRECISION
      puts current_end
    end
  end

  def get_value
    # pick from the current words according to their probabilities
    # so if you have 2 words, A with 2 occurrences and B with 4, then
    # A has a 1/3 chance and B has a 2/3 chance of being picked
    #
    return @determiner[rand(PRECISION)]
  end
end

freq = Hash.new
# 0..-2 gives from the first element to the second to last element
# [0,1,2,3,4][0..-2] => [0,1,2,3]
ARGV[0..-2].each do |f|
  words = File.open(f, 'r').read.split(' ')
  words.each_cons(2) do |word_tuple|
    key = word_tuple.first.downcase
    if freq[key].nil?
      freq[key] = Entry.new key
    end
    freq[key].add_word word_tuple.last.downcase
  end
end

total_words = 0
freq.each_pair do |key, value|
  value.recalculate_determiner
  total_words += value.total_words
end

puts "Model contains #{total_words} words"

current_seed = ARGV.last
if freq[current_seed].nil?
  current_seed = freq.keys.sample
end

puts "Trump on #{current_seed}:"
print "\"#{current_seed} "
loop do
  current = freq[current_seed].get_value
  print current
  current_seed = current
  if current.nil?
    puts ""
    puts "Current Seed: #{current_seed}"
  end
  if current.chars.last == '.'
    break
  else
    print " "
  end
end
puts '"'
