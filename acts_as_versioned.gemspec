# frozen_string_literal: true

require_relative 'lib/acts_as_versioned/version'

Gem::Specification.new do |s|
  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'acts_as_versioned'
  s.version           = ActsAsVersioned::VERSION
  s.date              = '2020-12-27'
  s.rubyforge_project = 'acts_as_versioned'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = 'Add simple versioning to ActiveRecord models.'
  s.description = 'Add simple versioning to ActiveRecord models.'

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ['Rick Olson']
  s.email    = 'technoweenie@gmail.com'
  s.homepage = 'http://github.com/romanbsd/acts_as_versioned'
  s.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README MIT-LICENSE CHANGELOG]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('activerecord', ['>= 3.0.9'])

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('sqlite3-ruby', ['>= 1.3.1'])

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    CHANGELOG
    Gemfile
    Gemfile.lock
    MIT-LICENSE
    README
    RUNNING_UNIT_TESTS
    Rakefile
    acts_as_versioned.gemspec
    init.rb
    lib/acts_as_versioned.rb
    lib/acts_as_versioned/version.rb
    test/abstract_unit.rb
    test/database.yml
    test/fixtures/authors.yml
    test/fixtures/landmark.rb
    test/fixtures/landmark_versions.yml
    test/fixtures/landmarks.yml
    test/fixtures/locked_pages.yml
    test/fixtures/locked_pages_revisions.yml
    test/fixtures/migrations/2_add_versioned_tables.rb
    test/fixtures/page.rb
    test/fixtures/page_versions.yml
    test/fixtures/pages.yml
    test/fixtures/widget.rb
    test/migration_test.rb
    test/schema.rb
    test/versioned_test.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ %r{^test/test_.*\.rb} }
end
