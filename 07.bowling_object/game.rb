# frozen_string_literal: true

require './shot'
require './frame'

class Game
  attr_reader :scores

  STRIKE = 10

  def initialize(scores)
    @scores = scores
  end

  def main
    shots = Shot.prepare(scores)
    frames = Frame.prepare(shots)
    calculate_score(frames)
  end

  private

  def calculate_score(frames)
    point = 0
    (frames + [nil, nil]).each_cons(3).with_index do |next_frames, index|
      point += if next_frames[0].strike? && !last_frame?(index)
                 strike_with_bonus(next_frames)
               elsif next_frames[0].spare? && !last_frame?(index)
                 spare_with_bonus(next_frames)
               else
                 next_frames[0].sum
               end
    end
    puts point
  end

  def strike_with_bonus(next_frames)
    if next_frames[1].first_shot == STRIKE && !next_frames[2].nil?
      STRIKE + STRIKE + next_frames[2].first_shot
    else
      STRIKE + next_frames[1].first_shot + next_frames[1].second_shot
    end
  end

  def spare_with_bonus(next_frames)
    10 + next_frames[1].first_shot
  end

  def last_frame?(index)
    index == 9
  end
end

game = Game.new(ARGV[0])
game.main
