*** Settings ***
Documentation       Keywords shared across several test suites.

Library             NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Variables           testbench_variables.yaml


*** Keywords ***
NETCONF Setup
    [Documentation]    To Call using ``Suite Setup``.
    ...
    ...    Args:
    ...    - ${network_element}: Name of NE in YAML file,
    ...    - ${alias}: Optional alias name, when open several connection to a single NE.
    [Arguments]    ${network_element}    ${alias}=${network_element}
    Sleep    2 seconds
    Connect    alias=${alias}    &{NETWORK_ELEMENTS}[${network_element}][netconf]
    # Connect    huawei_hook=True    alias=${alias}    &{NETWORK_ELEMENTS}[${network_element}][netconf]

# NETCONF Teardown
#    [Documentation]    To Call Using ``Suite Teardown``.
#    Close Session    alias=NE1

Ncclient Manager
    [Arguments]    ${alias}=${None}
    ${ncclient} =    Get Library Instance    NcclientLibrary
    ${manager} =    Evaluate    $ncclient._cache.switch($alias)
    RETURN    ${manager}

Retreive XML
    [Documentation]    Retreive all YANG modules.
    [Arguments]    ${network_element}    ${xpath}    ${filter}=${None}
    NETCONF Setup    ${network_element}
    ${data} =    Get    alias=${network_element}    filter_criteria=${filter}
    Close Session    alias=${network_element}
    ${subtree} =    Get Element    ${data}    xpath=${xpath}
    Set Suite Variable    \${SUPPORTED}    ${subtree}
    Log Element    ${SUPPORTED}
    RETURN    ${SUPPORTED}
