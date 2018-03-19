# rsfsl-epics-ioc
## Overall

Repository containing the EPICS IOC support for the R&S FSL spectrum
analyzer.

## Example

### Initialization

For the IOC on this repository, the initialization can be done through
the following commands starting at the top level directory:


```sh
$ make clean &&
$ make uninstall &&
$ make &&
$ cd iocBoot/iocrsfsl &&
$ DEVICE_IP="10.0.18.77" P="TEST:" R="RSFSL:" ../../bin/linux-x86_64/rsfsl ./strsfsl.cmd
```

The *DEVICE_IP* specifies the instrument IP.

In some situations it is desired to run the process using the procServ,
which enables the IOC to be controlled by the system. This is done
through the following commands:

```sh
$ make clean &&
$ make uninstall &&
$ make &&
$ cd iocBoot/iocrsfsl &&
$ procServ -n "RSFSL" -f -i ^C^D 20000 ./runrsfsl.sh -i "10.0.18.77" -P "TEST:" -R "RSFSL:"
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
"README.md" 88L, 2842C                                                                                                                                           2,0-1         Top

