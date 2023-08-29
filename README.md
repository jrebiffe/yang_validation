# YANG and NETCONF validation

Validation of YANG model and NETCONF features on Network Equipements

The current testsuite include *55 automated tests* which validation of NETCONF
and YANG. It takes around 1 minute to complet all.

That set of NETCONF's "capabilties" and YANG data models is based on 4th plugtest
(see [4th mWT Plugtests report](https://portal.etsi.org/Portals/0/TBpages/CTI/Docs/4th_mWT_PLUGTESTS_REPORT_v1_0.pdf)).
Standard YANG modules include:

- ietf-system
- ietf-hardware
- ietf-interfaces
- ietf-microwave-radio-link
- ieee802-dot1q-bridge
- ieee802-dot1ab-lldp

## Requirements installation

The testsuite is compliant with RobotFramework from version 5.0 to 6.1.1.

RobotFramework framework requires Python:

- Python 3.6 or newer if you are using RobotFramework 5.0 to 6.0.
- Python 3.7 or newer if you are using RobotFramework 6.1.

### Python 3 installation

Depends on you OS:

- Windows: [Download on official website](https://www.python.org/downloads/),
- GNU/Linux: Python is probably installed.

### Robot Framework and dependencies installation

Install all required dependencies using the following command line.

```shell
pip install -r requirements.txt
```

### Edit testbench_variables.yaml

Open the `testbench_variables.yaml` file with any text editor and change the
IP addresses, login and password of both equipements.

If you are on Windows, the Windows Notepad is your straightforward option.
You may be interested on Notepad++, if you want syntax color.

```yaml
%YAML 1.1
---
NETWORK_ELEMENTS:
  ne1:
    netconf:
      host: 172.20.183.168
      username: netconfuser
      password: NotSoSecret123*
  ne2:
    netconf:
      host: 172.20.183.169
      username: netconfuser
      password: NotSoSecret123*
...
```

## Robot execution

Change the working directory to `robot/` and run the robot.

```shell
cd robot/
robot yang_validation/
```

Collect the produced files: report.html, log.html.
Share them in the validation report.
