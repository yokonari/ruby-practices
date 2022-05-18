# frozen_string_literal: true

class Shot
  attr_reader :shot

  def initialize(shot)
    @shot = shot
  end

  def self.prepare(scores)
    shots = scores.split(',')
    shots.map { |shot| Shot.new(shot).convert_into_integer }
  end

  def convert_into_integer
    shot == 'X' ? 10 : shot.to_i
  end
end
