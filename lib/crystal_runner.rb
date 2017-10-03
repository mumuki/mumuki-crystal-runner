require 'mumukit'

Mumukit.runner_name = 'crystal'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-crystal-worker'
  config.comment_type = Mumukit::Directives::CommentType::Ruby
  config.structured = true
  config.stateful = true
end

require_relative './version'
require_relative './metadata_hook'
require_relative './test_hook'
