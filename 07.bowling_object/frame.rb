# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  STRIKE = 10

  def initialize(first_shot, second_shot = 0, third_shot = 0)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def self.declare(shots)
    frames = []
    frame = []
    shots.each do |shot|
      frame << shot

      if frames.size < 10
        if frame.size >= 2 || shot == 10
          frames << frame.dup
          frame.clear
        end
      else
        frames.last << shot
      end
    end
    frames
  end

  def self.prepare(shots)
    frames = declare(shots)
    frames.map { |frame| Frame.new(*frame) }
  end

  def strike?
    first_shot == STRIKE
  end

  def spare?
    !strike? && first_shot + second_shot == 10
  end

  def sum
    first_shot + second_shot + third_shot
  end
end
