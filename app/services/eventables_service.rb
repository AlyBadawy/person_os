class EventablesService
  def initialize(user)
    @user = user
  end

  def create_eventable_with_entries(eventable_params, entries_params)
    Eventable.transaction do
      eventable = @user.eventables.create!(eventable_params)
      entries_params.each do |entry_param|
        entry_param[:user] = @user
        eventable.event_entries.create!(entry_param)
      end
      eventable
    end
  end
end
