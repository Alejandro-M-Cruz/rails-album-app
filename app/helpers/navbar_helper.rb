module NavbarHelper

  def navbar_links
    navbar_links = [
      { name: 'Home', path: root_path },
      { name: 'New image', path: new_post_path }
    ]
    navbar_links.map { |link| link_html(link) }.join.html_safe
  end

  private

  def link_html(link)
    "<li>#{link_to link[:name], link[:path], class: link_class(link[:path])}</li>"
  end

  def link_class(link_path)
    current_page?(link_path) ? 'nav-link px-2 text-secondary' : 'nav-link px-2 text-white'
  end

end
