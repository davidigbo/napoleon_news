module ApplicationHelper
  def possessivize(name)
    return "" if name.blank?

    name.end_with?('s') ? "#{name}'" : "#{name}'s"
  end

  def tag_classes
    %w[bg-primary bg-secondary bg-success]
  end

  def markdown(text)
    options = {
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
