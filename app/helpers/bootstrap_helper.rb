module BootstrapHelper
  include Bootstrap::BarHelper
  include Bootstrap::IconHelper
  include Bootstrap::LabelHelper
  include Bootstrap::LinkHelper
  include Bootstrap::PillHelper
  include Bootstrap::PopoverHelper
  include Bootstrap::TabHelper
  include Bootstrap::TooltipHelper

  def identify(object, suffix = [])
    ([object.class.name.downcase, object.id] + Array.wrap(suffix)).reject(&:blank?).join '-'
  end

  #TODO(zbell) make gem out of this, add more helpers for alerts, panels, ...
end
