module Scheduling
  class Person
    attr_reader :id, :attending, :presenting

    def initialize(ctx, id)
      @attending  = SessionSet.new(ctx)
      @presenting = SessionSet.new(ctx,
        superset: @attending,            # Presenters don't necessarily upvote their own sessions, but they do attend!
        penalty_callback: ->(slot) do    # Presenters may have other scheduling constraints beside double booking
          @timeslot_penalties[slot]
        end)
      @timeslot_penalties = Hash.new(0)
    end

    # Value greater than 0 indicates desire not to present in given slot; 1 means "impossible."
    #
    def assign_timeslot_penalty(slot_id, penalty)
      @timeslot_penalties[slot_id] = penalty
    end
  end
end
