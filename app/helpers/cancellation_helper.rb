module CancellationHelper

  def cancel_button_for(record, content_or_options = nil, options = nil, &block)
    form_for record, url: cancellations_path, method: :post do |f|
      concat f.hidden_field :id, value: record.id
      concat f.button(content_or_options, options, &block)
    end
  end

  def uncancel_button_for(record, content_or_options = nil, options = nil, &block)
    form_for record, url: cancellation_path(record), method: :delete do |f|
      concat f.button(content_or_options, options, &block)
    end
  end
end
