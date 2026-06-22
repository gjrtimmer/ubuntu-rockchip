# rockchip-archive-keyring

Bootstrap package: installs the Rockchip kernel repo signing key + apt source.

**Before publishing:** replace `rockchip-archive-keyring.asc` with the real ASCII-armored
public key generated in the implementation plan's Task 1, then bump `debian/changelog`.
The current `.asc` is a placeholder so the package can be built and reviewed.
