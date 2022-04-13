Installation for Ubuntu with apparmor enabled (default)

- config/exports define what folders are shared with what other hosts

in order to configure the host we need to install the following packages:
```
sudo apt-get install apparmor-utils lxc
```

and activate the following kernel modules:
```
modprobe {nfs,nfsd,rpcsec_gss_krb5}
```

now we activate the apparmor profile with:
```
sudo apparmor_parser -r -W ./apparmor.profile
```