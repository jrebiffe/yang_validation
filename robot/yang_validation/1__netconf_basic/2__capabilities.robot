*** Settings ***
Documentation       Check which capabilities are available.
...                 https://www.iana.org/assignments/netconf-capability-urns

# Library    Collections
Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Suite Setup         Retreive Capability List
Test Template       Capability Should Be Supported


*** Test Cases ***    CAPABILITY    OPTIONAL
Claims :candidate Capability    :candidate
Claims :confirmed-commit Capability    :confirmed-commit
Claims :rollback-on-error Capability    :rollback-on-error
Claims :startup Capability    :startup
Claims :validate Capability    :validate
Claims :writable-running Capability    :writable-running
Claims :notification Capability    :notification
Claims :yang-library:1.1 Capability    :yang-library:1.1
Claims :url Capability    :url    True
Claims :xpath Capability    :path    True
Claims :partial-lock Capability    :partial-lock    True
Claims :with-defaults Capability    :with-default    True
Claims :time Capability    :time    True
Claims :with-operational-default Capability    :with-operational-default    True
Claims :base:1.1 Like A Capability    :base:1.1
# https://www.iana.org/assignments/netconf-capability-urns/netconf-capability-urns.xml
# :candidate Should Be Claimed    candidate
# Support :candidate Capability    candidate


*** Keywords ***
Retreive Capability List
    [Documentation]    Collects capabilties for later processing by
    ...    ``Capability Should Be Supported``.
    NETCONF Setup    NE1
    ${supported} =    Get Server Capabilities
    ${manager} =    Ncclient Manager    alias=NE1
    Set Suite Variable    ${SUPPORTED_CAPABILITIES}    ${manager.server_capabilities}
    Log    ${SUPPORTED_CAPABILITIES}
    Close Session    alias=NE1
    RETURN    ${SUPPORTED_CAPABILITIES}

Capability Should Be Supported
    # TODO: how to check the version?
    [Documentation]    Fails if ``capability`` is not supported.
    ...
    ...    Capabilties have to be retreived before using ``Retreive Capability List``.
    ...
    ...    Args:
    ...    - ${capability}: name of NETCONF capability,
    ...    - ${optional}: True to make the test skip-on-failure.
    [Arguments]    ${capability}    ${optional}=False
    IF    ${optional}    Set Tags    robot:skip-on-failure
    Should Contain    ${SUPPORTED_CAPABILITIES}    ${capability}
    ...    msg=Capability ${capability} not supported    values=False