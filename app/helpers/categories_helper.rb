module CategoriesHelper
  def categories_tree(categories)
    unless categories.empty?
      t = "<ul>"
      categories.each { |category|
        t += '<li>'
        t += link_to h(category.name), category
        t += categories_tree(category.children) unless category.children.empty?
        t += '</li>'
      }
      t += '</ul>'
    end
    t.html_safe
  end
  
  def full_category(cat_id)
    begin
      category = Category.find(cat_id)
      t = '&gt; '
      for cat in category.ancestors.reverse
        t += link_to h(cat.name), cat
        t += ' &gt; '
      end
      t += link_to h(category.name), category
      t.html_safe
    rescue ActiveRecord::RecordNotFound
      t = 'Not found'
    end
  end
  
  def category_items(category)
    t = ''
    category.items.each do |item|
      t += "<li>#{link_to h(item.name), item} &#36;#{h(item.cost)}</li>"
    end
    unless category.children.empty?
      category.children.each do |child|
        t += category_items(child)
      end
    end
    t.html_safe
  end
end
