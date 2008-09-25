# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  FORMATED_DAY = {
    -1 => :yesterday,
     0 => :today,
     1 => :tomorrow,
  }
  
  DISPLAY_DAY = {
    :yesterday => '昨日',
    :today     => '今日',
    :tomorrow  => '明日',
  }


  def display_from_to(start_date, end_date)
    start_date_format, end_date_format = case
                        when (start_date.year == start_date.year and start_date.month == end_date.month) then ['%m/%d', '%d']
                        when start_date.year == end_date.year then ['%m/%d', '%m/%d']
                        else ['%Y/%m/%d', '%Y/%m/%d']
                        end

     display_date(start_date, start_date_format) + '&nbsp;〜&nbsp;' + display_date(end_date, end_date_format)
  end


  def display_date(date, format=nil)
    today      = Date.today
    format_key = FORMATED_DAY[date - today] ||= :pass
    format ||= format_date(date)
    disp     = format_key == :pass ? date.strftime(format) :  DISPLAY_DAY[format]
  end

  def format_date(date)
    today  = Date.today
    format = case
             when (today.year == date.year and today.month == date.month) then '%d'
             when today.year == date.year then '%m/%d'
             else '%Y/%m/%d'
             end
    format
  end
end
