class ClearingTest < AppOptics::Services::TestCase
  class ClearingService < AppOptics::Services::Service
    def receive_alert_clear
    end
    def sample_payload
      {}
    end
  end

  class NotClearingService < AppOptics::Services::Service
    def sample_payload
      {}
    end
  end

  def test_sends_clear
    event = :alert
    settings = {}
    payload = { clear: true }
    assert ClearingService.receive(event, settings, payload)
  end

  def does_not_send_clear
    event = :alert
    settings = {}
    payload = { clear: true }
    assert !NotClearingService.receive(event, settings, payload)
  end
end
