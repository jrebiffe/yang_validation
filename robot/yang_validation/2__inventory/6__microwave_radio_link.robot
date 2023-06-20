*** Settings ***
Documentation       Minimal set of YANG datamodels for network elements, as per
...                 ETSI mWT 4th plugtest + dependancies.
Metadata            IETF registry    https://www.iana.org/assignments/yang-parameters

Library             XML    use_lxml=True
Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Suite Setup         Retreive XML    network_element=NE1    xpath=${YANGLIB}modules-state
Test Template       YANG Model Should Be Supported


*** Variables ***
${YANG_LIBRARY_FILTER} =    X
${YANGLIB} =                {urn:ietf:params:xml:ns:yang:ietf-yang-library}


*** Test Cases ***                                    MODEL_NAME                    REVISION
Claims "yang" YANG Datamodel                          yang
Claims "ietf-netconf" YANG Datamodel                  ietf-netconf                  2011-06-01
Claims "ietf-datastores" YANG Datamodel               ietf-datastores               2018-02-14
Claims "ietf-origin" YANG Datamodel                   ietf-origin
Claims "ietf-system" YANG Datamodel                   ietf-system                   2014-08-06
Claims "ietf-hardware" YANG Datamodel                 ietf-hardware                 2018-03-13
Claims "ietf-interfaces" YANG Datamodel               ietf-interfaces               2018-02-20
Claims "ietf-microwave-radio-link" YANG Datamodel     ietf-microwave-radio-link     2019-06-19
Claims "ietf-microwave-types" YANG Datamodel          ietf-microwave-types
Claims "ieee802-dot1q-bridge" YANG Datamodel          ieee802-dot1q-bridge
Claims "ieee802-dot1ab-lldp" YANG Datamodel           ieee802-dot1ab-lldp
Claims "ieee802-ethernet-interface" YANG Datamodel    ieee802-ethernet-interface


*** Keywords ***
YANG Model Should Be Supported
    [Documentation]    Verify the presence of YANG Datamodel in the yang-library.
    ...
    ...    Args:
    ...    - ${name}: The module name, as per "YANG Module Name" registry,
    ...    - ${revision}: the revision to be verified (opetional).
    [Arguments]    ${name}    ${revision}=${None}
    Element Should Exist    ${SUPPORTED}    xpath=${YANGLIB}module[${YANGLIB}name="${name}"]
    ...    message=YANG module "${name}" is not present.
    Log Element    ${SUPPORTED}    xpath=${YANGLIB}module[${YANGLIB}name="${name}"]
    # ${module} =    Get Element    ${SUPPORTED}    xpath=${YANGLIB}module[${YANGLIB}name="${name}"]
    IF    $revision
        Element Text Should Be    ${SUPPORTED}    ${revision}
        ...    xpath=${YANGLIB}module[${YANGLIB}name="${name}"]/${YANGLIB}revision
    END

#    Should Contain    ${SUPPORTED}    ${model}
#     ...    YANG model '${model}' not supported    values=False
#    IF    $revision
#    Should Be Equal    ${SUPPORTED_LIST}[${model}][revision]    ${revision}
#    ...    Revision of '${model}' is ${SUPPORTED_LIST}[${model}][revision], not ${revision}
#    ...    values=False
#    END