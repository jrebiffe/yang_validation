#!/usr/bin/env python3
"""Patched version of NcclientLibrary for HuaweiYANG."""

from contextlib import contextmanager, nullcontext
from functools import partial
from typing import Any, Dict, Iterator

from NcclientLibrary import NcclientLibrary
from NcclientLibrary.NcclientKeywords import NcclientException
from robot.api import logger
from ncclient import manager


class NcclientLibraryHuaweiYANG(NcclientLibrary):
    """Patched version of NcclientLibrary for HuaweiYANG.

    Allows ``huawei_hook=True`` as temporary workaround.
    Permanent solution is for Huawei is to implement correct XML namespace
    handling.

    = Issue addressed =
    Huawei NE does not set properly the XML namespace in <rpc-reply>.
    That cause ncclient Python module to wait for a proper reply which never
    comes. That results a timeout with the following error message.

    ``TimeoutExpiredError: ncclient timed out while waiting for an rpc reply.``

    = Difference with original NcclientLibrary =
    Compared to the original
    [https://github.com/vkosuri/robotframework-ncclient|NcclientLibrary],
    Only the `Connect` keyword is changed.
    All other keywords are kept unchanged from NcclientLibrary.

    It works by setting the argument
    ``device_params={'name': 'huaweiyang'}`` of ncclient's connect().

    = Example =
    | * * * Settings * * *
    | Library     XML
    | Library     NcclientLibraryHuaweiYANG.py
    |
    |
    | * * * Test Cases * * *
    | My Test
    |     `Connect`    alias=NE1    huawei_hook=True    host=172.20.183.168
    |     ...        username=netconfuser    password=NotSoSecret123*
    |     ${get_data} =    GET    alias=NE1
    |     Log Element    ${get_data}
    |     Close Session    alias=NE1

    = Get New Version =
    The present documentation is version is 0.1.0, (2023-04-26).
    Get newer version at:
    https://gitlab.tech.orange/jean.rebiffe/hytem-robot-framework

    = Bugs =
    The patch does not works in plain Python3 system.
    The patch works in [https://docs.python.org/3/library/venv.html|virtual
    environments].

    Run: ``python3 -m venv env`` then ``source env/bin/activate``.

    = Author =
    - Patch: [https://github.com/jrebiffe|Jean Rebiffe]
    - Original: [https://github.com/vkosuri|Mallikarjunarao Kosuri]
    """

    ROBOT_LIBRARY_VERSION = "0.1.0"
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def connect(self, *args, **kwds):
        """Initialize a Manager over the SSH transport.

        *Warnings are emitted* when ``huawei_hook=True`` is used.

        Args:
        - ``host`` the host to connect to
        - ``port`` the SSH port
        - ``username`` the username to use for SSH authentication
        - ``password`` the password to be used for password authentication
        - ``look_for_keys`` set to ``false`` to avoid searching for ssh keys
        - ``key_filename`` a filename where a private key can be found
        - ``huawei_hook`` bool, ``True`` to enable Huawei's namespace mismatch
        """
        use_hook = kwds.pop("huawei_hook", False) == "True"
        if use_hook:
            logger.warn(f"Huawei-specific hook for '{kwds.get('alias')}', "
                        f"using 'huaweiyang' in device_params")
        # Below is the nearly orignial connect() method by vksori.

        try:
            logger.info('Creating session %s, %s' % (args, kwds))
            alias = kwds.get('alias')
            session = manager.connect(
                host=kwds.get('host'),
                port=int(kwds.get('port') or 830),
                username=str(kwds.get('username')),
                password=str(kwds.get('password')),
                hostkey_verify=False,
                look_for_keys= False if str(kwds.get('look_for_keys')).lower() == 'false' else True,
                key_filename=str(kwds.get('key_filename')),
                device_params={'name': 'huaweiyang'} if use_hook else None
            )
            self._cache.register(session, alias=alias)
            all_server_capabilities = session.server_capabilities
            self.client_capabilities = session.client_capabilities
            self.session_id = session.session_id
            self.connected = session.connected
            self.timeout = session.timeout
            # Store YANG Modules and Capabilities
            self.yang_modules, server_capabilities = \
                    self._parse_server_capabilities(all_server_capabilities)
            # Parse server capabilities
            for sc in server_capabilities:
                self.server_capabilities[sc] = True

            logger.debug("%s, %s, %s, %s" %(self.server_capabilities,
                        self.yang_modules, self.client_capabilities,
                        self.timeout))
            return True
        except NcclientException as e:
            logger.error(str(e))
            raise str(e)