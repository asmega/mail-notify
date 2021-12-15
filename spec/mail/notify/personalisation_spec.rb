# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mail::Notify::Personalisation do
  let(:personalisation) { described_class.new(mail) }

  context "without any personalisation" do
    let(:mail) { Mail.new(body: "foo", subject: "bar") }

    it "returns the body and subject as a hash" do
      expect(personalisation.to_h).to eq(
        body: "foo",
        subject: "bar"
      )
    end
  end

  context "with some personalisations" do
    let(:mail) do
      Mail.new(body: "foo", subject: "bar", personalisation: {
        foo: "bar"
      })
    end

    it "merges everything" do
      expect(personalisation.to_h).to eq(
        :body => "foo",
        :subject => "bar",
        "foo" => "bar"
      )
    end
  end

  context "with blank subject and body" do
    let(:mail) do
      Mail.new(body: "", subject: "", personalisation: {
        foo: "bar"
      })
    end

    it "removes the subject and body" do
      expect(personalisation.to_h).to eq(
        "foo" => "bar"
      )
    end
  end

  context "with explicitly blank personalisation" do
    let(:mail) { Mail.new(personalisation: {foo: Mail::Notify::Personalisation::BLANK}) }

    it "replaces it with a blank string" do
      expect(personalisation.to_h).to eq("foo" => "")
    end
  end

  context "with implicitly blank personalisation" do
    let(:mail) { Mail.new(personalisation: {foo: [nil, "", false].sample}) }

    it "removes it from the hash" do
      expect(personalisation.to_h).to be_empty
    end
  end
end
