module ApplicationHelper
  def show_flash(type, message)
    flash[type] = message
    turbo_stream.append("flash-#{type.to_s}-container", partial: "shared/flash/#{type.to_s}")
  end
end
