# IRP DDI List checker

> Before running, ensure that the DDI list is the most up to date i.e. that i's last modified matches or exceeds [the one in GitLab](https://gitlab.redwood.com/operations/ansible/roles/irp_ddi_list/-/tree/master/files?ref_type=heads)

The following script will:
1. Query the RTSinfonia database to find all ESP DNXs (ESP2 i.e. SL/TH)
1. Check that the DDI List exists
1. Compare the file with an 'artifact' file

To run it:
1. Remote onto an O&M so either RS002019 or RS002020
1. Win + R
1. Paste the following and hit enter
```
D:\xfer\OWH\Powershell\DDI-Script\DDIChecker.exe
```

Caveats:
- Although a version of this exists that can query GitLab API, the O&Ms cannot do this, so the artifact is stored in `./artifact` in the same location as the exe.