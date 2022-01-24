#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class WC
  def main
    opt = OptionParser.new

    params = {}
    opt.on('-l') { |v| params[:line_count] = v }
    opt.parse!(ARGV)

    paths = ARGV
    paths.size.zero? ? accept_stdin(**params) : paths
    print_count(paths, **params)
  end

  private

  def accept_stdin(**params)
    lines = readlines
    if params[:line_count]
      puts lines.join(',').count("\n").to_s
    else
      puts format(
        '%<line_count>7i%<lf_number>8i%<bytesize>8i',
        line_count: lines.join(',').count("\n"),
        lf_number: lines.to_s.split(/\s+/).size,
        bytesize: lines.join.bytesize
      )
    end
  end

  def print_count(paths, **params)
    path_counts = paths.map { |path| build_count(path) }
    total_count = build_total(path_counts)
    max_size_map = build_max_size_map(total_count)

    if params[:line_count]
      print_line_count(paths, path_counts, max_size_map, total_count)
    else
      print_all_count(paths, path_counts, max_size_map, total_count)
    end
  end

  def build_count(path)
    {
      path: path,
      line_count: File.read(path).count("\n"),
      lf_number: File.read(path).split(/\s+/).size,
      byte_count: File::Stat.new(path).size
    }
  end

  def build_total(path_counts)
    {
      line_count: path_counts.map { |count| count[:line_count] }.sum,
      lf_number: path_counts.map { |count| count[:lf_number] }.sum,
      byte_count: path_counts.map { |count| count[:byte_count] }.sum
    }
  end

  def build_max_size_map(total_count)
    {
      line_count: total_count[:line_count].to_s.size,
      lf_number: total_count[:lf_number].to_s.size,
      byte_count: total_count[:byte_count].to_s.size
    }
  end

  def print_all_count(paths, path_counts, max_size_map, total_count)
    path_counts.each do |count|
      format_count = [
        "%<line_count>#{max_size_map[:line_count] + 1}i",
        "%<lf_number>#{max_size_map[:lf_number] + 1}i",
        "%<byte_count>#{max_size_map[:byte_count]}i",
        "%<path>s\n"
      ].join(' ')
      printf(format_count, count)
    end
    return unless paths.size > 1

    format_total_count = [
      "%<line_count>#{max_size_map[:line_count] + 1}i",
      "%<lf_number>#{max_size_map[:lf_number] + 1}i",
      "%<byte_count>#{max_size_map[:byte_count]}i",
      "合計\n"
    ].join(' ')
    printf(format_total_count, total_count)
  end

  def print_line_count(paths, path_counts, max_size_map, total_count)
    path_counts.each do |count|
      if paths.size == 1
        format_line_count = ['%<line_count>i', "%<path>s\n"].join(' ')
        printf(format_line_count, count)
      else
        format_total_line_count = [
          "%<line_count>#{max_size_map[:line_count] + 1}i",
          "%<path>s\n"
        ].join(' ')
        printf(format_total_line_count, count)
      end
    end
    return unless paths.size > 1

    printf("%<line_count>#{max_size_map[:line_count] + 1}i 合計\n",
           total_count)
  end
end

word_count = WC.new
word_count.main
