require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base

  def configure

    gem 'rails', Rails::VERSION::STRING
    gem 'sqlite3'
    gem 'hydra', '6.1.0'
    gem 'hydra-editor', path: '../../'
    gem "factory_girl_rails"
    gem 'rspec-rails'
    gem 'capybara'

    generate "hydra:install"

    rake "db:migrate"
    rake "db:test:prepare"
    
    gsub_file "app/controllers/application_controller.rb", "layout 'blacklight'", "layout 'application'"

    insert_into_file "config/routes.rb", :after => '.draw do' do
      "\n  mount HydraEditor::Engine => \"/\"\n"
    end

  end


end
