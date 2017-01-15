module Admin::FormHelper
  def form_actions
    content_tag(:div, class: 'page-footer') do
      content_tag(:div, class: 'container-fluid') do
        content_tag(:div, class: 'page-actions') do
          yield
        end
      end
    end
  end
end