#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

class LS
  CULUMN = 3

  def main
    opt = OptionParser.new

    params = {}
    opt.on('-l') { |v| params[:l] = v }
    opt.parse(ARGV)

    params[:l] ? l_option : no_option
  end

  private

  def no_option
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
    Dir.glob('*')
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

  def fetch_file_stat
    fs = []
    fetch_files.each { |file| fs << File.lstat(file.to_s) }
    fs
  end

  def calculate_block_count_total
    block_size = []
    fetch_file_stat.each { |file| block_size << file.blocks }
    puts "合計 #{block_size.sum}"
  end

  def calculate_max_length
    nlink_length = []
    uid_length = []
    gid_length = []
    size_length = []
    fetch_file_stat.each do |fs|
      nlink_length << fs.nlink.to_s.length
      uid_length << Etc.getpwuid(fs.uid).name.length
      gid_length << Etc.getpwuid(fs.gid).name.length
      size_length << fs.size.to_s.length
    end
    { 'nlink' => nlink_length.max, 'uid' => uid_length.max, 'gid' => gid_length.max, 'size' => size_length.max }
  end

  def l_option
    calculate_block_count_total

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

      printf "%s%s %#{calculate_max_length.fetch('nlink')}d %-#{calculate_max_length.fetch('uid')}s %-#{\
      calculate_max_length.fetch('gid')}s %#{calculate_max_length.fetch('size')}d ", \
             type, mode, nlink, uid, gid, size
      print fs.mtime.strftime('%_m月 %e %H:%M') + " #{file}"
      print " -> #{File.readlink(file.to_s)}" if type == 'l'
      print "\n"
    end
  end
end

list = LS.new
list.main
