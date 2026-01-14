# frozen_string_literal: true

require_relative 'serialize_deserialize_mixins'
# This class is for Hangman object
class Hangman
  include BasicSerializable

  attr_reader :secret_word

  def initialize(secret_word, guess_word, guess_letter, remaining_guess)
    @secret_word = secret_word
    @guess_word = guess_word
    @guess_letter = guess_letter
    @remaining_guess = remaining_guess
  end

  def won?
    @guess_word.none?('_')
  end

  def lost?
    @remaining_guess <= 0
  end

  def play
    display_word
    puts 'What letter to guess?'
    process_guess(gets.chomp.downcase)
  end

  def plays
    play until won? || lost?
    display_word

    if won?
      puts "Wins! secret_word is #{@secret_word}"
    else
      puts "Lose! secret word is #{@secret_word}"
    end
  end

  def display_word
    puts "Word: #{@guess_word.join(' ')}"
    puts "Already guessed letter: #{@guess_letter.inspect}"
    puts "Guesses left: #{@remaining_guess}"
  end

  def process_guess(letter)
    @guess_letter << letter
    if @secret_word.include?(letter)
      @secret_word.chars.each_with_index do |char, idx|
        @guess_word[idx] = char if char == letter
      end

      puts 'match!'
    else
      puts 'try another letter'
      @remaining_guess -= 1
    end
  end

  def self.random_word
    File.readlines('./google-10000-english-no-swears.txt').map(&:chomp).select do |word|
      word.length.between?(5, 12)
    end.sample
  end

  def self.create_new_game
    secret_word = random_word
    guess_word = Array.new(secret_word.length, '_')
    guess_letter = []
    remaining_guess = 10
    Hangman.new(secret_word, guess_word, guess_letter, remaining_guess)
  end
end

game = Hangman.create_new_game
game.plays
