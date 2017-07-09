module Biz
  class WeekInterval

    def initialize(week, interval)
      @week     = week
      @interval = interval
    end

    def to_time_segment
      @time_segment ||= begin
        TimeSegment.new(
          *interval.endpoints.map { |endpoint|
            Time.new(interval.time_zone).during_week(week, endpoint)
          }
        )
      end
    end

    def date
      @date ||= week.start_date + interval.wday
    end

    protected

    attr_reader :week,
                :interval

  end
end
