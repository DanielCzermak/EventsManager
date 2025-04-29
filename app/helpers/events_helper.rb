module EventsHelper
  def frequency_to_text(freq)
    case freq.to_sym
    when :once then "Once"
    when :weekly then "Every week"
    when :monthly then "Every month"
    when :yearly then "Every year"
    else "!unknown frequency!"
    end
  end

  def event_dates_to_formatted_text(start_date, end_date = nil)
    if !end_date
      start_date.strftime("%d %b %Y, %H:%M")
    else
      if start_date.to_date == end_date.to_date
        (start_date.strftime("%d %b %Y, %H:%M") + "<br>" + end_date.strftime("%H:%M")).html_safe
      else
        (start_date.strftime("%d %b %Y, %H:%M") + "<br>" + end_date.strftime("%d %b %Y, %H:%M")).html_safe
      end
    end
  end
end
