Gem::Specification.new do |s|
  s.authors = ['Giacomo Mirabassi', 'Davide Borgia', 'Francesco Pisello']
  s.name = %q{capistrano_shopware6_5}
  s.version = "0.0.1"
  s.date = %q{2021-02-18}
  s.summary = %q{Capistrano deploy instructions for Shopware 6.5 production template}
  s.require_paths = ["lib"]
  s.files = `git ls-files`.split($/)
  s.license = "OSL-3.0"
  s.homepage = 'https://github.com/giacmir/capistrano-shopware6'

  s.add_dependency 'capistrano', '~> 3.0'
end
