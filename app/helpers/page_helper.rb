module PageHelper

  def link_to_active(name, path)
    clazz = 'active' if current_page?(path)
    link_to(name, path, :class => clazz)
  end

end
