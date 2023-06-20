*** Settings ***
Documentation       Minimal set of YANG datamodels for network elements, as per
...                 ETSI mWT 4th plugtest + dependancies.
Metadata            standard    https://datatracker.ietf.org/doc/html/rfc7317

Library             XML    use_lxml=True
Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Suite Setup         Retreive XML    network_element=NE1    xpath=${SYS}system
Test Template       Element Should Be In System


*** Variables ***
${SYS} =    {urn:ietf:params:xml:ns:yang:ietf-system}


*** Test Cases ***    ELEMENT
Hostname Should Be Present    hostname
Contact Should Be Present     contact
Location Should Be Present    location


*** Keywords ***
Element Should Be In System
    [Documentation]    Verify the presence of element in the <system>.
    ...
    ...    Args:
    ...    - ${name}: The element name, as per RFC7317.
    [Arguments]    ${name}
    Element Should Exist    ${SUPPORTED}    xpath=${SYS}${name}
    ...    message=element "${name}" is not present.
    Log Element    ${SUPPORTED}    xpath=${SYS}${name}