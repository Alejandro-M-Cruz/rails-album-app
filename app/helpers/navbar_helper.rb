module NavbarHelper

  def navbar_links
    navbar_links = [
      { name: 'Posts', path: posts_path },
      { name: 'My posts', path: my_posts_path },
      { name: 'New post', path: new_post_path }
    ]
    navbar_links.map { |link| link_html(link) }.join.html_safe
  end

  private
    def link_html(link)
      "<li>#{link_to link[:name], link[:path], class: link_class(link[:path])}</li>"
    end

    def link_class(link_path)
      'nav-link ' + (current_page?(link_path) ? 'text-secondary' : 'text-white')
    end
end
