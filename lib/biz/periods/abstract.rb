module Biz
  module Periods
    class Abstract < SimpleDelegator

      def initialize(schedule, origin)
        @schedule = schedule
        @origin   = origin

        super(periods)
      end

      def timeline
        Timeline::Proxy.new(self)
      end

      protected

      attr_reader :schedule,
                  :origin

      private

      def periods
        linear_periods
          .lazy
          .select   { |period| relevant?(period) }
          .map      { |period| period & boundary }
          .flat_map { |period| active_periods(period) }
          .reject   { |period| on_holiday?(period) }
          .reject(&:empty?)
      end

      def linear_periods
        Linear.new(
          weeks.lazy.flat_map { |week|
            intervals.map { |interval| WeekInterval.new(week, interval) }
          },
          shifts
        )
      end

      def active_periods(period)
        schedule.breaks.reduce([period]) { |periods, break_period|
          periods.flat_map { |active_period| active_period / break_period }
        }
      end

      def on_holiday?(period)
        schedule.holidays.any? { |holiday|
          holiday.contains?(period.start_time)
        }
      end

    end
  end
end
