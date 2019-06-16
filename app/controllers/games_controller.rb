require 'JSON'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    letters = ('A'..'Z').to_a
    10.times do
      @letters << letters.sample
    end
  end

  def score
    end_time = Time.now
    @result = {}
    @result[:time] = (end_time.to_f - params['start_time'].to_f)
    filepath = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word = open(filepath).read
    word = JSON.parse(word)
    check(@result)
  end

private

  def check(result)
    if included?(params[:word], params[:grid]) == false
      result[:message] = "Sorry but #{params[:word]} can't be built out of #{params[:grid]}"
    end
    if english_word?(params[:word]) == false
      result[:message] = "Sorry but #{params[:word]} does not seem to be a valid English word..."
    end
    if english_word?(params[:word]) == true
      result[:message] = "Congratulations! #{params[:word]} is a valid English word!"
    end
    result[:message]
  end
  def included?(guess, grid)
    guess = params[:word]
    grid = params[:grid]
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = ("https://wagon-dictionary.herokuapp.com/#{word}")
    word = open(response).read
    word = JSON.parse(word)
    word['found']
  end

end
