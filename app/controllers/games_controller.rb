class GamesController < ApplicationController
  def new
    grid_size = 10;

    @letters = generate_grid(grid_size)
  end

  def score
    letters = params['letters'].split(" ")
    @word = params['word']

    if !valid_attempt?(@word, letters)
      @answer_message = "is not a combination of the grid's elements"
      @score = 0
    elsif !english_word?(@word)
      @answer_message = "is not an english word!"
      @score = 0
    else
      @answer_message = "Congratulations on a valid submission!"
      @score = calculate_score(@word, letters)

    end

    if session[:current_user_score] == nil
      session[:current_user_score] = @score
    else
      session[:current_user_score] += @score
    end

    @sessionScore = session[:current_user_score]

  end

  private

  def generate_grid(grid_size)
    grid_alpha = ('a'..'z').to_a
    grid = []
    grid_size.times { grid << grid_alpha.sample(1).join}
    return grid
  end

  def valid_attempt?(attempt, grid)
    attempt = attempt.clone
    grid.map(&:downcase).each do |letter|
      attempt.slice!(attempt.index(letter)) unless attempt.downcase.index(letter).nil?
    end
    return attempt.empty?
  end

  def english_word?(attempt)
    # binding.pry
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    raw_json = open(url).read # => send this : "https://wagon-dictionary.herokuapp.com/#{attempt}" # => read answer,
    answer = JSON.parse(raw_json)
    return answer["found"]
  end

  def calculate_score(attempt, grid)
    return attempt.length * attempt.length
  end


end
