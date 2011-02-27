module ApplicationHelper
  def logo
    image_tag("logo.png", :alt => "RoR Shop", :class => "round")
  end  

  def title
    base_title = "RoR Shop"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
end
