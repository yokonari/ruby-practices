#!/usr/bin/env ruby
# frozen_string_literal: true

class BasicList
  CULUMN = 3

  def main
    lists = []
    ljust_files.each_slice(calculate_row_count) do |n|
      if n.size == calculate_row_count
        lists << n
      else
        last_files = create_last_line.unshift(n).flatten
        last_files.pop(n.size)
        lists << last_files
      end
    end

    lists.transpose.each { |n| puts "#{n.join(' ')}\n" }
  end

  def fetch_files
    Dir.glob('*')
  end

  def calculate_row_count
    if fetch_files.size > CULUMN
      fetch_files.size / CULUMN + 1
    else
      1
    end
  end

  def create_last_line
    Array.new(calculate_row_count, nil)
  end

  def ljust_files
    length = fetch_files.map(&:length)
    list_ljust = length.max + 1
    fetch_files.map { |file| file.to_s.ljust(list_ljust) }
  end
end

list = BasicList.new
list.main
