# USAGE:
# ./markov_generator file1 [file2 file3] [seed_word]

class MarkovEntry
  attr_accessor :total_words
  def initialize preceding_word
    @words = Hash.new
    @preceding_word = preceding_word
    @total_words = 0
    @cumulative = Array.new
  end

  def add_word word
    # access internal entry for word
    # and increment counter and adjust probability
    @total_words += 1

    if @words[word].nil?
      @words[word] = 0
    end
    @words[word] += 1
  end

  def calculate_probabilities
    # inverse transform sampling
    frequencies = @words.values
    @cumulative = Array.new frequencies.length, 0
    @cumulative[0] = frequencies[0]
    frequencies.each_with_index do |f, ind|
      @cumulative[ind] = @cumulative[ind - 1] + f if ind > 0
    end
  end

  def sample
    # inverse transform sampling
    random_index = @cumulative.bsearch_index{ |n| n >= rand(@cumulative.last) }
    return @words.keys[random_index]
  end
end

freq = Hash.new
ARGV.each do |f|
  if !f.end_with?(".txt")
    next
  end

  words = File.open(f, 'r').read.split(' ')
  words.each_cons(2) do |word_tuple|
    key = word_tuple.first.downcase
    if freq[key].nil?
      freq[key] = MarkovEntry.new key
    end
    freq[key].add_word word_tuple.last.downcase
  end
end

total_words = 0
freq.each_pair do |key, value|
  value.calculate_probabilities
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
  current = freq[current_seed].sample
  print current
  current_seed = current

  if current.chars.last == '.'
    break
  else
    print " "
  end
end
puts '"'
