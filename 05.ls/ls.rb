#!/usr/bin/env ruby
# frozen_string_literal: true

class List
  CULUMN = 3

  def main
    lists = []
    ljust.each_slice(slice) do |n|
      if n.size == slice
        lists << n
      else
        last_files = last.unshift(n).flatten
        last_files.pop(n.size)
        lists << last_files
      end
    end

    lists.transpose.each { |n| puts "#{n.join(' ')}\n" }
  end

  def fetch_files
    Dir.glob('*')
  end

  def slice
    fetch_files.size / CULUMN + 1
  end

  def last
    Array.new(slice, nil)
  end

  def ljust
    length = fetch_files.map(&:length)
    list_ljust = length.max + 1
    fetch_files.map { |file| file.to_s.ljust(list_ljust) }
  end
end

list = List.new
list.main
