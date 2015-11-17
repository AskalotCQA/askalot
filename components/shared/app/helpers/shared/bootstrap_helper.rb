module University::BootstrapHelper
  include University::Bootstrap::BarHelper
  include University::Bootstrap::IconHelper
  include University::Bootstrap::LabelHelper
  include University::Bootstrap::LinkHelper
  include University::Bootstrap::PillHelper
  include University::Bootstrap::PopoverHelper
  include University::Bootstrap::TabHelper
  include University::Bootstrap::TooltipHelper
  include University::Bootstrap::UtilityHelper

  def identify(object, suffix = [])
    ([object.class.name.demodulize.downcase, object.id] + Array.wrap(suffix)).reject(&:blank?).join '-'
  end

  #TODO(zbell) make gem out of this, add more helpers for alerts, panels, ...
end
