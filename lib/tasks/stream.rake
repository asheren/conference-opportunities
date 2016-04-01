class Saver < Struct.new(:tweet)
  def handle
    Tweet.from_twitter(tweet).select(&:valid?).each(&:save!)
  end
end

class Deleter < Struct.new(:tweet)
  def handle
    Tweet.where(twitter_id: tweet.id).destroy_all
  end
end

class Follower < Struct.new(:target_user)
  def handle
    Conference.from_twitter_user(target_user).save!
  end
end

class Unfollower < Struct.new(:target_user)
  def handle
    Conference.where(uid: target_user.id).each(&:destroy!)
  end
end

class Ignorer < Struct.new(:unhandled_thing)
  def handle
    p "ignoring: #{unhandled_thing.inspect}"
  end
end

class Decider < Struct.new(:event)
  def handle
    {
      follow: Follower,
      unfollow: Unfollower,
    }.fetch(event.name, Ignorer).new(event.target).handle
  end
end

namespace :stream do
  desc "Stream some tweets?"
  task tweets: :environment do
    TwitterUpdater.authenticated.each do |container|
      {
        Twitter::Tweet => Saver,
        Twitter::Streaming::DeletedTweet => Deleter,
        Twitter::Streaming::Event => Decider,
      }.fetch(container.class, Ignorer).new(container).handle
    end
  end
end
