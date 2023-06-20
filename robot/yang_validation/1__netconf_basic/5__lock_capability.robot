*** Settings ***
Documentation       Verify that the lock works properly.
...                 Lock is not optional. Lock is mandatory feature, according to RFC6241.

Library             ../NcclientLibraryHuaweiYANG.py    WITH NAME    NcclientLibrary
Resource            ../netconf_keywords.resource

Test Setup          NETCONF Setup    NE1    alias=CONN1
Test Teardown       Close Session    alias=CONN1


*** Variables ***
${LOCK_ERROR} =     RPCError: {'type': 'protocol', 'tag': 'lock-denied'


*** Test Cases ***
Double Lock From A Single Connection
    Lock    alias=CONN1    target=candidate
    TRY
        Lock    alias=CONN1    target=candidate
    EXCEPT    ${LOCK_ERROR}    type=START
        Log    Second lock failed as expected
    ELSE
        FAIL    Succed whereas it should not
    END

Double Lock From Two Different Connection
    Lock    alias=CONN1    target=candidate
    NETCONF Setup    NE1    alias=CONN2
    TRY
        Lock    alias=CONN2    target=candidate
    EXCEPT    ${LOCK_ERROR}    type=START
        Log    Second lock failed as expected
    ELSE
        FAIL    Succed whereas it should not
    END
    Close Session    alias=CONN2