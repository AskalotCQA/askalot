module Shared::BootstrapHelper
  include Shared::Bootstrap::BarHelper
  include Shared::Bootstrap::IconHelper
  include Shared::Bootstrap::LabelHelper
  include Shared::Bootstrap::LinkHelper
  include Shared::Bootstrap::PillHelper
  include Shared::Bootstrap::PopoverHelper
  include Shared::Bootstrap::TabHelper
  include Shared::Bootstrap::TooltipHelper
  include Shared::Bootstrap::UtilityHelper

  def identify(object, suffix = [])
    ([object.class.name.demodulize.downcase, object.id] + Array.wrap(suffix)).reject(&:blank?).join '-'
  end

  #TODO(zbell) make gem out of this, add more helpers for alerts, panels, ...
end
