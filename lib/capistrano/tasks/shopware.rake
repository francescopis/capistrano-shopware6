set :linked_dirs, fetch(:linked_dirs, []).push(
  'config/jwt',
  'files',
  'var/log',
  'public/media',
  'public/thumbnail',
  'public/sitemap'
)

namespace :composer do
  task :install do
    on roles(:app) do
      within release_path do
        execute :composer, "install --prefer-dist --no-interaction --no-dev --optimize-autoloader" 
      end
    end
  end
end

namespace :shopware do
  namespace :bin do
    task :execute, :param do |t, args|
      on roles(:app) do
        within release_path do
          execute './bin', args[:param]
        end
      end
    end

    namespace :dependencies do
      task :build do
        invoke! 'export SHOPWARE_ADMIN_BUILD_ONLY_EXTENSIONS=1 && export DISABLE_ADMIN_COMPILATION_TYPECHECK=1'
        invoke! 'shopware:bin:execute', 'build-js.sh'
      end
    end
  end

  namespace :theme do
    task :build do
      invoke! 'shopware:console:execute', 'theme:compile'
    end
  end

  task :touch_install do
     execute 'touch install.lock'
  end

  namespace :console do
    task :execute, :param do |t, args|
      on roles(:app) do
        within release_path do
          execute 'bin/console', args[:param]
        end
      end
    end

    task :execute_current, :param do |t, args|
      on roles(:app) do
        within current_path do
          execute 'bin/console', args[:param]
        end
      end
    end
    
    task :cache_clear do
      invoke! 'shopware:console:execute', 'cache:clear'
    end

    task :http_cache_warmup do
      invoke! 'shopware:console:execute', 'http:cache:warm:up'
    end

    task :cache_warmup do
      invoke! 'shopware:console:execute', 'cache:warm:up'
    end

    task :database_migrate do
      invoke! 'shopware:console:execute', 'database:migrate --all'
    end

    task :maintenance_enable do
      invoke! 'shopware:console:execute_current', 'sales-channel:maintenance:enable --all'
    end

    task :maintenance_disable do
      invoke! 'shopware:console:execute', 'sales-channel:maintenance:disable --all'
    end
  end
end


namespace :deploy do
  after :updated, :shopware do
    invoke 'shopware:console:maintenance_enable'
    invoke 'shopware:touch_install'
    invoke 'composer:install'
    invoke 'shopware:console:database_migrate'
    invoke 'shopware:bin:dependencies:build'
    invoke 'shopware:console:theme'
    invoke 'shopware:console:cache_clear'
  end

  after :published, :shopware do
    invoke 'shopware:console:maintenance_disable'
    invoke 'shopware:console:cache_warmup'
    invoke 'shopware:console:http_cache_warmup'
  end
end
