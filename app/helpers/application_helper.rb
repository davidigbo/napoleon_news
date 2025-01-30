module ApplicationHelper
  def possessivize(name)
    return "" if name.blank?

    name.end_with?('s') ? "#{name}'" : "#{name}'s"
  end

  def tag_classes
    %w[bg-primary bg-secondary bg-success]
  end
end
