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

    frames.each_with_index do |frame, index|
      left_frames = left_frames(frames, index)
      point += if strike?(frame) && last_frame?(index) == false
                 strike_with_bonus(left_frames)
               elsif spare?(frame) && last_frame?(index) == false
                 spare_with_bonus(left_frames)
               else
                 sum(frame)
               end
    end
    puts point
  end

  def left_frames(frames, index)
    left_frames = frames.slice(index, 3)
    {
      frame: left_frames[0],
      next_frame: left_frames[1],
      after_next_frame: left_frames[2]
    }
  end

  def strike_with_bonus(left_frames)
    if left_frames[:after_next_frame].nil?
      STRIKE + left_frames[:next_frame].first_shot + left_frames[:next_frame].second_shot
    elsif left_frames[:next_frame].first_shot == STRIKE
      STRIKE + STRIKE + left_frames[:after_next_frame].first_shot
    else
      STRIKE + left_frames[:next_frame].first_shot + left_frames[:next_frame].second_shot
    end
  end

  def spare_with_bonus(left_frames)
    10 + left_frames[:next_frame].first_shot
  end

  def strike?(frame)
    frame.first_shot == 10
  end

  def spare?(frame)
    frame.first_shot + frame.second_shot == 10
  end

  def sum(frame)
    frame.first_shot + frame.second_shot + frame.third_shot
  end

  def last_frame?(index)
    index == 9
  end
end

game = Game.new(ARGV[0])
game.main
