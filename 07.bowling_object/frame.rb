# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = 0, third_shot = 0)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def self.declare(shots)
    frames = []
    frame = []
    shots.map do |shot|
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
    overwrite_frames = []
    frames.each do |frame|
      frame = Frame.new(*frame)
      overwrite_frames << frame
    end
    overwrite_frames
  end
end
