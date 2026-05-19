# Limitations

## Package Availability

`reprepro` is packaged by the Debian and Ubuntu distribution archives. This cookbook installs the distribution package and does not configure a third-party upstream repository.

### APT (Debian/Ubuntu)

* Debian 12 (bookworm): `reprepro` 5.3.1-1+deb12u2 is available for amd64, arm64, armel, armhf, i386, mips64el, mipsel, ppc64el, and s390x.
* Debian 13 (trixie): `reprepro` 5.4.6+really5.3.2-1+deb13u1 is available for amd64, arm64, armel, armhf, i386, ppc64el, riscv64, and s390x.
* Ubuntu 22.04 (jammy): Launchpad publishes `reprepro` 5.3.0-1.4 for amd64, arm64, armhf, ppc64el, riscv64, and s390x.
* Ubuntu 24.04 (noble): Ubuntu packages list `reprepro` 5.3.1-5build4 in universe.

### DNF/YUM (RHEL family)

Not supported. `reprepro` produces Debian/Ubuntu APT repositories and this cookbook is scoped to Debian-family hosts.

### Zypper (SUSE)

Not supported. `reprepro` produces Debian/Ubuntu APT repositories and this cookbook is scoped to Debian-family hosts.

## Architecture Limitations

The package architectures are determined by Debian and Ubuntu archive availability. The default repository configuration still writes `i386` and `amd64` to match the historical cookbook defaults; set the `architectures` property explicitly for repositories that serve `all`, `source`, or other architectures.

## Source/Compiled Installation

This cookbook does not build `reprepro` from source.

## Known Issues

PGP key generation is no longer implicit. Full Migration users should provide `pgp_email`, `pgp_public`, and optionally `pgp_private` properties to `reprepro_repository`, or manage signing keys separately before running the resource.
