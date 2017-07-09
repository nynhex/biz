module Biz
  module Calculation
    class Active

      def initialize(schedule, time)
        @schedule = schedule
        @time     = time
      end

      def result
        in_hours? && active?
      end

      protected

      attr_reader :schedule,
                  :time

      private

      def in_hours?
        schedule.intervals.any? { |interval| interval.contains?(time) } ||
          schedule.shifts.any? { |shift| shift.contains?(time) }
      end

      def active?
        schedule.holidays.none? { |holiday| holiday.contains?(time) } &&
          schedule.breaks.none? { |brake| brake.contains?(time) }
      end

    end
  end
end
