module StaticHelper

  def chart_tag (action, height, params = {})
    params[:format] ||= :json
    path = demo1_curr_temp_path(nil, params)
    content_tag(:div, :'data-chart' => path, :style => "height: #{height}px;") do
      image_tag('spinner.gif', :size => '64x64', :class => 'spinner')
    end
  end

end
