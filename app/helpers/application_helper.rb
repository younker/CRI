module ApplicationHelper
  # Add some data inside the HTML header; must have corresponding
  # content_for?(:foo) ? yield(:foo) : 'default' inside layout.
  # Defaults -- :title, :keywords, :description
  # Example
  # header(:title, "Administration Functions")
  def header(name, content=nil)
    if content.nil? && block_given?
      content_for name do yield end
    else
      case name
      when :title then content_for :header_title do "#{content} : Welcome" end
      else content_for name do content end
      end
    end
  end
  
  # Page title inside the body at the top of the main content section
  # Example:
  # page_title("Administration Functions")
  def page_title(page_title, klass=nil)
    unless page_title.blank?
      content_for :page_title do
        content_tag(:h1, page_title, :id => 'page_title', :class => klass)
      end
    end
  end

  # def banner
  #   content_for :banner do
  #     yield
  #   end
  # end

  def section?(section)
    case section
    when :homepage
      current_page?(main_app.root_path)
    when :about
      controller_action?(:members, :index) ||  # team engine
      controller_action?(:contacts, :new) ||   # contact engine
      controller_action?(:single, [:mission_statement, :faq, :privacy_policy])
    end
  end

  def controller_action?(c_names, c_action_names=[])
    Array.wrap(c_names).include?(controller_name.intern) && Array.wrap(c_action_names).include?(controller.action_name.intern)
  end

  def breadcrumb(*crumbs)
    crumbs.join(' > ')
  end

end
