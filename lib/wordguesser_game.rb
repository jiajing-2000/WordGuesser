class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  # Takes a letter and checks if it is in the word.
  # Returns true if the letter is in the word, false otherwise.
  # Also updates the @guesses or @wrong_guesses instance variables.
  # A letter that has already been guessed or is a non-alphabet character is considered "invalid", i.e. it is not a "valid" guess
  def guess(letter)
    valid = false
    if letter == '' or letter == nil or !letter.match(/[a-zA-Z]/)
      raise ArgumentError
    end
    letter.downcase!
    if @word.include? letter
      if !@guesses.include? letter
        @guesses << letter
        return true
      end
    else
      if !@wrong_guesses.include? letter
        @wrong_guesses << letter
        return true
      end
    end
    return false
  end

  # Returns a string with the letters that have been guessed so far.
  def word_with_guesses
    word = ''
    @word.each_char do |c|
      if @guesses.include? c
        word << c
      else
        word << '-'
      end
    end
    return word
  end

  # Checks whether the whole word has been guessed.
  def check_win_or_lose
    if @wrong_guesses.length >= 7
      return :lose
    elsif word_with_guesses == @word
      return :win
    else
      return :play
    end
  end

end
