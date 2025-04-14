module ApplicationHelper
  def flash_type_to_bootstrap(key)
    case key.to_sym
    when :notice then "info"
    when :alert, :error then "danger"
    when :success then "success"
    else "secondary"
    end
  end
end
