# frozen_string_literal: true

require 'yaml'

# This is a class for simulating Hangman game
class Hangman
  ALLOWED_GUESSES = 10

  filenames = './google-10000-english-no-swears.txt'
  array = File.readlines(filenames).map(&:chomp)
  sampled_word = array.select { |word| word.length.between?(5, 12) }.sample
  puts "Secret word is #{sampled_word}"
  copy_sampled_word = Array.new(sampled_word.length, ' ')
  guesses_letter = []
  ALLOWED_GUESSES.times do |idx|
    puts 'Game has the secret word. Please start your guess ...'
    puts "#{ALLOWED_GUESSES - idx} guesses left"
    puts 'Do you want to save the game? (y/n)'
    answer = gets.chomp.downcase

    if answer == 'y'
      state_to_serialize = {
        secret_word: sampled_word,
        demo_guessed_word: copy_sampled_word,
        guessed_letter: guesses_letter,
        remaining_guesses: ALLOWED_GUESSES - idx
      }

      File.open('hangman_play_logs.yaml', 'w') do |file|
        YAML.dump(state_to_serialize, file)
      end
    end
    guess = nil
    loop do
      guess = gets.chomp.downcase
      break unless guesses_letter.include?(guess)

      puts 'already try guess this character. guess a new character'
    end

    guesses_letter << guess
    puts "#{guess} is not in the word" unless sampled_word.include?(guess)
    indexes = sampled_word.chars.each_with_index.select do |val, idx|
      val == guess.downcase
    end.map { |val, idx| idx }

    indexes.each { |idx| copy_sampled_word[idx] = guess }
    puts copy_sampled_word.join('')
    break if copy_sampled_word.join.eql?(sampled_word)
  end
end
