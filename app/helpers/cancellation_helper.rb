module CancellationHelper

  def cancellation_button_for(record, cancel, content_or_options = nil, options = nil, &block)
    form_for record, url: cancellation_path(record), method: :patch do |f|
      concat f.hidden_field :cancelled, value: cancel
      concat f.button(content_or_options, options, &block)
    end
  end
end