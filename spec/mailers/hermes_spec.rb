require "rails_helper"

RSpec.describe Hermes, type: :mailer do
  context "when a story is branched" do
    let(:parent) { FactoryBot.create(:story) }
    let(:story) { FactoryBot.create(:story, parent_id: parent.id) }

    let(:mail) { Hermes.branched_story_notification(story).deliver_now }

    it "sends a branched_story_notification" do
      expect(mail.subject).to include(story.user.login)
      expect(mail.to).to eq([parent.user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("branched off your story")
    end

    it "renders the body in html" do
      expect(mail.html).to match("branched off your story")
    end

    it "has mailgun header" do
      expect(mail).to have_header("X-Mailgun-Tag", "Branched Story")
    end

    it "has mailgun variables header" do
      expect(mail.header["X-Mailgun-Variables"]).to be
    end
  end

  context "when a comment is made" do
    let(:story) { FactoryBot.create(:story) }
    let(:comment) { FactoryBot.create(:comment, story: story) }

    let(:mail) { Hermes.comment_notification(comment).deliver_now }

    it "sends a comment_notification" do
      expect(mail.subject).to include(comment.user.login)
      expect(mail.to).to eq([story.user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("commented on your story")
    end

    it "renders the body in html" do
      expect(mail.html).to match("commented on your story")
    end

    it "has mailgun header" do
      expect(mail).to have_header("X-Mailgun-Tag", "New Comment")
    end

    it "has mailgun variables header" do
      expect(mail.header["X-Mailgun-Variables"]).to be
    end
  end

  context "when a user signs up" do
    let(:user) { FactoryBot.create(:user) }

    let(:mail) { Hermes.signup_notification(user).deliver_now }

    it "sends a signup_notification" do
      expect(mail.subject).to include("Welcome!")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Welcome to Six Minute Story")
    end

    it "renders the body in html" do
      expect(mail.html).to match("Welcome to Six Minute Story")
    end
  end

  context "when a user follows another" do
    let(:user) { FactoryBot.create(:user) }
    let(:follower) { FactoryBot.create(:user) }

    let(:mail) { Hermes.following_notification(user, follower).deliver_now }

    it "sends a following_notification" do
      expect(mail.subject).to include(follower.login)
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("is now following your stories")
    end

    it "renders the body in html" do
      expect(mail.html).to match("is now following your stories")
    end

    it "has mailgun header" do
      expect(mail).to have_header("X-Mailgun-Tag", "New Follower")
    end

    it "has mailgun variables header" do
      expect(mail.header["X-Mailgun-Variables"]).to be
    end
  end

  context "when a story gets featured" do
    let(:story) { FactoryBot.create(:story) }

    let(:mail) { Hermes.featured_story_notification(story).deliver_now }

    it "sends a featured_story_notification" do
      expect(mail.subject).to include(story.title)
      expect(mail.to).to eq([story.user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("has been featured")
    end

    it "renders the body in html" do
      expect(mail.html).to match("has been featured")
    end

    it "has mailgun header" do
      expect(mail).to have_header("X-Mailgun-Tag", "Featured Story")
    end

    it "has mailgun variables header" do
      expect(mail.header["X-Mailgun-Variables"]).to be
    end
  end
end

