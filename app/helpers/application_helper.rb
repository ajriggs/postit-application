module ApplicationHelper
  def fix_url(str)
    if str.start_with?('http://') || str.start_with?('https://')
      str
    else
      str.prepend('http://')
    end
  end

  def format_datetime(datetime)
    datetime.strftime("%D %r %Z")
  end

  # needs tinkering, but I do feel like this logic could be put into a helper, maybe?
  # def header(asset)
  #   link_to('All Posts', posts_path) + " &raquo;  #{asset.name}".html_safe
  # end
end
