*** Settings ***
Documentation       Verify that connections are not open with a vendor-specific hook.

Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Suite Setup         NETCONF Setup    NE1
Suite Teardown      Close Session    alias=NE1


*** Test Cases ***
Vendor-Specific Hook Should Not Be Used
    [Documentation]    Some implementations requires vendor-specific
    ...    adjustments, mostly for handling XML namespaces. This is not a
    ...    desired behavior and must be avoided.
    ${manager} =    Ncclient Manager    alias=NE1
    ${device_handler} =    Evaluate    $manager._device_handler
    ${device_handler_type} =    Evaluate    type($device_handler)
    Log    ${device_handler}
    Should Be Equal    ${device_handler_type.__name__}    DefaultDeviceHandler
    Should Be Equal As Strings
    ...    ${device_handler_type}
    ...    <class 'ncclient.devices.default.DefaultDeviceHandler'>
    Should Be Empty    ${device_handler.device_params}

XML Namespace Should Not Have Special Handling
    [Documentation]    Some implementations does not properly set the XML
    ...    namespace, specially the "urn:ietf:params:xml:ns:netconf:base:1.0"
    ...    which should be in the <rpc> element.
    ${manager} =    Ncclient Manager    alias=NE1
    ${namespaces} =    Call Method    ${manager._device_handler}    get_xml_base_namespace_dict
    TRY
        ${ns} =    Set Variable    ${namespaces}[${None}]
    EXCEPT    Dictionary '\${namespaces}' has no key 'None'.
        Log    OK: No default XML namespace.
    ELSE
        Fail    Contains a None Namespace '${ns}'
    END
    Should Be Empty    ${namespaces}