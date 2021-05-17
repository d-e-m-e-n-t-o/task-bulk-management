module ApplicationHelper
  def full_title(page_name = '')
    base_title = 'Tas-kun'
    if page_name.empty?
      base_title
    else
      "#{page_name} | #{base_title}"
    end
  end

  def resource
    @resource ||= User.new
  end
end
