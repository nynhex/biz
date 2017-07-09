RSpec.describe Biz::Shift do
  let(:time_segment) {
    Biz::TimeSegment.new(Time.utc(2010, 7, 15, 9), Time.utc(2010, 7, 15, 17))
  }

  subject(:shift) { described_class.new(time_segment) }

  describe '#date' do
    it 'returns the date on which the shift occurs' do
      expect(shift.date).to eq time_segment.start_time.to_date
    end
  end

  describe '#contains?' do
    context 'when the time is before the shift' do
      let(:time) { Time.utc(2010, 7, 15, 8) }

      it 'returns false' do
        expect(shift.contains?(time)).to eq false
      end
    end

    context 'when the time is at the beginning of the shift' do
      let(:time) { Time.utc(2010, 7, 15, 9) }

      it 'returns true' do
        expect(shift.contains?(time)).to eq true
      end
    end

    context 'when the time is contained by the shift' do
      let(:time) { Time.utc(2010, 7, 15, 12) }

      it 'returns true' do
        expect(shift.contains?(time)).to eq true
      end
    end

    context 'when the time is at the end of the shift' do
      let(:time) { Time.utc(2010, 7, 15, 17) }

      it 'returns false' do
        expect(shift.contains?(time)).to eq false
      end
    end

    context 'when the time is after the shift' do
      let(:time) { Time.utc(2010, 7, 15, 20) }

      it 'returns false' do
        expect(shift.contains?(time)).to eq false
      end
    end
  end

  describe '#to_time_segment' do
    it 'returns the time segment' do
      expect(shift.to_time_segment).to eq time_segment
    end
  end

  context 'when performing comparison' do
    context 'and the compared object has an earlier start time' do
      let(:other) {
        described_class.new(
          Biz::TimeSegment.new(
            time_segment.start_time - 1,
            time_segment.end_time
          )
        )
      }

      it 'compares as expected' do
        expect(shift > other).to eq true
      end
    end

    context 'and the compared object has a later start time' do
      let(:other) {
        described_class.new(
          Biz::TimeSegment.new(
            time_segment.start_time + 1,
            time_segment.end_time
          )
        )
      }

      it 'compares as expected' do
        expect(shift > other).to eq false
      end
    end

    context 'and the compared object has an earlier end time' do
      let(:other) {
        described_class.new(
          Biz::TimeSegment.new(
            time_segment.start_time,
            time_segment.end_time - 1
          )
        )
      }

      it 'compares as expected' do
        expect(shift > other).to eq true
      end
    end

    context 'and the compared object has a later end time' do
      let(:other) {
        described_class.new(
          Biz::TimeSegment.new(
            time_segment.start_time,
            time_segment.end_time + 1
          )
        )
      }

      it 'compares as expected' do
        expect(shift > other).to eq false
      end
    end

    context 'and the compared object has the same start and end times' do
      let(:other) {
        described_class.new(
          Biz::TimeSegment.new(
            time_segment.start_time,
            time_segment.end_time
          )
        )
      }

      it 'compares as expected' do
        expect(shift == other).to eq true
      end
    end

    context 'and the compared object is not a time segment' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { shift < other }.to raise_error ArgumentError
      end
    end
  end
end
