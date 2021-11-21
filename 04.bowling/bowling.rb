#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10 << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << if s == [10, 0]
              [s.shift]
            else
              s
            end
end

frames = case frames.size
         when 12
           frames[0..8] + [frames[9..11].flatten] + frames[10..11]
         when 11
           frames[0..8] + [frames[9..10].flatten] + [frames[10]]
         else
           frames[0..9]
         end

point = 0
frames[0..9].each_with_index do |frame, i|
  point += if frame[0] == 10 && frames[i + 1][0] == 10
             frames[i + 1][0] + frames[i + 2][0] + 10
           elsif frame[0] == 10
             frames[i + 1][0] + frames[i + 1][1] + 10
           elsif frame.sum == 10
             frames[i + 1][0] + 10
           else
             frame.sum
           end
end
puts point
