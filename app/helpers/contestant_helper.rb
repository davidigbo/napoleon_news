module ContestantHelper
  def full_image_url_for(record, image_attachment_name = :image)
    return nil unless record.send(image_attachment_name).attached?

    Rails.application.routes.url_helpers.rails_blob_url(
      record.send(image_attachment_name),
      host: request.base_url
    )
  end
end
