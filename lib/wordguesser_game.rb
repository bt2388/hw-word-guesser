class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_reader :guesses, :wrong_guesses
  attr_accessor :word

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.to_s.empty?
    letter = letter.to_s.downcase
    raise ArgumentError unless letter.match?(/\A[a-z]\z/)

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      false
    elsif @word.downcase.include?(letter)
      @guesses += letter
      true
    else
      @wrong_guesses += letter
      true
    end
  end

  def word_with_guesses
    @word.each_char.map { |c| @guesses.include?(c.downcase) ? c : '-' }.join
  end

  def check_win_or_lose
    return :lose if @wrong_guesses.length >= 7
    return :win if word_with_guesses !~ /-/
    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord')
    Net::HTTP.new('esaas-randomword-27a759b6224d.herokuapp.com').start do |http|
      return http.post(uri, "").body
    end
  end

  
end
