raise "\n\033[31mredmine_mentions requires ruby 2.3 or newer. Please update your ruby version.\033[0m" if RUBY_VERSION < '2.3'

require_dependency 'redmine_mentions/hooks'

Rails.configuration.to_prepare do
  Journal.send(:include, RedmineMentions::JournalPatch) unless Journal < RedmineMentions::JournalPatch
  RedmineMentions::MailerPatch.apply
end
Redmine::Plugin.register :redmine_mentions do
  name 'Redmine Mentions'
  author 'Arkhitech'
  description 'This is a plugin for Redmine which gives suggestions on using username in comments'
  version '0.0.3'
  url 'https://github.com/arkhitech/redmine_mentions'
  author_url 'http://www.arkhitech.com/'
  settings default: { 'trigger' => '@' }, partial: 'settings/mention'
end
