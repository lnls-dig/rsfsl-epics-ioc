# rsfsx-epics-ioc
## Overall

Repository containing the EPICS IOC support for the R&S FSV/FSL spectrum
analyzer.

## Example

### Initialization

For the IOC on this repository, the initialization can be done through
the following commands starting at the top level directory:


```sh
$ make clean &&
$ make uninstall &&
$ make &&
$ cd iocBoot/iocrsfsx &&
$ DEVICE_IP="10.0.18.77" P="TEST:" R="RSFSX:" ../../bin/linux-x86_64/rsfsx ./stRSFSL.cmd
```

The *DEVICE_IP* specifies the instrument IP.

In some situations it is desired to run the process using the procServ,
which enables the IOC to be controlled by the system. This is done
through the following commands:

```sh
$ make clean &&
$ make uninstall &&
$ make &&
$ cd iocBoot/iocrsfsx &&
$ procServ -n "RSFSX" -f -i ^C^D 20000 ./runRSFSx.sh -i "xx.x.xx.xx" -P "TEST:" -R "RSFSX:"
```

It is important to notice that the *DEVICE_IP* is passed as an argument to the
`./runrsfsv.sh` script using the `-i` option (long form: `--device-ip`). The optional
`-P` and `-R` options specify the prefix of the PV names.


### Caput

An example of writing span is given below:

```
$ caput ${P}${R}FreqSpan-SP 1e6
```

### Caget

An example of reading span is given below:

```
$ caget ${P}${R}FreqSpan-RB
```
