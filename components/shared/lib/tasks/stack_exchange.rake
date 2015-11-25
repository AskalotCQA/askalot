# Usage:
#
# rake stack_exchange:import

namespace :stack_exchange do
  desc "Import Stack Exchange data"
  task import: :environment do
    Shared::StackExchange.config.document.from = Time.parse(ENV['FROM']) if ENV['FROM']
    Shared::StackExchange.config.document.to   = Time.parse(ENV['TO']) if ENV['TO']

    Shared::StackExchange.import_from(ENV['PATH'])
  end
end
