class ActionDispatch::Routing::RouteSet
  def default_url_options(options={})
    Rails.module.mooc? ? { context: Shared::Context::Manager.current_context } : {}
    {}
  end
end
