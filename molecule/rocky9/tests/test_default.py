# molecule/rocky9/tests/test_default.py

def test_payara_service_running_and_enabled(host):
    service = host.service("payara")
    assert service.is_running
    assert service.is_enabled
