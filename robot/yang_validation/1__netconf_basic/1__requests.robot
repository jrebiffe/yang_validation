*** Settings ***
Documentation       Basic tests of NETCONF commands.

Library             XML
Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Suite Setup         NETCONF Setup    NE1
Suite Teardown      Close Session    alias=NE1


*** Variables ***
${ERROR} =      RPCError: {'type': 'protocol', 'tag': 'invalid-value',
...             'app_tag': '6890775', 'severity': 'error', 'info'


*** Test Cases ***
Basic NETCONF Get
    ${data} =    Get    alias=NE1
    Log Element    ${data}

Basic NETCONF Get-Config
    ${config} =    Get Config    alias=NE1    source=running
    Log Element    ${config}

Basic NETCONF Lock & Unlock
    Lock    alias=NE1    target=running
    Unlock    alias=NE1    target=running

Self Kill Connection Should Not Be Possible
    [Documentation]    As per the NETCONF standard, a conncetion cannot kill itself.
    ...    https://datatracker.ietf.org/doc/html/rfc6241#section-7.9
    ${manager} =    Ncclient Manager    alias=NE1
    TRY
        Kill Session    alias=NE1    session_id=${manager.session_id}
    EXCEPT    ${ERROR}    type=START
        Log    Self-kill properly returned "invalid-value" error, as expected in RFC6241
    ELSE
        Fail    Kill Session on itself was succesfull, where is shouldnot.
    END