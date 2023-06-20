*** Settings ***
Library         ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Variables       ../testbench_variables.yaml
Resource        ../netconf_keywords.resource


*** Test Cases ***
Several Connections Should Be Possible
    NETCONF Setup    NE1    alias=CONN1
    NETCONF Setup    NE1    alias=CONN2
    TRY
        Get    alias=CONN1
        Get    alias=CONN2
    EXCEPT    TransportError: Not connected to NETCONF server
        Fail    Server doesnot accept several connections.
    END
    Close Session    alias=CONN1
    Close Session    alias=CONN2