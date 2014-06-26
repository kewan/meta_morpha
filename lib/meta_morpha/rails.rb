module MetaMorpha
  class Rails < ::Rails::Engine
    config.autoload_paths << File.expand_path("#{config.root}/app/morphs") if File.exist?("#{config.root}/app/formatters")
  end if defined?(::Rails)
end
