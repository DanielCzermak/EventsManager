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
end
