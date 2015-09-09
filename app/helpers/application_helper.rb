module ApplicationHelper
  def fix_url(str)
    str.url.start_with?('http://') ? str : str.prepend('http://')
  end

  # needs tinkering, but I do feel like this logic could be put into a helper, maybe?
  # def header(asset)
  #   link_to('All Posts', posts_path) + " &raquo;  #{asset.name}".html_safe
  # end
end
