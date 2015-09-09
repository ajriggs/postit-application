module ApplicationHelper
  def fix_url(str)
    str.url.start_with?('http://') ? str : str.prepend('http://')
  end
end
