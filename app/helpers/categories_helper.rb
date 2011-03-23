module CategoriesHelper
  def categories_tree(categories)
    unless categories.empty?
      t = '<ul>'
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
end
