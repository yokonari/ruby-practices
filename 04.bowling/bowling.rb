#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each {|s| s == 'X' ? shots << 10 << 0 : shots << s.to_i}

frames = shots.each_slice(2).to_a

frames = frames[0..8] + [frames[9..].flatten] + frames[10..]

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
