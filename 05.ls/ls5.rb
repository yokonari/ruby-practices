#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

class LS
  CULUMN = 3

  def main
    parse_option[:l] ? sort_horizontally : sort_vertical
  end

  private

  def parse_option
    opt = OptionParser.new

    params = {}
    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.on('-l') { |v| params[:l] = v }
    opt.parse(ARGV)
    params
  end

  def sort_vertical
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

  def fetch_files
    base = Dir.glob('*')
    parse_option[:a] ? base.unshift(Dir.glob('.*')).flatten! : base
    parse_option[:r] ? base.reverse : base
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

  def sort_horizontally
    calculate_block_count_total
    max_length = calculate_max_length

    fetch_files.each do |file|
      fs = File.lstat(file.to_s)
      file_type = { 'file' => '-', 'directory' => 'd', 'link' => 'l' }
      file_mode = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }

      type = file_type.fetch(fs.ftype)
      fs_mode = fs.mode.to_s(8).split('').last(3)
      mode = file_mode.fetch_values(fs_mode[0], fs_mode[1], fs_mode[2]).join
      nlink = fs.nlink
      uid = Etc.getpwuid(fs.uid).name
      gid = Etc.getgrgid(fs.gid).name
      size = fs.size

      printf "%s%s %#{max_length.fetch(:nlink)}d %-#{max_length.fetch(:uid)}s %-#{max_length.fetch(:gid)}s %#{max_length.fetch(:size)}d ", \
             type, mode, nlink, uid, gid, size
      print fs.mtime.strftime('%_m月 %e %H:%M') + " #{file}"
      print " -> #{File.readlink(file.to_s)}" if type == 'l'
      print "\n"
    end
  end

  def fetch_file_stat
    fetch_files.map { |file| File.lstat(file.to_s) }
  end

  def calculate_block_count_total
    puts "合計 #{fetch_file_stat.map(&:blocks).sum}"
  end

  def calculate_max_length
    {
      nlink: fetch_file_stat.map { |fs| fs.nlink.to_s.length }.max,
      uid: fetch_file_stat.map { |fs| Etc.getpwuid(fs.gid).name.length }.max,
      gid: fetch_file_stat.map { |fs| Etc.getgrgid(fs.gid).name.length }.max,
      size: fetch_file_stat.map { |fs| fs.size.to_s.length }.max
    }
  end
end

list = LS.new
list.main
