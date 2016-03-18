Shared::Engine.load_seed
University::Engine.load_seed if Rails.module.university?
Mooc::Engine.load_seed if Rails.module.mooc?
