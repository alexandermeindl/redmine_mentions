module RedmineMentions
  module JournalPatch
    def self.included(base)
      base.class_eval do
        after_create :send_mail

        def send_mail
          return if !journalized.is_a?(Issue) || notes.blank?

          issue = journalized
          project = journalized.project
          users = project.users.to_a.delete_if { |u| (u.type != 'User' || u.mail&.empty?) }
          users_regex = users.collect { |u| "#{Setting.plugin_redmine_mentions['trigger']}#{u.login}" }.join('|')
          regex_for_email = '\B(' + users_regex + ')\b'
          regex = Regexp.new(regex_for_email)
          mentioned_users = notes.scan(regex)
          mentioned_users.each do |mentioned_user|
            username = mentioned_user.first[1..-1]
            if user = User.find_by(login: username)
              Mailer.notify_mentioning(user, issue, self).deliver
            end
          end
        end
      end
    end
  end
end
