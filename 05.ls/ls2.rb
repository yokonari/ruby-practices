#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class LS
  CULUMN = 3

  def main
    lists = []
    ljusted_files.each_slice(calculate_row_count) do |n|
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

  private

  def fetch_files
    opt = OptionParser.new

    params = {}
    opt.on('-a') { |v| params[:a] = v }
    opt.parse(ARGV)
    Dir.glob('*', params[:a] ? File::FNM_DOTMATCH : 0)
  end

  def calculate_row_count
    files_size = fetch_files.size
    if (files_size % CULUMN).zero?
      files_size / CULUMN
    else
      files_size / CULUMN + 1
    end
  end

  def create_last_line
    Array.new(calculate_row_count, nil)
  end

  def ljusted_files
    length = fetch_files.map(&:length)
    list_ljust = length.max + 1
    fetch_files.map { |file| file.to_s.ljust(list_ljust) }
  end
end

list = LS.new
list.main
