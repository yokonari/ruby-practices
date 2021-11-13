#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0] # 引数(文字列)を受け取りscoreに代入
scores = score.split(',')
# scoreを','で分割して文字列の配列で返し、scoresに代入

shots = [] # 空の配列を作る
scores.each do |s|
  if s == 'X' # ストライクの場合
    shots << 10 << 0 # 配列shotsに10と0を追加
  else
    shots << s.to_i # 配列shotsにs(整数に変換)を追加
  end
end
# p shots

frames = [] # 空の配列を作る
shots.each_slice(2) do |s| # 配列shotsの2要素ずつに区切る
  frames << if s == [10, 0] # ストライクの場合
              [s.shift] # s.shiftで取り出した要素(10)を配列framesに追加
            else
              s
            end
end
# p frames

# p frames.size
case frames.size
when 12 # framesの要素が12の場合
  frames[9].concat(frames[10], frames[11]) # frames[9]~[11]を結合する
when 11
  frames[9].concat(frames[10])
else
  frames[9]
end
# p frames[9]

point = 0
frames[0..9].each_with_index do |frame, i| # 配列frames[0..9]の各要素にインデックスを付ける
  point += if frame[0] == 10 && frames[i + 1][0] == 10 # ストライクが2回続く場合
             frames[i + 1][0] + frames[i + 2][0] + 10
           # 次と次のフレームの1投目を加算
           elsif frame[0] == 10 # ストライクの場合
             (frames[i + 1][0] + frames[i + 1][1]) + 10
           # 次のフレームの1投目と2投目を加算
           elsif frame.sum == 10 # スペアの場合
             frames[i + 1][0] + 10
           # 次のフレームの1投目を加算
           else
             frame.sum
           end
  #  p "#{i}：#{frame} #{point}"
end
p point
