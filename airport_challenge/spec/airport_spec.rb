require 'airport'
require 'plane'
describe Airport do
  describe 'LANDING TESTS 🛬' do
    it { is_expected.to respond_to(:land).with(1).argument }

    it 'Plane lands at correct airport when instructed, weather permitting...' do
      subject.stormy = false
      expect { subject.land(double(:plane)) }.not_to raise_error
    end

    it "If weather is too treacherous – plane will not land at an airport..." do
      subject.stormy = true
      plane = Plane.new
      expect { subject.land(plane) }.to raise_error("IT'S TOO STORMY TO LAND!!! ⛈️ ⛈️ ⛈️")
    end

    it 'If an airport is full – planes will not land there...' do
      20.times { subject.land(Plane.new) }
      expect { subject.land(Plane) }.to raise_error("Airport is full!")
    end

    it "Cannot land a plane already landed..." do
      plane = Plane.new
      subject.land(plane)
      expect { subject.land(plane) }.to raise_error("Plane has already landed!")
    end

    it 'Plane is at the aiport after landing...' do
      plane = Plane.new
      subject.land(plane)
      expect(subject.planes.include?(plane)).to eq true
    end

    it 'Plane is not in the airport before landing...' do
      plane = Plane.new
      expect(subject.planes.include?(plane)).to eq false
    end

    it 'Plane is not at the aiport after taking off...' do
      plane = Plane.new
      subject.land(plane)
      subject.take_off(plane)
      expect(subject.planes.include?(plane)).to eq false
    end
  end

  describe 'TAKE OFF TESTS 🛫' do
    it { is_expected.to respond_to(:take_off).with(1).argument }
    it 'Plane will take off provided it is not too stormy...' do
      plane = Plane.new
      subject.land(plane)
      subject.stormy = false
      expect { subject.take_off(plane) }.not_to raise_error
    end

    it "Plane must remain airborn whilst weather is stormy..." do
      subject.stormy = true
      plane = Plane.new
      expect { subject.take_off(plane) }.to raise_error("IT'S TOO STORMY TO TAKE OFF!!! ⛈️ ⛈️ ⛈️")
    end

    it 'Plane leaves the airport...' do
      plane = Plane.new
      subject.land(plane)
      before = subject.planes.length
      subject.take_off(plane)
      after = subject.planes.length
      expect(before - after).to eq 1
    end

    it 'Plane only takes off if it is in the airport...' do
      plane = Plane.new
      subject.land(plane)
      rogue_plane = "I'm not in the airport!"
      expect { subject.take_off(rogue_plane) }.to raise_error("This plane is not at the airport!")
    end
  end

  describe 'WEATHER TESTS 🌡️' do
    it 'Weather can be set to stormy...' do
      subject.stormy = true
      expect(subject.stormy?).to eq true
    end
  end

  describe 'CAPACITY TESTS' do
    it 'Airport has a default capacity of 20...' do
      expect(Airport::DEFAULT_CAPACITY).to eq 20
    end

    it 'Airport has a method for capacity...' do
      expect(subject).to respond_to(:capacity)
    end

    it 'Airport capacity can be updated...' do
      subject.capacity = 300
      expect(subject.capacity).to eq 300
    end
  end
end
