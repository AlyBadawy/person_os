require "rails_helper"

RSpec.describe EventablesService do
  describe "#create_eventable_with_entries" do
    let(:user) { create(:user) }
    let(:eventable_type) { create(:eventable_type) }

    it "creates an eventable and its entries in a transaction" do
      params = { name: "Test Event", eventable_type_id: eventable_type.id, starts_on: Date.current }
      entries = [{ occurred_at: Time.current }, { occurred_at: 1.hour.from_now }]

      service = described_class.new(user)
      eventable = service.create_eventable_with_entries(params, entries)

      expect(eventable).to be_persisted
      expect(eventable.event_entries.count).to eq(2)
      expect(eventable.user).to eq(user)
    end

    it "rolls back the transaction if an entry creation fails" do
      params = { name: "Will Fail", eventable_type_id: eventable_type.id, starts_on: Date.current }
      # Provide an invalid entry (missing occurred_at is allowed, but let's force a validation by passing invalid key)
      entries = [{ occurred_at: Time.current }, { invalid_key: "bad" }]

      service = described_class.new(user)

      expect do
        service.create_eventable_with_entries(params, entries)
      end.to raise_error(ActiveModel::UnknownAttributeError)

      # Ensure no eventable was persisted
      expect(user.eventables.where(name: "Will Fail")).to be_empty
    end
  end
end
