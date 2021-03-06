module ApplicationHelper
  def fix_url(str)
    if str.start_with?('http://') || str.start_with?('https://')
      str
    else
      str.prepend('http://')
    end
  end

  def format_datetime(datetime)
    if logged_in? && !current_user.timezone.blank?
      datetime = datetime.in_time_zone(current_user.timezone)
    end
    datetime.strftime("%D %r %Z")
  end
  
end
