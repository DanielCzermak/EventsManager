module HomeHelper
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
