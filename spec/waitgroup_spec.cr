require "./spec_helper"

describe WaitGroup do
  it "works" do
    wg = WaitGroup.new 10
    time_taken = Time.measure do
      10.times do
        spawn do
          wg.add do
            sleep 1
            done
          end
        end
      end
      wg.wait
    end
    time_taken.should be_close 1.second,
      delta: 0.1.seconds
  end

  it "honors the 'minimum' argument" do
    wg = WaitGroup.new 2
    time_taken = Time.measure do
      spawn do
        wg.add do
          sleep 1
          done
        end
      end
      sleep 1.5
      wg.add do |i|
        spawn do
          sleep 1
          i.done
        end
      end
      wg.wait
    end
    time_taken.should be_close 2.5.seconds, delta: 0.1.seconds
  end

  it "works when yielded to a block" do
    time_taken = Time.measure do
      WaitGroup.new 2 do |wg|
        add do |i|
          spawn do
            sleep 1
            i.done
          end
        end
        spawn do
          wg.add do
            sleep 1
            done
          end
        end
      end
    end

    time_taken.should be_close 1.second,
      delta: 0.1.seconds
  end
end
