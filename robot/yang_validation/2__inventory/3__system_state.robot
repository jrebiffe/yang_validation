*** Settings ***
Documentation       Minimal set of YANG datamodels for network elements, as per
...                 ETSI mWT 4th plugtest + dependancies.
Metadata            standard    https://datatracker.ietf.org/doc/html/rfc7317

Library             XML    use_lxml=True
Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Suite Setup         Retreive XML    network_element=NE1    xpath=${SYS}system-state
Test Template       Element Should Be In System-State


*** Variables ***
${SYS} =    {urn:ietf:params:xml:ns:yang:ietf-system}


*** Test Cases ***    ELEMENT
OS-Name Should Be Present       os-name
OS-Release Should Be Present    os-release
OS-Version Should Be Present    os-version
Machine Should Be Present       machine


*** Keywords ***
Element Should Be In System-State
    [Documentation]    Verify the presence of element in the <system>.
    ...
    ...    Args:
    ...    - ${name}: The element name, as per RFC7317.
    [Arguments]    ${name}
    Element Should Exist    ${SUPPORTED}    xpath=${SYS}${name}
    ...    message=element "${name}" is not present.
    Log Element    ${SUPPORTED}    xpath=${SYS}${name}