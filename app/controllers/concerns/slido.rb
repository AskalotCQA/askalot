module Concerns::Slido
  extend ActiveSupport::Concern

  included do
    before_action :flash_slido_events
  end

  def flash_slido_events
    events = SlidoEvent.where('? between started_at and ended_at', Time.now).order(:ended_at).load

    flash[:danger] = 'lalal'

    if events.any?
      flash.now[:slido] = []

      events.each do |event|
        flash.now[:slido] << render_to_string(partial: 'slido/message', locals: { event: event })
      end
    end
  end
end
