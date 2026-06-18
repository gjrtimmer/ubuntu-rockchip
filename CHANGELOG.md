# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and the
project adheres to [Semantic Versioning](https://semver.org/).

> **Note:** commits made before this project adopted
> [Conventional Commits](https://www.conventionalcommits.org/) are categorized
> heuristically by their leading verb (e.g. *Add* → Features, *Fix* → Bug Fixes,
> *Bump*/*Update* → Dependencies), so older sections are best-effort.


## [2.4.0] - 2024-10-22

### ⛰️ Features

- Add the NanoPi R6 to the oracular suite ([6b8b81a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b8b81a9c4ffad45c8428987c1b40c70c1897dc2))

### 🐛 Bug Fixes

- Correct help list with flavors ([29970e7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/29970e7d8d0a1a8986618b21591c47efa4e71fb5))

### ❓ Other

- Only pin the ubuntu rockchip ppa on noble and jammy ([a581baa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a581baacbb9c19c194cc791e7d9bfc5cf3e528f5))

## [2.3.2] - 2024-09-04

### 🐛 Bug Fixes

- Fix booting from TF cards when Android is in the eMMC ([f7561bb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f7561bbc11e89450854f00741e84ac854c3024e1))

### 🗑️ Removed & Reverted

- Remove git LFS from nightly workflow ([3a449ae](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3a449ae96c71c056171c43a1298cba157f99b8f1))

### ❓ Other

- Unbind AP6256 SDIO interface before rebooting the Orange Pi 5 Pro ([e0cd54d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e0cd54ddf4e1519fb7850405dbef86735146646f))

### ⬆️ Dependencies & Updates

- Bump Radxa U-Boot package ([58b6a6f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/58b6a6f1e72c5b64b706bbe07e597ac81db6922a))
- Update Radxa board names ([f053845](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f053845b66205ed425a2612fb6f7d1587340f426))
- Update Radxa U-Boot package ([426bcd9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/426bcd9c49019b2dba532a61be24ba31d90556b6))

## [2.3.1] - 2024-08-16

### ⛰️ Features

- Add Ubuntu 24.10 to nightly builds ([a2b8ffc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a2b8ffce99de8ad6e8507213f1f6da779949879d))
- Add compatible suites and flavors to board configs ([e21e3f0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e21e3f0b9fd06ed6df37e45e1ffdd5133681bee7))
- Add next workflow for Ubuntu 24.10 ([d99fbd3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d99fbd3d1e0b842df785e18bc427329ced06c12f))
- Add suite for Ubuntu 24.10 ([6aed4b7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6aed4b74187d8a582f786e400586b531b8008e89))

### 🐛 Bug Fixes

- Fix serial console for Turing RK1 on Ubuntu 24.10 ([e485683](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e48568385dc367689248d91ebedb4bb23a3179cc))
- Fix booting from SPI NOR on the Orange Pi 5 ([8787781](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8787781db971ecfd6df48a5675f7ad312d817fd1))
- Fix eMMC not detected in SPL when booting from SPI NOR ([c2a14c2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c2a14c2cfc58f9c0b43684f97e85f8e6a290e009))

### 🗑️ Removed & Reverted

- Remove Git LFS objects ([6f8c385](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6f8c3855a032948e0dc95b6410314ef0c09a68f4))
- Remove Orange Pi U-Boot again ([6c888e8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6c888e8b61a3b12b2dc554d18ad68a53deb42a71))
- Revert "Remove Orange Pi rk3588 U-Boot package" ([0ae00ca](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0ae00ca3ee96325d58050002c159fb0b02f6bc3a))

### 🚜 Refactor & Cleanup

- Use dynamic matrix for nightly builds ([be74529](https://github.com/gjrtimmer/ubuntu-rockchip/commit/be74529adb04bc22eb233f3d2acb84e3329a6ee9))
- Build all suites for nightly builds ([63c68a5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/63c68a5ff3dbc618bf12f255eed8432f50175692))
- Set UART console output for the Turing RK1 on Ubuntu 24.10 ([0013909](https://github.com/gjrtimmer/ubuntu-rockchip/commit/001390997110706133b7a0d5800adfcfd438d6d0))
- Use dynamic matrix for oracular building ([7de81d6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7de81d62521627d23391094f750856640cf8f3a9))
- Move kernel flavor and extra ppas into suite config files ([58da196](https://github.com/gjrtimmer/ubuntu-rockchip/commit/58da196a70a9aa09991fd1df5f55e8fe8b624887))
- Move extra packages to the meta packages ([2ddb365](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2ddb3650bd026deaf328e0c414d3a1d96b5b3472))

### ⬆️ Dependencies & Updates

- Bump U-Boot Radxa package ([5a28507](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5a2850713b10e2c0aff24daf8b9cb3db01c77fdc))
- Update Ubuntu 24.10 kernel info ([6b980ca](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b980ca031dbb5d302e0ed51ddfbdc09c46693e3))
- Update all board configs for new suite ([ddd8d62](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ddd8d6216e4a281d1d1bf580549eb8da688fa4cb))

## [2.3.0] - 2024-08-01

### ⛰️ Features

- Add ap6611s dkms and bluetooth support for the Orange Pi 5 Max ([6ec8837](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6ec88376b11d4fee7f26e5ff4ecf4f794ce6c598))
- Add GitHub issue templates ([c67a99c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c67a99c6479b5d9688aecfac05fe0baf20da2eb2))
- Add ArmSoM AIM7 and Sige7 to build workflow ([2e5175a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2e5175ac99cb910b8d857c6595057e90358922b5))
- Add U-Boot support for the ArmSoM AIM7 ([8446355](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8446355b9a97c65e61651482dfd214052b86e875))
- Add the Firefly AIO 3588L to workflow ([f7f4cd9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f7f4cd9559843291a9375d4fedc8d33951e3bac1))
- Add necessary configs and patch for u-boot to support AIO-3588L ([c08bb85](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c08bb857aa5532c226c9d02d4458ffc17c6b5c3a))
- Add the Orange Pi 5 Max and CM5 to build workflow ([f669c24](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f669c244ac02a0ab7468562fd3749dbe0dd1af1c))
- Add board targets for the Orange Pi 5 Max and CM5 ([c4a463a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c4a463a26369219c6979c5b486627b6fbc6361be))
- Add U-Boot support for the Orange Pi 5 Max and CM5 ([169debb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/169debb2b6a63c219bc27a36b833098ab34a0798))
- Add Orange Pi 5 patchfile to series ([13b6cee](https://github.com/gjrtimmer/ubuntu-rockchip/commit/13b6cee52ee1d56eb053b7222436d6de4c3ffd39))
- Add the ArmSoM Sige5 to workflow ([d1b04d5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1b04d508f2ab71ecb1cbbcb1725b0396d4badf9))
- Add nightly build shield ([d24c328](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d24c3283c57d49d6bb9ea0de682d09a7da0b48e2))
- Add U-Boot support for the ArmSoM Sige5 ([0c049f0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0c049f0ff564afda028d5ccc669ee511708c77b1))
- Add board configs for the ArmSoM Sige5 and AIM7 ([75340b1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/75340b16e6cee262300a3ef635cf97869010079d))
- Add soc and cpu exports for website parsing ([833bb75](https://github.com/gjrtimmer/ubuntu-rockchip/commit/833bb7571311e50ef3deb260f2c1051d07f6a970))

### 🐛 Bug Fixes

- Fix filter-out rule in Radxa U-Boot ([a515e59](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a515e599bf568f1983ab4572223c2707e8003d3a))
- Fix Orange Pi 5B U-Boot targets ([faeb47b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/faeb47bdc988211219097802278244bf98d39109))
- Fix rock 5a typo ([4524ddd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4524ddd2675492fc6d16aa32f9e6b5e071e55933))

### 🗑️ Removed & Reverted

- Remove Orange Pi rk3588 U-Boot package ([118dd59](https://github.com/gjrtimmer/ubuntu-rockchip/commit/118dd59535e917a0bd70f72518bf212bc01199da))
- Revert "use next kernel branch for testing" ([56b8ea1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/56b8ea141a3fe413b0d97b2ba825234b7dc17803))
- Remove docker support ([279dc46](https://github.com/gjrtimmer/ubuntu-rockchip/commit/279dc469ca7c6d226d06ed7e19e7d3591b00bb57))

### ❓ Other

- Sort board matrix in workflows ([ffb0870](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ffb0870a8df4c4342c39b4d3861c83bdbea52544))
- Blacklist panfrost on the ArmSoM Sige5 ([47e11ad](https://github.com/gjrtimmer/ubuntu-rockchip/commit/47e11adb4453e103af72a2ed62bfbba3f813de45))
- Recommend both tools ([302416f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/302416f0a7c0ac1676839c3b939a780e23f38d46))
- Import ubuntu live build code ([e81c56b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e81c56b698421f14cd498bf1bdae1368584f0a73))

### 🚜 Refactor & Cleanup

- Move Orange Pi 5 Plus / 5 Pro to Radxa's U-Boot ([88f17e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/88f17e6c4f8853677e15dcec123af0a525efb193))
- Move Orange Pi 5 / 5B to Radxa's U-Boot ([d52fafa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d52fafacb02ac130854c0d2705bb0074d79d75f2))
- Change recommendation for img burning ([677599e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/677599e0c4114a6ac17c0959a7aa6d9502bbb5d1))
- Use next kernel branch for testing ([5e2f405](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5e2f40546a0c556fcb6f200247c4b58840cd5546))
- Install camera-engine-rkaiq by default for rk3588 ([9bd62ce](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9bd62ceb9cab3b6dffa831e7e162438508262baf))
- Install libmali blobs alongside panfork #879 ([6c94a19](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6c94a193fd29a0e7cef9683bdd3671964498aa69))

### ⬆️ Dependencies & Updates

- Update Radxa U-Boot changelog ([470b3f6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/470b3f61c5b92246ec66cde313bb6b59967ee136))
- Update README.md ([d5110bc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d5110bc3dcf001bf6d665120c906bcbd597da03c))
- Update Radxa U-Boot changelog ([2c65fd8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2c65fd86db751ab00f1b9f1faf9ae12ded6167fe))
- Update RK3576 upstream and refactor U-Boot ([50e63a4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/50e63a41c669e76917057d64e2609ea631e2dd7e))
- Update readme ([912fdef](https://github.com/gjrtimmer/ubuntu-rockchip/commit/912fdefc2374ccec5800c3e539b34e43a91f446d))
- Update readme ([5fb5909](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5fb5909f5fb60a75444c020cddb1a6455dc8d504))
- Update README.md ([4ad5122](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4ad5122fca919e755bab8f6be0aae5048459ddf1))
- Bump radxa U-Boot to next-dev-v2024.03 ([67f3370](https://github.com/gjrtimmer/ubuntu-rockchip/commit/67f337027a3c0a6efae3fc5b8d11a4eae7c45e5f))
- Update and refactor readme ([2f91df8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2f91df892790b4d7ef10fbd26d4a5fd785a376e3))
- Bump upload-artifact to v4.3.3 ([cfca915](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cfca915c6f78ce47bba83378e4328266e95525b3))

## [2.2.1] - 2024-06-13

### ⛰️ Features

- Add aic8800 udev rule for the radxa zero3 ([d3afad1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d3afad17ea30be962b945ed5cdc5d0ab255e6100))
- Add E-Key slot nvme boot support for nanopc t6 in u-boot ([618568c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/618568c6e61fbd55734905643700902655e2f475))

### 🗑️ Removed & Reverted

- Remove rkaiq camera engine packages ([45c151d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/45c151d64077509dc2ced799b04a46fee9685d8e))

### ⬆️ Dependencies & Updates

- Update the ddr and spl blobs for the Turing RK1 ([29550ca](https://github.com/gjrtimmer/ubuntu-rockchip/commit/29550ca332c4c39af58816bdb353f2718cd42601))
- Update u-boot-install scripts and add package changelogs ([8bc6762](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8bc67629a83cfbd585fb2d46e7ee3893f016deb9))
- Update all rk3588 boards to use the new ddr and spl blobs ([cab28b0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cab28b0443a57a0ce192a97113a506a5de1b2af0))

## [2.2.0] - 2024-06-06

### ⛰️ Features

- Add radxa cm5 rpi cm4 io to github workflow ([a36f41d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a36f41d6115afa17fbc7b5427eb6417b7e275e46))
- Add the radxa cm5 rpi cm4 io ([3e0b4ea](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3e0b4eabdd21dae26040a2a942121897694b1e76))
- Add aic8800 dkms to the rock 5c and 5d ([1765228](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1765228552cea6b09ca1ff1f26384ae60b26285c))
- Add the rock 5b plus, 5c, and 5d to workflow ([8872c18](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8872c18c258e4a3143640fa8ccddeb83f6ff37c0))
- Add the rock 5d ([475dd08](https://github.com/gjrtimmer/ubuntu-rockchip/commit/475dd08b0e924a6854a378849e7a1d99a21065c3))
- Add board targets for the rock 5c and 5b plus ([433d915](https://github.com/gjrtimmer/ubuntu-rockchip/commit/433d915db3e2c9a45ee7ae31d870822ac987cf89))
- Add nightly github builds ([484fe79](https://github.com/gjrtimmer/ubuntu-rockchip/commit/484fe79d8d2d0d853f78af8d6d41b3b11d94bae0))

### 🐛 Bug Fixes

- Fix typo and update rock 5b bl31 and ddr blob #853 ([9d8d82b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9d8d82b37017f07ef7baa8368e8c87639e85a939))
- Fix rock 5d u-boot rules target typo ([cfab4af](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cfab4af390e187961a26c1d4687c67e253bc78fb))
- Fix shellcheck warnings ([bc586f6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bc586f61298a341cc8f1a90bb4a1855bdcece6b6))
- Fix roc rk3588s u-boot typo #811 ([4f961a7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4f961a7315023534ff0b917f5ece79616ed6169f))

### 🗑️ Removed & Reverted

- Revert "use docker to build custom kernels" ([ecfb26b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ecfb26b606a3d588ede147ff8729c1d172b55126))
- Revert "test build for radxa 8hd and 10hd displays" ([93b2d0d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/93b2d0d370662472ae3e8925ce2c38735d8524cd))
- Remove mainline workflow ([b199cfa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b199cfa0d82af84fe9309aafe5d803942bb499aa))

### ❓ Other

- Force boot from emmc for the rock 5 itx ([d0aa66c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d0aa66c4c17cb43825a88440be3568c7f892753c))

### 🚜 Refactor & Cleanup

- Use ttyS2 serial console for new radxa boars ([6b2798a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b2798a4dd601df4e0a0b19c9de07e645123972d))
- Use aic8800 dkms for the radxa zero 3 #852 ([fe4e35f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fe4e35fd4affa3ca857487d58b56362a9c8d880b))
- Use docker to build custom kernels ([401896b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/401896b3a5c092a9c388bb4777ee35a7be3899b0))
- Run buid-u-boot script when building u-boot ([20a4f79](https://github.com/gjrtimmer/ubuntu-rockchip/commit/20a4f79dacb9c71e8287e7567e8859a2cf2431fd))
- Cleanup main build script ([8cecd7b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8cecd7bfbe988bd5727ebca5b3dadfcbdfbce7e4))
- Rename release to suite and project to flavor ([47b7743](https://github.com/gjrtimmer/ubuntu-rockchip/commit/47b77436dd3c467b25cab1cf6e79d0682133cbc6))
- Use ttyFIQ0 serial console for new radxa boards ([2a56011](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2a560112efca5e0f47dc5bc98c13ab777ff04eef))
- Install custom kernel and u-boot packages when launchpad param is not passed ([2284bcd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2284bcd7990abbb2bb0530605edf3b512e505abd))

### ⬆️ Dependencies & Updates

- Update ArmSoM links for sige7 and w3 ([1e3f221](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1e3f221a3bafb756d7633d56c7c8ea0dd4f27ac1))
- Update radxa u-boot changelog ([af6ba5e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/af6ba5e96528c63ae6409100c93a78d162e73627))
- Update radxa rock5 bl31 and ddr blobs to improve stability #853 ([473513a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/473513ae57d609327cf9c2bb44b6a7da0a3439cd))
- Update release workflow name ([aebe3e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aebe3e63f22e47ea18236fb0b1a5f734f762579a))
- Update build workflow run name ([01e4537](https://github.com/gjrtimmer/ubuntu-rockchip/commit/01e4537bd0932a5fde1076971518ec84b1662d3e))
- Update radxa u-boot changelog ([08d8206](https://github.com/gjrtimmer/ubuntu-rockchip/commit/08d8206742d3787a1bde70919a7e195149852893))
- Update ddr and spl blob for the rock 5b plus ([b988001](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b988001a18a50183cf210500bacabdeca1c94fc7))
- Update radxa u-boot control info for rock 5c and rock 5b plus ([6b7f287](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b7f287ac006a3c354d3a160aa1a848e8869cc6b))
- Update radxa u-boot for the rock 5c and 5b plus ([3adaf37](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3adaf376efc536a7b47010e0a629aea3dd348dd8))

### 🧪 Testing

- Test build for radxa 8hd and 10hd displays ([0b0015a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0b0015a676cc990915faaf210788acc138e191f7))
- Test gh actions fix ([3d2030c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3d2030c5084f75fa2483f0f951fd578df9d348b5))

### ⚙️ CI & Build

- Build custom kernel on github actions again ([c2d9c9a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c2d9c9ae7b08dc0ed575662f84100905c476a8cd))

## [2.1.0] - 2024-05-11

### ⛰️ Features

- Add overlay dir path again ([4f82598](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4f825986c99f7ba9c6b3a2604108c455feb45096))

### 🐛 Bug Fixes

- Fix typo when sourcing boards ([7d2a214](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7d2a2148d8a861e3c6287f0a7af026d9f581db07))
- Fix adding default user to the video group in user-data ([bb5ef7c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bb5ef7c4870b259c93aadd7fa5ac6dd0215ac000))

### 🗑️ Removed & Reverted

- Remove more unused rootfs overlay tweaks ([47ee7f9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/47ee7f90ed3daee2b1b6796c46213d10b6265f21))
- Remove unused rootfs overlay tweaks ([e8bde78](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e8bde789fe4b9afc93a98891dd6453c6ebe78548))
- Remove audio udev rules and install panfork with a hook ([838f0dc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/838f0dcc7299f2fbc0948333f030ba42991d57f3))
- Revert "make network interfaces non-optional in network-config" ([96f9df8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/96f9df82e72fe3acc3bcf40aced9806760b3bcab))
- Remove docker rootfs build ([4776521](https://github.com/gjrtimmer/ubuntu-rockchip/commit/47765214ec7efb50483d3d20e26c1ec68443bc47))
- Remove unused board vars ([600ef7e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/600ef7e4f32e960b2ba5b248791c03b9f667d5e3))

### ❓ Other

- Export release configs ([6922988](https://github.com/gjrtimmer/ubuntu-rockchip/commit/69229886863b5a5f82ffb1406646ddb4cf582e42))
- Override localisation settings to address a perl warning ([eaa05a7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eaa05a7e727e6da5a0379e37f9ab790c767d43f0))
- More cleanup for the config image script ([ca0fbab](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ca0fbab394208a47845836035655a66ea20ed327))
- Re-work rootfs and config image scripts ([6bb90ff](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6bb90ffabe04b99ec6379fee83b323cf39698a91))

### 🚜 Refactor & Cleanup

- Refactor supported boards ([09a01d8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/09a01d8394b922877ae4d91930d3ab2a615c0e5a))
- Use only a config image hook for the turing rk1 ([ede10d2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ede10d2331936b6cb1ad64811b9a53c8fdbd964c))
- Cleanup system release configs ([3ba55fd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3ba55fdbf46b9ecbd2088fe8a1041ddf20bdf1f5))
- Make network interfaces non-optional in network-config ([70348ef](https://github.com/gjrtimmer/ubuntu-rockchip/commit/70348ef1527f651bd6d831baba387d8be8eee0a2))
- Use ubuntu version number for rootfs workflow ([af02705](https://github.com/gjrtimmer/ubuntu-rockchip/commit/af027055e355b449044f1c84781aa03fcc75b558))
- Rename server and desktop projects ([3dc78e1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3dc78e125bdf8edc5f35f4e62366aa3739054db5))
- Cleanup teardown mountpoint ([cd28934](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cd28934436227bb43e36374a36f7c964cd4a6851))

### ⬆️ Dependencies & Updates

- Update ddr and spl of the orange pi 5 pro ([bc139b2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bc139b2319a783a1d2dcd2192351cbf6d85af3e7))
- Update ddr and spl blobs for the orange pi 5 pro ([f271d0b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f271d0bb0d23c78ac188195d3b2ef7c6a38229ee))

### 🧪 Testing

- Test installing panfork after rootfs build ([662888b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/662888b19efbfe1fa64ae607ac4757a88930d78c))

## [2.0.0] - 2024-04-30

### ⛰️ Features

- Add the Orange Pi 5 Pro to release build and remove RK3566 ([66d8e03](https://github.com/gjrtimmer/ubuntu-rockchip/commit/66d8e033bc5377108e80a00f25ec20e1edce27c6))
- Add aptitude to rk3566 ([842fca7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/842fca7ea9c50a24fd3684a35bbfc0c25a31118e))
- Enable wifi and bluetooth for the opi5 pro ([75859e4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/75859e4fd50c9931905955590e634eb7df72724b))
- Add Orange Pi 5 Pro build target ([52258c4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/52258c49ce7dba52c5f122969a92441c0b6d2b74))
- Add the orange pi 5 pro u-boot ([ea7abc9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ea7abc95c0233a77b199741c17b23d1db3daeef8))

### 🐛 Bug Fixes

- Fix bluetooth for the opi5pro ([077620f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/077620fbdf22a636c76aea34879b95851403ab38))
- Fix removing panfork from rk3566 ([cbdeb2f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cbdeb2f9a61c76335db5e3bbeeed6cd4ff329bb1))
- Fix ubuntu server for noble meta package ([a2b34c8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a2b34c8fb170da75061a7c9c924cf2054eebfa65))
- Fix bluetooth for the orange pi 5 pro ([f201f12](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f201f12f8a804b125e8e2bc6571a3a95ee3bd4c9))

### 🗑️ Removed & Reverted

- Remove module blacklist for opi5pro ([7df257b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7df257bbf6ee568ed49056642c1a2615c5930d78))
- Disable rk3566 panfork for now ([08243dc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/08243dc49172e5e8ce2e7b50961b5dc75cab97c0))
- Remove ubuntu 24.04 beta ([48e45bf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/48e45bfc266089ef6f29de7c15fbe9d62fb8cfae))
- Remove panfork for rk3566 ([0edebe7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0edebe763f38a8333e72ffec769a78b6beb5b632))
- Remove server branch of live build ([279e198](https://github.com/gjrtimmer/ubuntu-rockchip/commit/279e19892a34dad3ffb0d3821ba8281117122a88))
- Revert "prepare for noble release" ([e99d1a8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e99d1a897f27770919e4776e12554f13653ca6b7))

### ❓ Other

- Dont re-build noble rootfs ([7e9a570](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7e9a570240671a3a43b5705333c97385ef57de57))
- Hack to make bluetooth work for the radxa a8 module ([230496d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/230496dc770dd2d0b1ef54c26d9ed647c62871c4))

### 🚜 Refactor & Cleanup

- Use older ddr and bl31 blobs for the Orange Pi 5 Pro to prevent corrupted kernel stack ([181f3f9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/181f3f9268e6e7f7a3deebdb4f60d931ce56b439))
- Rename radxa a8 bluetooth fix service ([d1e54e0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1e54e03869998a7d1f809613ab20c613a000892))
- Cleanup for noble ([018fb51](https://github.com/gjrtimmer/ubuntu-rockchip/commit/018fb517b7a1af9b2897d0ac1a396719f50a167a))
- Refactor armsom seige7 pd patch ([d1854b3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1854b3a840780263619847a04fbbba2809e1654))

### ⬆️ Dependencies & Updates

- Update readme ([6fa6a5c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6fa6a5cb38c6eec01ea1ba7b21045574104711d4))
- Bump radxa u-boot package ([187f7e5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/187f7e5d77f194664c66a39e26f847bbf89a4196))
- Update opi5 pro blacklist ([3b97f4e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3b97f4e01c8f2a7188feb8d3274de9fdb3b4e906))
- Bump for beta release v2 ([9cdf14a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9cdf14ad4e1fa87bd50f21573d28d266726e6a6b))

## [2.0.0-beta] - 2024-04-12

### ⛰️ Features

- Add desktop live-build ([243f714](https://github.com/gjrtimmer/ubuntu-rockchip/commit/243f71473bb4d2f2ad219620d378b1589c5702d7))
- Add extra groups to adduser config with sed ([c7be8c3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c7be8c334bd7959be1e752003964da43ab47e511))
- Enable armsom-sige7 early PD negotiation ([4df1688](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4df16884c1f42363cfade719f0e2c69d2c8ecf58))
- Add image building hooks for noble and jammy ([eb48296](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eb48296d74506f8cfb93101c53a8b57817be3181))
- Add multimedia config and mali firmware to server image ([13bb298](https://github.com/gjrtimmer/ubuntu-rockchip/commit/13bb2987f5b1d78ddbeef44670f0b684138159e9))
- Enable wayland on gdm3 with sed ([e1bfeb5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e1bfeb525939f18c4b998f9e6be79e1aceda2303))
- Create a partitioned loop device with loopdev #626 ([d146111](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d14611195e37031eaa0b30372ec86f51dac1cded))
- Add release matrix ([236ad7c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/236ad7c782ff3304a3b3b107e1b265579db0579d))
- Add wireplumber config for audio devices ([efd18b2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/efd18b21954d40ddb4648ae3fa02f479622c8999))
- Add avahi-daemon to the list of default packages ([7a257d9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7a257d9eb8ddc638053263c0ad2072447915304b))
- Add build for rockchip linux 6.1 ([f2cf244](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f2cf244920f146c036d708f917f3fea79d7a2edb))
- Add rockchip to kernel name ([913854e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/913854e37a96a377975567f90a8d1313eb4cf6bc))

### 🐛 Bug Fixes

- Fix missing board from release ([4553de2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4553de2ea8ab216b4e5808e72ac164e7c435960c))
- Fix release ([1be345e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1be345ea87c9b4268c45bc5ed4a78fda47a41fac))
- Fix release workflow ([1c8f277](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1c8f277e0748d12cdd525c5394f11b38788194c5))
- Fix config image ([6e7a5d4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6e7a5d4b0aa9cd9640c5dba550ccde62d65d03e2))
- Fix u-boot-menu on noble ([b9ab783](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b9ab783a63251fff9b7491073b5bd56c3f7d3477))
- Handle the config of rk3566 images better ([e5e1b0e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e5e1b0e4a38421eee9b8b73d6465547b5f87e71f))
- Fix default groups in adduser config ([077942b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/077942bb6b1f8572e0c6fd31c1a0a62a4259e559))
- Fix mpv config again ([7545017](https://github.com/gjrtimmer/ubuntu-rockchip/commit/75450179e73adf87bf5b6eb1d36a96004c6f3c0a))
- Fix mpv on noble ([5b49278](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5b49278411384ed8568d5655ef6fc07903d5e6a9))
- Fix rk1 board config ([fd843e3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fd843e3c03bfd4d40b7ee23f507a28e3813c8f61))
- Fix building for rk3566 ([4ecd5e5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4ecd5e5a40825a48d1dd2233a9e1d56c8353ee34))
- Fix ppa pin typo ([6226a03](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6226a03de7d15e44cc329c1d7d6cbf0f5a959e1b))
- Fix rootfs uuid not being updated into the initrd ([94c206c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/94c206c8a27a01b8cd98196a27d942069467f12c))
- Fix turing rk1 conf for noble ([aece9ea](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aece9ea06fa32f0afa339612558db7b28b9805ee))
- Fix typo in cloud image #672 ([3ee607c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3ee607c0b79b251c6085923d8d1b77ea2ad81f07))
- Fix instance id typo for cloud init meta data #672 ([afb59ef](https://github.com/gjrtimmer/ubuntu-rockchip/commit/afb59ef7218f8ae8ac53745a596a5754e8ca4bd2))
- Fix chrome default path ([f80acec](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f80acec9127dd526e134dcc5d55f9b7982f975e5))
- Fix rfkill.conf not being in the chroot dir ([749e7af](https://github.com/gjrtimmer/ubuntu-rockchip/commit/749e7aff706d13865718448c45f98cec72f08dc8))
- Fix typeo ([4d3da7d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4d3da7d5f1bb3316279549e6188ec3dd67055cbe))
- Fix typo ([44d5286](https://github.com/gjrtimmer/ubuntu-rockchip/commit/44d5286ea8a6ac1e33ebfaddc350a146c15110a4))
- Fix u-boot compile with gcc 13 ([5b55924](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5b55924fff11e942bca3e87b9fc24ba3b34b000a))
- Fix noble build again ([2ef6594](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2ef6594eaf41357827ccd24bb4dd0551b121dfc1))
- Fix release flavor ([797e69a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/797e69ab751bfe4a008fba801826ec1fa05964aa))
- Fix project matrix ([9d74845](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9d74845b51fd9a49ef7df27cf00997376d9a7b1e))

### 🗑️ Removed & Reverted

- Remove x11 config - this is not required ([4595813](https://github.com/gjrtimmer/ubuntu-rockchip/commit/459581322448a8972856c244783da14680bfd8e4))
- Remove wireplumber custom config ([06cc8d5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/06cc8d588ddb000e53678e315e35c9869b25c56f))
- Revert "add multimedia config and mali firmware to server image" ([69a7ee0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/69a7ee034927a4b6e49b2e9ee96ab77f36735bf5))
- Remove noble extlinux build script ([f2d831e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f2d831e400f19a37f432c9232f229928c2dc528e))
- Revert "change jammy version to 24.03" ([f84948c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f84948c6a92ddbec33cfa7ecceb7fa3b5ea7f6d2))
- Remove a few installed packages for noble ([81e6789](https://github.com/gjrtimmer/ubuntu-rockchip/commit/81e6789319069889b9f94fb639d8df025c4ceaba))
- Remove my multimedia ppa ([ba67866](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ba67866681bb0e6d74d50901c54167e4d6eddbb3))

### ❓ Other

- Initrd ([63605e7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/63605e7ded1b9bc6b5a4cc0784ba55aa8d2a27da))
- Wip ([98850be](https://github.com/gjrtimmer/ubuntu-rockchip/commit/98850beb4763629f3e374673f88d9be825b906b2))
- Modify the board configuration information for armsom-sige7 and enable Bluetooth for AP6275P. ([d2165a6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d2165a64c38c6a3aefb7ad198aba433d2d2a3cd3))
- Migrate to extlinux ([1207608](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1207608d6c30159b9d35b4941e3c3debc2bbf069))
- Noble beta ([73ab6ab](https://github.com/gjrtimmer/ubuntu-rockchip/commit/73ab6ab07a8866ea681c6272260cf2565c60f8dc))
- Only apply mpv config to rk3588 ([340fb77](https://github.com/gjrtimmer/ubuntu-rockchip/commit/340fb77d476a5ce660d0238cac725ed1e0cfb25b))
- Adjust board configs for noble ([0a6cf86](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0a6cf86008fa5d77ddcc6be223ddfd77c5f0b45d))
- Hack ([f7872f6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f7872f6157636df299378bad4147d953eca72d63))
- Use extlinux for noble ([c417323](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c41732345570215e82f5d240336f41120c20a499))
- Unblock all wifi / bluetooth devices for noble ([fdaa850](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fdaa850082784c1d17238951018dab2028e97d93))
- Switch multimedia ppa for noble ([8d4c577](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8d4c577f93509e05b278e6c069660d3007258aab))
- Test building noble on github actions ([9f004d4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9f004d4cf46896378a1c854432873e959a252609))
- Add support for building noble ([0c4841e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0c4841e430a5e151c84f0695a5b90e377124ba9a))

### 🚜 Refactor & Cleanup

- Increase image compression ratio ([948848a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/948848af0f01775b1fb374d19d0813d975c4d7c0))
- Increase disk image size by 1 GiB ([94c922b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/94c922b733dcff5b81815b51229c4b95ec410fea))
- Run apt update before config image ([656ebdf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/656ebdfc34c539a96d664d0487d518fd4afe8f2c))
- Use live-build for noble preinstalled-server rootfs builds ([d416b48](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d416b48ee19c274ad82f2f2aea025d58a63ab30f))
- Use a diffrent partition layout for ubuntu server and desktop ([d5a9154](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d5a9154f2facc09d35fb09cdbbf46cd9ad243132))
- Set a default kernel for ubuntu 22 and 24 ([86ef133](https://github.com/gjrtimmer/ubuntu-rockchip/commit/86ef13340bb53b50de34754b83e3f2e1c05efde6))
- Install the mali g610 firmware and multimedia config on ubuntu server ([c21273a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c21273ae8e1845983c5f0c86a844b8a0574b244b))
- Improve cloud-init startup and delay getty untill cloud-init is finished ([c9a939a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9a939a17a5a6c6d65c44888047bb5b4c8abb6cb))
- Move config preboot into the armsom defconfig ([586813a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/586813a199822df762025c187d20ab65042a63f4))
- Use cgroups v2 by default #665 ([dd47083](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dd47083ea67387985bda0210c13208d36c782a26))
- Use flashcp to update the spi flash ([9f05ee7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9f05ee7a9afd46d328e1bc7637f6e392112687d2))
- Move mpv config to /usr/local/etc/ ([866af1c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/866af1c132398c96eeeac923b5de1dc877196b9f))
- Use flash-kernel again ([871c52c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/871c52c2a3eb3c1e603e97e8532d6ae5e4134407))
- Cleanup kernel cmdline for noble ([9ecce81](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9ecce81ca022f010120db5063ccbebfac5f6c15f))
- Cleanup config image script ([3a13d05](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3a13d05c55ac15df9e6a9da1ec3c46efc0d1d619))
- Set chrome and mpv as default apps for noble ([04c3bf7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/04c3bf7f863f885d508107cacae5e54638cfdee3))
- Use rockchip kernel from launchpad ([16bd88e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/16bd88e284fed0c7c123fe7953ed7b0d429cfe73))
- Cleanup disabling the update manager ([b9b40d0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b9b40d074c6a0f0b55ab107bbdc994c6d736577e))
- Cleanup initramfs changes ([18a249e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/18a249e1f0bc6fff7eb7f2c9292d66fe88fb029e))
- Change jammy version to 24.03 ([2f3e050](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2f3e050a56ff116c3e6b687df980d1c3d01595d2))
- Refactor build workflows ([f26b711](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f26b71137a147288d2b1fc97a714c2e533dde458))

### ⬆️ Dependencies & Updates

- Update release workflow for noble beta ([d1d535c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1d535c4de624953b9306a7ba18cee3188aa9219))
- Update u-boot radxa package on launchpad ([f4db595](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f4db595bba53c016c18c125c1ca18705a36b36da))
- Update branch for linux 6.1 ([a8d015f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a8d015fe3914f0e9b9acc0d4ac2f5ef16f8f1fbf))
- Update board names for flash-kernel ([c75bd0e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c75bd0eecbe9f8325fb0dc2b0e22d60b10887a2d))
- Update rtl8852be reload script for the 6.1 kernel ([ccc3a36](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ccc3a36360c0b080867bd8b78e3ec62db3341bfc))
- Update the default mpv config ([b3119a3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b3119a3da6e102cd0d442a4e14cc04a3c137946b))

### 🧪 Testing

- Test release fix ([e2c5578](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e2c5578afae8ea7be44328835e7ba009ae46973a))

## [1.33] - 2024-01-30

### ⛰️ Features

- Add wiringpi-opi to the orangepi 3b ([a7aa0e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a7aa0e6b3eb529cb6389e2bc3b9d011e418f1dc3))
- Add the radxa zero3 to u-boot 2024.01 ([7824875](https://github.com/gjrtimmer/ubuntu-rockchip/commit/78248752ff10e040119867b57f52504946bccc97))
- Enable bluetooth for the Orange Pi 3B ([100dddd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/100dddd9a994eebb0d142728e2420c6fc76a1dc3))
- Add cloud-init config for all wireless lan interfaces ([ae6a140](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ae6a1400ee73e67f164b24b0a981114aea3ed5cc))
- Enable AIC8800 bluetooth for the Radxa Zero 3 ([52cb1ae](https://github.com/gjrtimmer/ubuntu-rockchip/commit/52cb1ae5b520b2f5047e889e101c8ab842dadfae))
- Add rockchip multimedia ppa for rk3566 boards ([f3dd80a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f3dd80a9ecb6e47506c6594e87b800006403f9b9))
- Add psmisc package to the default installed packages ([1e99841](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1e99841f10902bce387a2c97d63c45dca079ee37))
- Add orangepi 3b to github workflow ([66dee3e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/66dee3e02c6209bf93390f153b4442e69b764476))
- Add support for the orangepi 3b ([4b9e3b3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4b9e3b358b529c18e4caf22212102a9e5adec573))
- Create swapfile on boot ([8c61d69](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8c61d69d50d7f63d8511eb408e7cce627e73bfbb))
- Add the radxa zero 3 to github workflow ([82310da](https://github.com/gjrtimmer/ubuntu-rockchip/commit/82310daceff66dfd96b040dd06a3f7a43920c5f8))
- Add a name to the build step for mainline workflow ([7ed2e88](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7ed2e887f9b9d8bdc75d7aa7af31231bed3170db))
- Add desktop rootfs to mainline workflow ([bfa584d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bfa584d15103c4fe56cc2278293f9054874463a1))
- Add matrix to rootfs build for mainline ([a5713e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a5713e69223a1acb91df09e22c82c22403a63e31))
- Add u-boot build target to config files ([8a34766](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8a34766401d0d65f7f907b63b0a037a0179d8c55))
- Add option to build only the rootfs ([ffc760a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ffc760a0dab5f4960158b6afed6f81a1ea8d0ba8))
- Add support for the Radxa Zero 3 ([0350aba](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0350abab5a245fcc614608a5b8302ab63a1f3616))
- Add the mixtile core 3588e to mainline linux ([472924f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/472924fee8d1525253e7994e7077dbebe67d3bc9))
- Create scripts dir to fix build error ([df49121](https://github.com/gjrtimmer/ubuntu-rockchip/commit/df491217268f3971d82d0a65f06c90c72e035eda))
- Add config image hook to better handle board specific changes ([9d811ce](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9d811ce9af3ff5a9707969a163ab42951c093a4a))
- Add config files to handle multiple kernels ([888f517](https://github.com/gjrtimmer/ubuntu-rockchip/commit/888f517c7fb7ecf0cfcfa6725591d2fbd636cc5f))

### 🐛 Bug Fixes

- Fix overlay prefix for the orangepi 3b ([ff03e48](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ff03e480cc1d5632ca1fa2844905cfe275bf2809))
- Fix building rk3566 images ([69740a6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/69740a6e41254650afb11008b7d683f343f1ba8f))
- Fix radxa nx5 uboot rules target ([d06c2da](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d06c2da1131518f082bfd6a688b0f95a240d4b65))
- Fix missing script dir ([e1a3049](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e1a3049d29ac20221dfa9f115bb9a2dde76a19f1))
- Fix input workflow ([1898238](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1898238ad077b79a47d532891a7404620c10ddc5))

### 🗑️ Removed & Reverted

- Remove grub from ubuntu desktop ([d49c585](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d49c585d7e98d29589f71db31aea24d3bab8673c))
- Disable apport for both ubuntu server and desktop ([2d89cf4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2d89cf40d189031328a9d5a5bb13835207b30aa9))
- Disable apport for ubuntu desktop ([2d75f28](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2d75f28f8eb632230a0ec9f5d609b7733ad585bf))
- Remove zz-all-wl from network config ([2e2a8ea](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2e2a8ea58a08a5b4dc162081c034acce311b4605))
- Remove path that no longer exists ([7d7f53c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7d7f53cc636615f344cbeda3f224a285cf22e1cf))
- Remove swapfile from fstab ([f138cc9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f138cc97b651ea1b9173033964060b3ff30137f9))
- Remove if statement for oem config ([de020ef](https://github.com/gjrtimmer/ubuntu-rockchip/commit/de020ef4aa87b31d3c195884290850e6dbc92dce))
- Remove mainline matrix workflow ([0a10d63](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0a10d631afbb0847103a67820f0dec2cbe2817c5))
- Remove chroot dir after it's compressed ([cdd8355](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cdd8355b7a54b22927f7569ada67fb0bdb38242b))

### ◀️ Reverts

- Revert kernel to rkr6 ([2d2a90e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2d2a90e186ec9275310a28ae603467496c36d58b))

### ❓ Other

- Include rk3566 spl and ddr blob in debian package ([a5900ff](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a5900ff6711852e4dd99f52462b9b04f407cf5bc))
- Reduce raw disk image size by 1GB ([c9c3f3f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9c3f3fb193abd2bc521aed77cbf4811e5632ca2))
- Exclude radxa zero 3 from panfork ([b7a0204](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b7a0204e12d947223d332bb0ef0c82bf2837851e))
- Code cleanup and allow for mainline desktop builds ([20cc271](https://github.com/gjrtimmer/ubuntu-rockchip/commit/20cc27190193d7d28025d3f33e1e6e046f0a4d89))
- Build desktop with mainline linux ([cd3e8e2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cd3e8e24e6dfc95786dc5e83b3caa04b4365cca0))
- Let systemd resize the rootfs at boot ([2899516](https://github.com/gjrtimmer/ubuntu-rockchip/commit/289951603854ef64c950c82a986f9b1ea07427da))
- Compile kernel one time for build workflow ([759c3d7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/759c3d796ca1fdb2e967439e8276213ac08c4f69))

### 🚜 Refactor & Cleanup

- Use flash kernel again to manage the boot partition and firmware ([4394228](https://github.com/gjrtimmer/ubuntu-rockchip/commit/43942285f050445d47f7c649d706dc80b0d6a689))
- Change kernel branch to rkr6 ([ba3213e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ba3213e20859ff33d9e5a16ff6e042d4fa60889f))
- Use fat32 for boot partition and add build image hooks ([10888b3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/10888b3b9fde7770231dcf22654287ac8ac9412e))
- Upload rootfs as artifact for mainline workflow ([d25509b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d25509bfcb0bba53b72f4264337d0bc7f0148588))
- Rename image types ([75b2346](https://github.com/gjrtimmer/ubuntu-rockchip/commit/75b2346113a2a22470c395805b1e109b0e5188c1))
- Use v3 of upload artifact for mainline linux builds ([0c4d973](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0c4d97301e76a93b5edd4405d2ab6da037ecf7ab))
- Cleanup script to install the oem desktop ([ab32d73](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ab32d73b38fc8269aa70566ad5cca105f6078ab3))
- Rename kernel config dir ([9dcb5d6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9dcb5d6fab64fe75249dce6c96f5e8a749106c64))
- Cleanup mixtile blade3 u-boot ([584c435](https://github.com/gjrtimmer/ubuntu-rockchip/commit/584c4355e1e01d182ccc76f858849a2154dcaea0))
- Cleanup kernel build script ([6b3a9fa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b3a9fa20df3ae832ab40f445061eb84d7a2f2c6))

### ⬆️ Dependencies & Updates

- Update readme ([cbaa0c1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cbaa0c13cfebac7d3572ed11a75de2a5ce462b74))
- Update u-boot turing tarball script ([2e79722](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2e797225704417db19c141f8d04f797572681700))
- Bump radxa u-boot 2017.09 ([4714cb9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4714cb914a788cf61caaa0c881a3f77ae36060c7))
- Update ubuntu rockchip install to use fat32 format ([c3e7dcb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c3e7dcb549cbd505937063dfd76fae0bb3d1bace))
- Bump u-boot for the turing rk1 ([ff8fb45](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ff8fb45ca2dc6ff258d1cf626aeca7ccbd2da18f))
- Update default cloud-init network config to accept all eth and en interfaces ([3fb6bc3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3fb6bc3944136aed4a24751234a44939ccfa068f))
- Update ddr and spl for the radxa zero 3 ([0b4600c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0b4600c077804bb01034e5cbcd636d70a27541bf))
- Bump kernel for radxa zero3 test ([48867e0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/48867e084c7ca0d4de1a2af3a959c5b31ebf7269))
- Bump mainline linux to 6.7.0 ([2063b14](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2063b1488d5b95acc805e55577f1b30e563a6244))
- Update kernel package name for tc build ([907f4ca](https://github.com/gjrtimmer/ubuntu-rockchip/commit/907f4ca546a225f2184e401e4e3dd8fa75213cff))
- Update upload artifacts to v4 ([e719774](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e719774c6c9af035b6c0ae8813af86cb042a941c))

### 🧪 Testing

- Test with the new rk7.1 bsp kernel ([d1237f9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1237f9870e02205e87d7ecc25c330a25e281476))

### ⚙️ CI & Build

- Build rootfs in diffrent job for build workflow ([ab8a5ad](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ab8a5adad6ac00a5772ea4f970c15ecd4cb693f4))

## [1.32] - 2023-12-29

### ⛰️ Features

- Add hdmi audio rule for the mixtile core3588e ([d9d0869](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d9d086970ee18f25a1dea33ccb1f6841822f6cc2))
- Add BOARD_MAKER to board configs ([947d4dc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/947d4dc8d22b6206f73cd02f9c0c878287254fc9))
- Add pkg param to u-boot radxa makefile targets ([87371b2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/87371b263d5b205b34d067029899fbcee435a307))
- Add a config file for each supported board ([ab003ee](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ab003ee2645f66926481db5357d9502ea7c6a10b))
- Add the Mixtile Core 3588E to mainline U-Boot ([42858c1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/42858c15d530a1fde0a08be7739643861c9924fc))
- Add the mixtile core3588e to build target ([3c91255](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3c9125597bffb4ff53c5defaf0406a7b93a8dac1))
- Add the radxa nx5 and rock 5 itx to build workflow ([c9e18e2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9e18e28291845ee47db1ae695427157a8586a42))
- Add patch so the emmc is not skipped when sd card is inserted for opi5 ([da633a1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/da633a1cff190a69b759c9723862098820b4e1a3))
- Enable sata boot for the rock 5 itx ([4182d6e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4182d6ecf9c66c6265e0904e027285d8834b8cb4))
- Add the Rock 5 ITX and Radxa NX5 IO to build target ([44c6f7e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/44c6f7eb6522cfc644b77b302df2e7c5ef8b3b1d))
- Add U-Boot for the Rock 5 ITX and Radxa NX5 IO ([ed4a386](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ed4a386752436bce534cb0e4178e804c21a47c77))

### 🐛 Bug Fixes

- Fix device tree typo for the opi5+ ([fe395fc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fe395fcd2b58287bc95e2ffa52269877b78f6779))
- Fix changelog ([902e2c0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/902e2c0d5cb8e365af8182bb1bf46ca37a9618bb))
- Fix loader mode on mixtile core 3588e ([63e9b22](https://github.com/gjrtimmer/ubuntu-rockchip/commit/63e9b22cb38a2a4da69e2b064921fd0fa044a9b6))
- Fix mixtile core3588e ethernet in u-boot ([4998b10](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4998b1000fc6ef4249311bb931077516c8d8ea55))

### 🗑️ Removed & Reverted

- Remove emmc skip patch for opi5 ([26edc06](https://github.com/gjrtimmer/ubuntu-rockchip/commit/26edc06ebe2870385bfb38233938383f5348f583))
- Remove u-boot firefly ([4406f69](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4406f6958667eb6c14fddf8ca7a7a6a41f80cc09))
- Remove armsom u-boot package ([2527f33](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2527f330d9448444a307637e98060d7a15f7544e))
- Remove 9tripod u-boot package ([085aba6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/085aba67356f66c1f3ae7036ba4f92d638a30323))
- Remove lubancat and friendlyelec u-boot packages ([91db36e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/91db36e633a23e29055ddf7086534dbae03f22e2))
- Disable pcie3x2 to prevent boot hang on the  rock 5 itx ([fec1dd7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fec1dd79e7a3000d09dbd508bba95bd4dc41d78b))
- Revert "bump bl31 and ddr blobs for the opi5" ([51be35a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/51be35a378b374b0ea2f56c65222adb79f214c93))

### ❓ Other

- Reuse kernel build for mainline linux ([68b69da](https://github.com/gjrtimmer/ubuntu-rockchip/commit/68b69da509d8bd2362915e537283ee8beb43bb8f))
- Modify vendor for lubancat and friendlyelec ([814b0dd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/814b0dd1a59aa155b104f6bedec6d7bf43a9e6fb))
- Added new board adaptation: armsom-sige7 ([073133f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/073133f3141e0fe92b64c6ce1625c98c5d064363))
- Restore build-kernel.sh ([369f180](https://github.com/gjrtimmer/ubuntu-rockchip/commit/369f180b22c0471d795cd365ad024ea8b255bec7))
- Added new board adaptation: armsom-w3 ([47f9095](https://github.com/gjrtimmer/ubuntu-rockchip/commit/47f90951b73c671bdc98c54ab3f57db65edead77))
- Sort supported boards ([c1292e1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c1292e198980b77cb806a037de932ce6446e9044))

### 🚜 Refactor & Cleanup

- Cleanup turing u-boot package and prep for release ([38f987e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/38f987ec85bc28579f1221dbdd3f7cb9eb7c74e1))
- Cleanup orangepi u-boot packaging ([cc3eea7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cc3eea7336b3f45724ebf1ebb51cb74e66bf747e))
- Cleanup build.sh with comments ([f5473d4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f5473d4b4bf852512c8ba04e2c10eab6c78e6d91))
- Rename vendor to uboot package ([502fee3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/502fee3a3550ddb01862cf1acdef617e19fa2c60))
- Move mixtile core3588e u-boot to radxa package ([837215f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/837215f1a6e5426639c9dac9f99eba73ab0472d2))
- Refactor mixtile u-boot and add core 3588e ([c669655](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c6696553a0680ef0113ffb266070769529bfe073))
- Upload server and desktop image in one artifact ([2422505](https://github.com/gjrtimmer/ubuntu-rockchip/commit/24225051bff915dc4e1ab59653aa5587c7438673))

### ⬆️ Dependencies & Updates

- Update supported board list ([675f07d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/675f07de375b70d4a80d1b521ff10285a880f38d))
- Update orangepi u-boot changelog ([be22360](https://github.com/gjrtimmer/ubuntu-rockchip/commit/be223602ba31c6fbaae0efc4cf543701811e8bfe))
- Bump mixtile u-boot package ([42af912](https://github.com/gjrtimmer/ubuntu-rockchip/commit/42af912807282f9d340dc166ceeb83ab77cea668))
- Update armsom u-boot changelog ([4cbb164](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4cbb164944368d249e64a51ff75eb29c9cc2e861))
- Update build workflows ([ed145c9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ed145c92978c7d6bc5c246a357ce6546e2ca1005))
- Update readme with supported boards ([060760b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/060760be68bd7689d6e410a84c67949176207a44))
- Update u-boot radxa changlog ([753856e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/753856e5b9675be7bfcf7b4ef13c1cac1613964a))
- Bump bl31 and ddr blobs for the opi5 ([b3a6c7a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b3a6c7a3b5bb45544e476595edec893acb34b3b6))

## [1.31] - 2023-12-05

### ⛰️ Features

- Add roc-rk3588s-pc to readme ([e1047dd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e1047dda712c9373908aae3988e7ec7321b5d3e1))
- Add overlay prefix for roc-rk3588s-pc ([70aa301](https://github.com/gjrtimmer/ubuntu-rockchip/commit/70aa3013b497807fb87412b1d3f302db96b0a3e9))
- Add roc-rk3588s-pc to the release workflow ([ce956d3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ce956d33a9806a9f804d3508b8fe0e64f1406d3c))
- Add release build workflow ([aa29e6a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aa29e6a9205301949a399eba42857eb6c07a7467))
- Add roc-rk3588s-pc support ([7fea888](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7fea888ade5ca3267c5f1e720252da3b0d733106))
- Add debhelper as docker build dependencies ([91701a1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/91701a1a880a801ef529d4b5c421cf0d7e123bed))
- Add display port 0 audio udev rule for the turing rk1 ([dc2b1a4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dc2b1a4b85f0b6c701e18e55522a1668aafc6c35))

### 🐛 Bug Fixes

- Fix asset upload ([5807992](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5807992b26fb5f87ee8ce2944ed60dcda1e5c429))
- Fix permission errors ([b395bbb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b395bbb6537306ed172632de615f0d99e6a545b1))
- Fix ubuntuEnv.txt load address ([b0dbf60](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b0dbf602e3a616c40ea7765dc30fbfeb50b30eb2))
- Fix dtbs path when config image ([8c30a48](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8c30a489d6db22d9969cad71f65cdc74d1cedb0b))
- Fix partition char hardcode ([1d2dac7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1d2dac74ee7fb3abf53e342f5ca4e16c2386b8db))

### 🗑️ Removed & Reverted

- Remove flash-kernel dependency to update the boot partition ([845beaf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/845beaf08ee10eca0049a06c65d745164d9e00ea))
- Revert "reuse kernel build for mainline linux" ([cae52c3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cae52c3788ab2a950c9d076b01ba00c8f241f4c2))

### ◀️ Reverts

- Revert kernel branch to 5.10 rkr6 ([929a584](https://github.com/gjrtimmer/ubuntu-rockchip/commit/929a584f8b81036b7ec61e5d84cdce27fed12b69))
- Revert kernel branch ([d1a1466](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1a1466a71fe69b039e88cb85d793ed22159e22a))

### ❓ Other

- Place package hold on u-boot and kernel packages when not using launchpad ([4b5a9fe](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4b5a9fe5c03b4829b865345d436c9deea7bde50c))
- Dont use flash-kernel package from my rockchip ppa ([d455d51](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d455d51c64e7d1bd07117bad5eeff52956633cc0))
- Mention SSH in README ([800ea52](https://github.com/gjrtimmer/ubuntu-rockchip/commit/800ea5239c317c98aeb7c68369d649b746e5b089))
- Reuse kernel build for mainline linux ([768b459](https://github.com/gjrtimmer/ubuntu-rockchip/commit/768b459b1f908a987a3ea4f4427a51eb0de025d6))

### 🚜 Refactor & Cleanup

- Cleanup u-boot script changes ([b40986b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b40986b29bf545f6865f93633567c7ac5b9b3891))
- Cleanup release workflow ([4bd6dc4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4bd6dc4045f29e1ec96dfceb6459c33edd7b3a5e))
- Use upload url for asset upload ([be7fc8d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/be7fc8dcf26d971232c7f22b322a6879ba062c07))
- Cleanup release action ([d66df3c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d66df3c1fa71cd390b90b3e8a26b73a12b473a01))
- Rename release workflow and include desktop images ([44b39e7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/44b39e7f4dc7108b104e2ba93f9d5c5c03ce65ce))
- Use for loop to load device tree overlays ([65770bb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/65770bb4b45e118e3442a300d444e9f82eba2210))
- Use fat32 filesystem for the boot partition ([bff884a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bff884ac0aadf894e5f45e7775ebe50275061df3))

### ⬆️ Dependencies & Updates

- Bump release tag ([b0c3761](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b0c376105e89dd21c3d195b9479f4025f72ce3bb))
- Bump mainline linux to 6.7.0-rc4 ([070202a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/070202ab5b8028d07af42fe5d61661108d4db7b8))
- Bump kernel branch to test rk1 rtc bugfix ([acda1e5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/acda1e59b985992551022e30074aa883dffaeac1))
- Bump mainline linux to 6.7.0-rc3 ([389b65f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/389b65fbc6bcaeb992a6bade7838019e9a499c14))
- Bump kernel branch for rk1 dsi testing ([d8a29e3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d8a29e3322326317586eefea89555efec9ee26c6))
- Bump mainline linux to 6.7.0-rc2 ([8a173a5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8a173a53774bb9b36e098631cc74ed34b1e754e6))

### 🧪 Testing

- Test artifact upload on release ([dafac95](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dafac95b444ae2cfe8039925155c8bb35027ac0a))
- Test workflow release again ([3b12316](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3b12316eaaa4ca2baddd565b5de436f3771eba46))
- Test release with only server images ([115cf7a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/115cf7ac8b2cdee1762f08464e1572fa7fcac1da))
- Test rk1 with dp patch ([d1061e4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1061e4aa045d57c8c5a22431dadfc2584658b00))

### ⚙️ CI & Build

- Build kernel without setting the board type ([4ad26ce](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4ad26cefebaf2d1887c91a42e9410106ea0fbe4f))

## [1.30] - 2023-11-15

### ⛰️ Features

- Create machine id on boot when use ubuntu-rockchip-install ([1052b32](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1052b32975deda63d1bd3c690242b3b7376b8cae))
- Add missing kbuild image ([5fb6f5c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5fb6f5c3b4bc4f67edfca8586d607b0c141291c6))
- Add rockchip prefix to kernel release on mainline ([55264b7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/55264b7f1d49ca1b59bc4fd77c23ab06df50d7df))

### 🐛 Bug Fixes

- Fix HS400 in linux userspace for the Turing RK1 ([3002667](https://github.com/gjrtimmer/ubuntu-rockchip/commit/30026670b60321e755931c5f9f0970191dd416d3))

### 🗑️ Removed & Reverted

- Remove kdeb pkgversion ([7bc5e12](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7bc5e12c3d54ea565eb3768a45c8150837f9b042))

### ❓ Other

- Ensure boot partition is mounted before install ([cbf7f01](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cbf7f0149e732d6602937ad509d8a87a21e0e6d1))
- Migrate to rockchip-firmware and linux-firmware ([0769c84](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0769c84b2735b89e67e6b4226d6657eeceafc40f))
- Turing rk1 emmc hotfix ([20d38dc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/20d38dc0256d7f27552e8f67142d8660e979269e))

### ⬆️ Dependencies & Updates

- Bump mainline linux to 6.7.0-rc1 ([4859911](https://github.com/gjrtimmer/ubuntu-rockchip/commit/48599113daac46d3e8275f1b0f043e18c281fec6))
- Update u-boot changelog for the Turing RK1 ([020891a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/020891a345f288a6ca3fababd0b8661d62801ff9))
- Bump kernel branch ([da8b581](https://github.com/gjrtimmer/ubuntu-rockchip/commit/da8b5810753a7278977d28572de677290557b4f7))
- Update kdeb pkgversion for mainline ([c84c0d5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c84c0d5fafce5cbb502c6523160ae38db1c4ccda))

## [1.29.1] - 2023-10-30

### ⬆️ Dependencies & Updates

- Bump mainline linux to 6.6.0 ([c285999](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c28599977482b715e5c25cd38d6def4085884c8c))

## [1.29] - 2023-10-29

### ⛰️ Features

- Add rsync package ([40daaa6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/40daaa65f6bbba36ce0de6333d59187da8970d2c))
- Add u-boot install scripts ([1f7a5e8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1f7a5e8d464cf85b6b39228b6f361431a9e83a14))
- Add audio naming udev rule for the Turing RK1 ([985c165](https://github.com/gjrtimmer/ubuntu-rockchip/commit/985c165eac505b3eee6eeca4e045dfb2a1018897))
- Add ubuntu-rockchip-install util ([dac318e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dac318e31cdc9405e9ceeacb74f70ce79f71c543))

### 🐛 Bug Fixes

- Fix no upstream tarball error ([a5dacf0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a5dacf0134015345de462fb7bd3a905a2efa6dfc))
- Fix UART9 on mainline linux for the Turing RK1 ([26154b2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/26154b2c93cbf987008ff2f0f7ccd178b15e7858))

### 🗑️ Removed & Reverted

- Revert "do not set cpu or gpu governor to performance on boot" ([4feb2bc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4feb2bca0ada401153106615eb5f8ce3398c1452))
- Revert "mask daily apt upgrade to prevent boot hang without ethernet" ([61f65a2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/61f65a205d420ac325259be12607117f44d2a57b))

### ❓ Other

- Have governer scripts return true always ([ef6970c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ef6970c091f095f9a9036e789ddf1869aeb9adc0))
- Supress fdisk warnings ([4d79ea3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4d79ea38b1c1b718a78668193819c28f6ccc1758))
- Rebuild Turing RK1 u-boot on launchpad ([41288b5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/41288b58824bc4ee2293ed18145b162e7a180a0a))
- Try to read the partition table again before mounting ([808fd8e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/808fd8e7ef972434c15d250071c92ad38669d05c))
- Copy sparse files with rsync ([c372d1c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c372d1cca5fc3cc2eba47d6c0282da1f86d13e29))

### 🚜 Refactor & Cleanup

- Use the new linux-rockchip-5.10 meta package to install the bsp kernel ([5cc7051](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5cc70510c99fb65b0ec1fbf629cbb4138354dd81))
- Improve ubuntu-rockchip-install script ([ee08275](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ee08275777b1811810f5ccd3be22085c3a83771e))
- Move u-boot install dir for the Turing RK1 ([a578b14](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a578b14d6ba4f1fb5b88dfc88bac62224929db3b))
- Cleanup ubuntu-rockchip-install script ([c0963af](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c0963af375283d4346208024c676962acc4a029e))
- Cleanup Turing RK1 u-boot patch ([ef2e757](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ef2e757c06546c6a7b243f8119a23cf1dddbec47))

### ⬆️ Dependencies & Updates

- Update kernel cmdline for mainline linux ([18782f1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/18782f1bd6242b9c46240225dfefed481da1fc98))
- Bump the Turing RK1 to U-Boot v2024.01-rc1 ([522b543](https://github.com/gjrtimmer/ubuntu-rockchip/commit/522b54337476f8d95adb8cd37cb87bd5902dd7bf))
- Bump mainline kernel version to 6.6.0-rc7 ([223ff6b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/223ff6b8450569d56bec763c488ba08f7a35ad37))
- Update scripts to respect new u-boot path ([ef63ea9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ef63ea99b9458f7891459d60091422a1a3a7422a))
- Update u-boot install path ([2b61510](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2b615104f2ba664b19a1740c10170635fea151ce))
- Bump mainline linux to 6.6.0-rc6 ([ed077af](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ed077af187f3fc3de36fc2c6f6f0a7b3e2bfd731))

## [1.28] - 2023-10-15

### ⛰️ Features

- Add console on UART9 for the Turing RK1 ([2a10b28](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2a10b28e3f30387b3463ab5e28695cc74a76dc14))
- Enable USB and SATA boot for the Turing RK1 ([733a12e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/733a12e598942ccfa3f1dff15e3b3a51aeb3cd93))
- Add nvme boot support for the Mixtile Blade 3 ([21e05a6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/21e05a637047d63c38c0805307fb795f4cfb4b6e))
- Add uuid-runtime package to rootfs ([ef4e13e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ef4e13e2cd695201c5edbdcc075f0ad06dfba928))
- Add missing env vars for building with docker #407 ([e51b829](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e51b829d56a4fd1890b010089b2daf42e19c3882))
- Add more dependencies required to build u-boot v2023.10 ([3c029c8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3c029c8a384a94ce64d6b33324b9a7db6ae9cd3a))
- Add python3-setuptools to package dependencies ([4bc01b7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4bc01b764270a57083ac14b95d56fcbea088a88f))
- Add python3-pyelftools to package dependencies ([dfbcc2d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dfbcc2d9ce1c55df7a89cf8693abf92fab16276b))
- Add NVMe boot support for the Turing RK1 ([da7667f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/da7667f4e0d70ee57f747d3820d846a599d006d7))
- Add Turing RK1 to mainline build workflow ([afb45e4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/afb45e4b0b3a822b69191a4057df52ae01aa3847))
- Add u-boot device tree for the Turing RK1 ([1f47997](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1f47997c00c7679031d7d715781582e7bf2f2309))
- Add Turing RK1 to readme ([cf31025](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cf3102592bb7c6c6f73a456bbf1139ec8c00136b))
- Add kernel version to mainline image names ([b951722](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b951722ef6db6ede0c0afdb282c871b4ef3be1d8))
- Add rtl8852be workaround for opi5+ #378 ([c0b6e7b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c0b6e7bdc77ed3d2935ad09b0f0bc3dc2c68133d))
- Add kernel version in artifact name for mainline workflow ([ae749b9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ae749b9492f9aadce4e97c2b4b1b9f519de66f4e))
- Enable ap6275p bluetooth only for the orange pi 5 ([6f91889](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6f918896185aaf906f0cd65b785e3c9f64d6391f))

### 🐛 Bug Fixes

- Fix u-boot issues for the Turing RK1 ([a2eb475](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a2eb4756af83f10cbd716feeccbe7b3bd242dd44))
- Fix mouse lag / stutter in wayland sessions ([c9cdd39](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9cdd3969d04e20ade0bc08e7d637e16fa3d3695))
- Fix u-boot control info for Turing RK1 ([b9da72a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b9da72a3dfb8eac8c0e4e450d80bcbc70ae61c56))
- Fix kernel build error #396 ([8766805](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8766805e5715792d04b99c612ba6a50b48d0eec4))
- Workaround for 120 second timeout bug with ubuntu server #366 ([cc61102](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cc611028546903e1a7e2604474d95205a0abaff4))
- Fix mainline kernel not building in workflow ([0da6650](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0da6650c90b8745fe07bea2e5a041a5d6b1c4c01))

### 🗑️ Removed & Reverted

- Disable NVMe boot for the Turing RK1 ([00d5bda](https://github.com/gjrtimmer/ubuntu-rockchip/commit/00d5bdaeb1f96a035abc2b1a38fb14b3b9590ae7))
- Remove leftover cogl, gst, and qt environment variables ([1b09f9c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1b09f9c6aaeaebe115a13d3973dcb79860045b9f))
- Disable ubuntu terminal ads ([b2d7171](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b2d7171c57ffbff5c691a330f9577221af3f4ea7))
- Revert "override default link-local address for cloud-init" ([db71786](https://github.com/gjrtimmer/ubuntu-rockchip/commit/db71786a77bde6fa6e7f651b7f78067e3a5d03ba))
- Disable ap6275 bluetooth on mainline ([33d9a81](https://github.com/gjrtimmer/ubuntu-rockchip/commit/33d9a811206f93ef109bee8bff0c738b794f1f57))
- Revert "use linux-firmware package for mainline images" ([3e9c75e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3e9c75ef745afc576b57f767bf2caa1ac5f1ab9e))

### ◀️ Reverts

- Revert to rkr5.1 for now ([e3d87be](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e3d87be7df625b0686bab411b3e1c849363d5ad5))

### ❓ Other

- Adjust Turing RK1 boot targets ([fe9d21a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fe9d21a7070c49573e85b72e1ca4b79ff329c551))
- Mask daily apt upgrade to prevent boot hang without ethernet ([a0a2611](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a0a261105c66d7e7557b087680ff3a9cf3fac5b5))
- More Turing RK1 fixups ([bbb6727](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bbb67277de0c0ad59ba1cbb14b9dea175f02c8bc))
- Do not set cpu or gpu governor to performance on boot ([5f8dfff](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5f8dfff5b1be1a1a3d56a6d012d68b20a7a090a0))
- Only boot from emmc for Turing RK1 ([7ba0603](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7ba0603613abc536a8d9e4f5dfe89695b83174d0))
- Override default link-local address for cloud-init ([4d0d23c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4d0d23caf6a22498aab653c6c85aabbcd4fa68bf))
- Clean package cache before making disk image ([8b3b2d5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8b3b2d599a6ef77ae5b9f979b26b148148430ad0))
- Clean cache after worflow build ([b8b50f2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b8b50f2323184ad305616c15091b0855830aad1b))

### 🚜 Refactor & Cleanup

- Set rkmpp as hwdec for mpv ([8b78ab4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8b78ab45e10ae95586802a96dfe7674cdb74d8a6))
- Use UART9 with 115200 baudrate for the Turing RK1 ([f10b2e1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f10b2e1371dec179840735a00b3a5ac17953c4fb))
- Rename opi5+ rtl8852be service ([2402f78](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2402f788484be704a06f27c6bf78ebdafc9c383e))
- Improve build workflow ([8ba4ae6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8ba4ae6b872a62e305c68ccf6e0fa26276afd4ec))
- Use linux-firmware package for mainline images ([06eed4a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/06eed4a7f64455694e7043d83463ca96874d6569))
- Use linux-firmware package for mainline images ([d52dfe8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d52dfe8c658a69d7ff160e257278a4fffee50a54))

### ⬆️ Dependencies & Updates

- Update DDR blob to use UART9 for the Turing RK1 ([a599fb0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a599fb068ee284e38011319e6ddbb059de15f283))
- Update user-data config for cloud-init ([d88db07](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d88db07c3f5e20d70de6ebdf0d41550acd277c0c))
- Update meta-data and and network-config for cloud-init ([465dc5f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/465dc5f21b1a9fbd579266b3aa8525a36638764b))
- Update readme ([3396ef8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3396ef8515f6087f78bc3d6958f56c9bb71b2bd1))
- Bump the Turing RK1 to U-Boot v2023.10 ([967c4f8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/967c4f88703946d2c7ad51e84a24f13c4f82d86c))
- Bump mainline linux to 6.6.0-rc5 ([04dfc4e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/04dfc4e791255ba33be3a5ee8bb4fc070cbf6c0f))
- Bump vendor kernel to linux-5.10-gen-rkr6 ([8334724](https://github.com/gjrtimmer/ubuntu-rockchip/commit/83347247cfcc3b5cf7b7c4e44d4bf7a41e0ef435))
- Bump kernel branch for Turing RK1 testing ([d4ad8c4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d4ad8c449f98564a04ddb910845f1f3ed846c4df))
- Bump mainline to 6.6.0-rc4 ([bc3d04c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bc3d04c4850b1c1f21ca6fb0babddd47310adcdc))
- Update kernel release string ([207e371](https://github.com/gjrtimmer/ubuntu-rockchip/commit/207e371afb577368eff8716842a7749e12d60b96))
- Update kbuild image for mainline kernel ([34a50ba](https://github.com/gjrtimmer/ubuntu-rockchip/commit/34a50baad23b4450105a27708218f00cfc409fa4))
- Update mainline workflow run name ([4afe399](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4afe399a812904b88a30c8fd11b8a5dd07aea49e))
- Bump mainline kernel to 6.6-rc3 ([16d9aa6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/16d9aa61f04fcc6f9e53515122d9ccaeee3b0ee5))
- Update run-name for build workflow ([85efe2a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/85efe2a6b84631c3fad9584b0ebab1321fced3e6))
- Update run-name workflow text ([42dd33e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/42dd33e6ae70393bd41f46de8deca2648ebe7505))
- Update mixtile u-boot package ([6ad400a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6ad400a94a9a3a571ab0bcf893d9d2f95b3b5fb8))
- Update radxa u-boot package ([486d9fe](https://github.com/gjrtimmer/ubuntu-rockchip/commit/486d9fe0596a422e3ca306172e9955736099fad6))

### 🧪 Testing

- Test with rkr6 bsp kernel ([eff08c7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eff08c782b741028f577ca7f7c7cfabdab31a627))

## [1.27] - 2023-09-15

### ⛰️ Features

- Add debhelper package to workflow dependencies ([b967c0d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b967c0d131095f62a7f23488b0b24f77f2d989a9))
- Add workflow to build mainline images ([4342e3b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4342e3be1526304b27dfa6db8a118f92d18d55c4))
- Add workflow to build all images ([63311e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/63311e680ab2a0db2f968cd91b9c63f6b8d1931d))

### 🐛 Bug Fixes

- Fix launchpad workflow ([aed3cce](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aed3cce12436be733c4867bf1a745445c46bcd2e))
- Fix building with launchpad ([965aee7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/965aee799993ad6276c60635abb609ee0e066912))
- Fix launchpad workflow ([61115a3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/61115a3ce709b99748f7270cbe422f94b452c34c))
- Fix mainline build workflow ([9302acb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9302acb5e6a44658bc0c8ec21dc14e1cdeaf1efa))
- Fix nanopi r6 audio rule ([c2ef13e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c2ef13ebc67028280449517347a66358e7edec74))

### 🗑️ Removed & Reverted

- Revert "fix building with launchpad" ([78c2697](https://github.com/gjrtimmer/ubuntu-rockchip/commit/78c26974862ca41d51dcc77581161b2882af8d37))
- Revert "replace y/n with true/false for optional arguments" ([1bdf35b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1bdf35bd14538caad6b1bd52abb9ae178483ed44))
- Remove mainline matrix ([9e46445](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9e46445d10e7b33a5b15d6057b8c5a1f0306e2d8))

### ❓ Other

- Replace y/n with true/false for optional arguments ([7abe55d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7abe55d732cf029af924da65c956fc455d2ed7af))
- Split kernel and image workflow for mainline ([00352a1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/00352a1f57e69fd599b37314116ebf06fe71eef8))

### 🚜 Refactor & Cleanup

- Use args for launchpad param ([43f36fe](https://github.com/gjrtimmer/ubuntu-rockchip/commit/43f36fea72e0fae0de451bd22c4b25eaa6ac21d8))
- Improve mainline build workflow ([31bcd47](https://github.com/gjrtimmer/ubuntu-rockchip/commit/31bcd478258e4c58dd27ba770a5a16e355df7ebc))
- Cleanup build workflow ([654ead6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/654ead6467fe2e830b7f9db87ec580f4d306bd52))
- Improve build workflow ([f920489](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f92048915659fcf2a3dca84dcb72e793c8ddaaf7))
- Upload desktop and server artifacts separately for mainline workflow ([eb2ecdb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eb2ecdb206c4d471bdd217928bb52d9301ea04e2))
- Upload desktop and server artifacts separately ([15c92e8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/15c92e8250b596f6d5dd3a936590773f10865765))

### ⬆️ Dependencies & Updates

- Update github actions script ([060c213](https://github.com/gjrtimmer/ubuntu-rockchip/commit/060c2133469a086a29c7b92eb329a9ba4687ce87))
- Update rockchip camera engine ([ca9e23c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ca9e23cbc6ad6676a81c62f24af0dc733bdd7307))
- Update camera engine rkaiq to 1.0.3 ([56f03e3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/56f03e3f1c4735d93b882b06ab4c51480288456e))

## [1.26] - 2023-09-10

### ⛰️ Features

- Add kernel release to mainline make command ([9a14056](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9a14056962f9f7158ebb869b97889e8b14d02344))
- Add github build action ([a8e69c9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a8e69c98d76cbf77890a0e1afc94e0cb6ea8ad3b))

### 🐛 Bug Fixes

- Fix workflow error ([69c2efa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/69c2efa77b76c463c10726fe632f27cf64876b39))

### 🗑️ Removed & Reverted

- Disable ap6275p bluetooth service on mainline ([df76f91](https://github.com/gjrtimmer/ubuntu-rockchip/commit/df76f91e9219e9f3f385df8f7b9772d301fe57a0))
- Remove duplicate path in build workflow ([eba72e0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eba72e012ab2ce0928373406ce30c8d7cee40793))
- Remove rkaiq_3A_server binary ([7106331](https://github.com/gjrtimmer/ubuntu-rockchip/commit/710633116636686381563c425a7ae71f44faa2e7))

### ❓ Other

- Optimize image creation ([0762998](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0762998da60d2baf7660e34e07159d248f0eee91))
- Get more disk space with github action ([be6b7c4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/be6b7c41a1680799f67dddf35c92439e5c8866a3))
- Updated camera engine from rockchip ([ddd7759](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ddd7759f99a07763991063642838ac6a2cf1b767))

### 🚜 Refactor & Cleanup

- Cleanup github actions build script ([be0f79c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/be0f79c587dae15a10b6601d83a8d55b133eb269))
- Cleanup github build workflow ([53da77a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/53da77a8d9f806b800592b7e3c7f52ab1ad44fd4))
- Use wildcard for image upload ([d0ea84b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d0ea84b42aba7023eaa4c98343545c5150dad60b))
- Change mainline kernel defconfig and remove kdeb pkg version ([be09862](https://github.com/gjrtimmer/ubuntu-rockchip/commit/be0986283d85243e1a661faef59eac0701b60106))

### ⬆️ Dependencies & Updates

- Update build-image.yml ([b394917](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b3949175d52185793593dfa8003a37f56c686191))

## [1.25] - 2023-09-04

### ⛰️ Features

- Add alternative dts names for mainline linux ([bce68c6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bce68c6ea68f7d978e5b0d951eb6bdd32d0a13ef))

### 🐛 Bug Fixes

- Fix launchpad build error #344 ([e08ce61](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e08ce61b1f2a3b506580c90265791cb27131f5e0))
- Fix mainline dts typo for the mixtile blade 3 ([c290fdd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c290fdd1dd4065fb0df2c2e36fe4be8f8ae3b216))

### 🚜 Refactor & Cleanup

- Set kernel release and pkg version for mainline linux kernel compile ([0a6cd03](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0a6cd03e1ecda9fec546540ab38a2e8bf1aa522a))
- Cleanup device tree alternative names ([f8a885f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f8a885f954bf57e81e10ac09777329293a3e34ab))
- Use panfork only if not a mainline build ([185b045](https://github.com/gjrtimmer/ubuntu-rockchip/commit/185b0458af4adcdf925b51891797de1b5dcbd34e))
- Set version and scmversion before kernel compile ([87f9399](https://github.com/gjrtimmer/ubuntu-rockchip/commit/87f9399ac5165f9fbf46b0be4e04372334696b85))

## [1.24] - 2023-08-27

### ⛰️ Features

- Add naming audio rule for the indiedroid nova ([5a59cb5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5a59cb5986d684e36594f417c86c36e2e10ad0ff))
- Add spi bootloader image to lubancat4 u-boot package ([c6f6cfa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c6f6cfa5b7b858e18f17b1df09d7c340ca8f096c))
- Add lubancat-4 ([240da53](https://github.com/gjrtimmer/ubuntu-rockchip/commit/240da53c652a809ec37c7639cd565c85cfbeb003))
- Add parameter for mainline linux builds ([622a300](https://github.com/gjrtimmer/ubuntu-rockchip/commit/622a300962e834d60fb6cbe429a2f124ccf928dd))

### 🐛 Bug Fixes

- Fix typo in indiedroid nova naming audio rule ([f4e057b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f4e057b06e164dab34640e0c999691d490ca5e19))

### 🗑️ Removed & Reverted

- Remove hdmi audio as default sound device for the indiedroid nova ([488e8d9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/488e8d9109766f2056ea7436fab530eafac4a062))

### 🚜 Refactor & Cleanup

- Make scripts executable in lubancat u-boot package ([f77c9ed](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f77c9edf5da62299a5253e5bb283269b000baddc))
- Cleanup mainline kernel build script ([d74af36](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d74af3606604c0282501d4026daf6863cdfd14ca))

### ⬆️ Dependencies & Updates

- Bump mainline kernel to v6.5 ([7f262ef](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7f262efacdc07382945fcb0435004cedcaf93cf5))
- Update readme ([a23e03f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a23e03fae3026b405c245cca41a5527f1f41f7fb))
- Update lubancat u-boot changelog ([dc65e6a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dc65e6aaf358e17d42bf9775f342462bc25a8e4e))

## [1.23] - 2023-08-16

### ⛰️ Features

- Add commands to build only the desktop or server image ([b29741d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b29741d3def235ccd12597050ebc304499ac6641))
- Add kbuild image and disable iwldvm ([859d326](https://github.com/gjrtimmer/ubuntu-rockchip/commit/859d32628a71ddb30442f8113cf3e013c02641ba))
- Add build option to use a cached kernel deb package ([03eefa9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/03eefa975d0d512305473a8bb18a8989981ce97d))
- Add radxa ddr and bl31 blobs again ([7d164e0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7d164e0ca6b9a3baf42a74c319e1af3a81f5f4ef))

### 🗑️ Removed & Reverted

- Remove cached kernel param ([094a4cd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/094a4cd6f0827103e92fd1a641781231ec3d038e))
- Revert "update radxa ddr and bl31 blobs" ([5deb218](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5deb218f7aca51235ebf457bd395e59690948fca))

### ❓ Other

- Generate kernel module dependencies after install ([9609c1c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9609c1cd41223a239d869cfa981ab2825d49760f))
- Mainline 6.x kernel build test ([11deea4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/11deea4f27f046e3365cb65707bbbd26a761d830))

### 🚜 Refactor & Cleanup

- Improve dealing with diffrent named kernels ([a4306b3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a4306b3b8e32c02b3420ab218ebd992444626035))
- Use wildcard for kernel deb package ([6caae90](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6caae90caa2b95b56d3ab5d6f79580d4b38ffe7b))

### ⬆️ Dependencies & Updates

- Bump kernel to linux-5.10-gen-rkr5.1 ([b8aa93f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b8aa93f2cc4830d5d04e1b1c5a8c68e67967352b))
- Update mainline kernel branch name ([da7d4d7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/da7d4d70f11959b2391db627e7a36246fe9d5a92))
- Update radxa u-boot changelog ([69b673c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/69b673c2e425b000716840cb1db444834b59caf8))
- Update radxa u-boot changelog for blob revert ([3f18bc0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3f18bc004ac9072c090bce507597c523747fcdd0))
- Bump ubuntu version to 22.04.3 in image names ([94c5016](https://github.com/gjrtimmer/ubuntu-rockchip/commit/94c5016658281969b3aae529df5d3a53598efe89))

## [1.22] - 2023-08-10

### ⛰️ Features

- Add alsa audio config service to fix rock 5 audio issues #291 ([f24247d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f24247d25b555bea47056783011ca1342774cbf4))
- Add sata2 u-boot support for the blade3 ([ebace60](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ebace60bfbf929d3d33f04a623a3f1aadbf2fcaa))

### 🐛 Bug Fixes

- Fix patch file name in mixtile u-boot package ([0d0eaba](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0d0eaba3eaea64a558795057ed5fbb6255f4d17a))
- Fix typo in u-boot build script #289 ([6225efb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6225efb49f142f8ae895fb34c127c158d2382201))
- Fix broken path for blade3 u-boot ([d265471](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d2654714b8975d073823c686b33d60588e6472f5))

### 🗑️ Removed & Reverted

- Revert "test builds with the new rkr5.1 kernel" ([4121a3e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4121a3e1d779c8c5e28ae60b2a90ef992ffafa62))

### ❓ Other

- Rebase and cleanup blade3 u-boot patches ([aeb8b89](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aeb8b898c8d5f89e5bf55cb1723153fdfaabe985))

### 🚜 Refactor & Cleanup

- Cleanup stata2 support for blade3 u-boot ([89bc08f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/89bc08f10ce49beeb78434c3b96beb91be10892e))
- Rename u-boot packages ([a0721b5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a0721b5b4098c8d8d910821384befece1c4b9cd6))

### ⬆️ Dependencies & Updates

- Update include-binaries to reflect bl31 and ddr blob update ([8d5dee9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8d5dee9e3d277cd737424139f572337658f6a4d5))
- Update changelogs for u-boot packages ([d65e305](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d65e3057a6d7785d0b0c82d496d2e19b9b48b388))
- Update friendlyelec ddr and bl31 blobs ([0fa28b7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0fa28b7a7a9a99b1c0d9f79a732358a5164b4fd3))
- Update 9tripod ddr and bl31 blobs ([77369f9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/77369f95ea5277ba2c2bf6713c58351826f8de84))
- Update radxa ddr and bl31 blobs ([df5a595](https://github.com/gjrtimmer/ubuntu-rockchip/commit/df5a5950f77fc72b16e4a9b715dc0358620e0ee5))
- Update orangepi ddr and bl31 blobs ([a6a6b8e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a6a6b8e910de48ab91dda46e4079d492b4cee08b))

### 🧪 Testing

- Test builds with the new rkr5.1 kernel ([f19a397](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f19a397f825924352b761e2e01947b4f15ac835f))

## [1.21] - 2023-07-23

### ⛰️ Features

- Add cm5 io overlay prefix ([76bd228](https://github.com/gjrtimmer/ubuntu-rockchip/commit/76bd22839c5185df17f612da71f1d876c36bde4d))
- Add blade3 overlay prefix ([de9c6ab](https://github.com/gjrtimmer/ubuntu-rockchip/commit/de9c6aba192c7431f660874b7450f6578a9cd1fe))

### 🐛 Bug Fixes

- Fix gpio operation not permitted for wiringop #273 ([a3fbb96](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a3fbb96d5bb0c8de7b94fbb0c2dd0e7d6574ce88))
- Fix build logging ([65f7529](https://github.com/gjrtimmer/ubuntu-rockchip/commit/65f75296acc83b4922a07fb21434021cf3222d75))

### ◀️ Reverts

- Revert orangepi disable set local-mac-address #274 ([8949f12](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8949f12a2cf06d421c11ed2d201524d568c50caa))

### 📚 Documentation

- Docker container rename ([e06fce7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e06fce7d9224a93c11fe71cb99007ea57f89a38a))

### ⬆️ Dependencies & Updates

- Update readme ([91b30e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/91b30e6c24c23031bd6a3e08bbfae16f0e3ffafe))

## [1.20] - 2023-07-18

### ⛰️ Features

- Add mmc-utils package ([9aebaf8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9aebaf8c95842f6157b716b31279af9050c89590))
- Add blade3 and radxa cm5 io audio naming rules ([4def8c8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4def8c802c0e70251d6eafd9624a700beeef4c6e))
- Add radxa cm5 io board ([76b83b0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/76b83b0eaf1bd3412ae55364215a1ef1bd9d48f9))
- Add radxa cm5 io to u-boot package ([58c9aa5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/58c9aa55d8b20a4747f63586c493abb6cfc59c86))
- Add inital mixtile blade3 support ([89d26db](https://github.com/gjrtimmer/ubuntu-rockchip/commit/89d26dbc5f15891bcb7b687cc7238c4309c6789e))
- Add spi u-boot for the rock 5a ([9ea0765](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9ea076504c026383c1c9ddb58316452633e35db1))
- Add led service for the nanopi r6 ([0fca190](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0fca190115278948020b6cf57cba15e4b0a9de09))
- Add build logging ([db2d89e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/db2d89e7825393156e7c7e220cd6807f5991a7c0))

### 🐛 Bug Fixes

- Fix friendlyelec u-boot ([596ee5e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/596ee5e88f7e0a190b075b890f10b4e55a7bae91))
- Fix orangepi u-boot ([54e40d6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/54e40d6c57b674570c4d9e0f1ebd6162615b5e69))
- Fix radxa u-boot rules ([d6e2fa5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d6e2fa5bee16553a8d2db0f3258179959a37d6d0))
- Fix ethernet on mixtile blade3 server image ([a6e09ac](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a6e09ac70265ab945a453bc89d1ee44470548c50))
- Fix 9tripod u-boot rule ([3504672](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3504672e33aabf3b9bc198eecf96567dbda50580))
- Fix blade3 dtb and u-boot package name ([c084bc8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c084bc86f356876da70147e040e9c8746d87bd7e))
- Fix u-boot system path ([d29091a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d29091a6a51afa43ef9a2d5513f4bafe48967f69))
- Fix mixtile blade3 u-boot ([57abb64](https://github.com/gjrtimmer/ubuntu-rockchip/commit/57abb64ee4591180353b0614c4f9e376d77766b4))

### 🗑️ Removed & Reverted

- Remove unified u-boot for now ([c0b4bb8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c0b4bb826ec5874e9dde425d3c778466243911d6))
- Remove nanopi link in friendlyelec u-boot package ([b10bfda](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b10bfda31ed7b904ceecb482ece12de2ed24fb7b))
- Revert "revert radxa and friendlyelec ddr blob update"" ([c405bd0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c405bd00cb0af7d0a6552771169ae8381ea05ea6))
- Revert "revert radxa and friendlyelec ddr blob update" ([1c3efe7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1c3efe703b1801eb861f9a77947101e8f4a89fc4))
- Revert "use wip u-boot repo for mixtile" ([907b485](https://github.com/gjrtimmer/ubuntu-rockchip/commit/907b48557b4de5d653df7da14f9a9d042b27213a))
- Revert "update rockchip camera engine" ([0774fe3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0774fe30475fa4aa580ba0ae9a968f3d69f81f48))

### ◀️ Reverts

- Revert orangepi ddr blob update ([4f0a104](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4f0a10468233c890027f95719d3a8fe24da51b40))
- Revert radxa and friendlyelec ddr blob update ([88d6002](https://github.com/gjrtimmer/ubuntu-rockchip/commit/88d60027b7bc8bf92ff3909225de3b4d4ad53e56))
- Revert u-boot dir change ([bde8314](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bde83146b6bbe3d1ed8f7a1c2bfa90fb1d22bb8b))

### 🚜 Refactor & Cleanup

- Use radxa base for mixtile u-boot ([9bf6e71](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9bf6e710d95b77eccdc062b3fe54038ff7914600))
- Use older u-boot commit id for mextile ([35aa5c4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/35aa5c48630731ba79b07e93e382f69e6effff6b))
- Refactor indiedroid nova u-boot packaging ([c06b940](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c06b940805d9e51853accc05e23d3c31575d30bc))
- Refactor mixtile u-boot packaging ([61ec27c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/61ec27c786c5be6246acd8fd582f7994acc1d04b))
- Refactor orangepi u-boot packaging ([1213b38](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1213b3879b0ee67309c552c25abf13ed7703f1d2))
- Rename nanopi u-boot packge to friendlyelec ([9c43087](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9c43087e447692fc8aac7a71fe89709c21d6e296))
- Refactor radxa u-boot packaging ([2276d4c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2276d4c915173bf304ac3a540a316c7cebc2dc7b))
- Use wip u-boot repo for mixtile ([a3425c7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a3425c7b2368c1ee87f9b530d331701efd697ba6))
- Rename u-boot packages for rockchip testing ([50e1ab3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/50e1ab3f48da1b53034fbbff169b5ff56bc27044))
- Improve u-boot rockchip makefile rule ([66c802b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/66c802ba0117e93b127fc8b89e6c2a283ab26ccb))

### ⬆️ Dependencies & Updates

- Update 9tripod changelog ([c0a1926](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c0a1926479b21b4dedc871ef5c47d7a8011a90ea))
- Update readme ([680fc06](https://github.com/gjrtimmer/ubuntu-rockchip/commit/680fc0623f91d064560c4ab4838d7466ebf3a7f5))
- Update readme ([8ee0591](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8ee0591586061497dc9acf3fe12d5141632cafc9))
- Update ddr, bl31, and bl32 blobs for radxa and nanopi ([8fa2708](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8fa270874acfb7e3c4423c53fdbeae5ac6824176))
- Update rockchip camera engine ([6a8a28b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6a8a28b8a25041eb269b211be9da21155b5c7b17))
- Update readme ([4821da1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4821da1477606dee8f0f7c1c091ccd529ca6a88f))
- Update readme ([2a347c5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2a347c57b74ec153b49e10059c5b5a0e6469eece))
- Update readme ([c27b816](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c27b81606530f115cf743465c4ac6102cd6fee0e))

### 🧪 Testing

- Test new u-boot repo ([52c35c1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/52c35c181b0c51db039e0f3ab2a4b1fd84c49f1b))

## [1.19] - 2023-06-28

### ⛰️ Features

- Add missing vpcie3v3-supply node for nanopc t6 nvme boot ([67847d2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/67847d22c037c7636bea0b9c77f0045903b85a8a))
- Create rkspi loader for nanopc t6 ([fd7cf36](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fd7cf36f9965823b32c2247d2c362f7db6ebaa0b))
- Add nvme boot support for nanopct6 #223 ([57be032](https://github.com/gjrtimmer/ubuntu-rockchip/commit/57be032bad86a07a8beb848a5e4fc154e1cc4580))
- Add nvme boot support for the nanopi r6 ([13be86d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/13be86d86f0b94324cf94b4d8bfe31585a01d0a0))
- Add missing dp0 audio rule for nanopc t6 ([7e17a42](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7e17a42bb07b509caf46ac56271dcf48e4d3b4ee))

### 🐛 Bug Fixes

- Fix rock 5a audio rule ([a024cd5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a024cd542c28040f5f7a2c5f59ce1cff38ba1859))
- Fix nanopi r6 nvme boot ([a580458](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a580458f7bfcfb0dad2e6743d743f3cecdae2d25))
- Fix rock 5a audio rule ([35ba498](https://github.com/gjrtimmer/ubuntu-rockchip/commit/35ba4982279de03e0439dcc85c5d63b7cb96686a))
- Fix orangepi u-boot source epoch ([e3f7fde](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e3f7fde672d3466ccb79eec17ab155414acae7a0))

### ◀️ Reverts

- Revert "give sdcard higher boot priority than nvme for opi5" ([f887b18](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f887b18b0446e9bca9a1c82e0724014af4effeb6))
- Revert kernel branch for dev ([431362e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/431362e2ea15abdd8f35c8530c07e135d6153772))

### ❓ Other

- Give sdcard higher boot priority than nvme for opi5 ([8fb16a9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8fb16a966f89c4fd840ad753a5043eba4f8054df))

### ⬆️ Dependencies & Updates

- Update orangepi u-boot changelog ([fe1617a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fe1617a6226051f50291f2613e4524f071deb404))
- Update nanopi u-boot changelog ([2af288b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2af288b6f800adbbbd5b7b5b130812e747623775))
- Update nanopi u-boot changelog ([d8c98f8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d8c98f8df38db3fe29b9c42328b436585e7419aa))
- Update kernel branch for dev ([b13832e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b13832e3dded514164e697d8c99fa5783f862225))
- Update readme ([0402d3d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0402d3d53e96a2c14193263e66889815028c0f5d))

## [1.18] - 2023-06-14

### ⛰️ Features

- Add hdmiin audio naming audio rule for nanopc t6 ([ae621b4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ae621b47c0dd0e7b239ace6788e718e7f0c613cd))
- Add nanopc t6 support ([ddff5ac](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ddff5ac552717c12ceb99ce79561e7ca2f2ac11f))

### 🐛 Bug Fixes

- Fix opi5b config ([10e702a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/10e702a019d0255753fb6fd82b1cec4e68165838))

### ❓ Other

- 9tripod wifi and bt firmware moved to armbian firmware ([643f85f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/643f85f0c59b55268b8daa7512898c4b1e18aaa6))
- Reformat audio configs ([49f55d1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/49f55d1d381cce364042998f83fb46e56eaf6df8))

### ⬆️ Dependencies & Updates

- Update nanopi u-boot changelog ([9b5a952](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9b5a952401c8c6a4e9402ea7532c045ac9fa7f55))
- Update radxa u-boot and give sdcard higher boot priority #202 ([af8ad64](https://github.com/gjrtimmer/ubuntu-rockchip/commit/af8ad64a4da8d5301050a949acaa15b9982def2f))
- Update readme ([f9ec533](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f9ec5333ef8f14372d8716f19f8d7565d38195e5))

## [1.17] - 2023-06-07

### ⛰️ Features

- Add rk3588 overlay prefix ([56578ff](https://github.com/gjrtimmer/ubuntu-rockchip/commit/56578ff468f235a145a100e1e89866f6a4d5ce66))
- Add kernel driver patch for rtl88x2bu chipset ([7bb87c7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7bb87c76b0a538c7ddb3b7f3ff806ea641cfc59b))
- Add opi5 plus device tree kernel patch ([2259957](https://github.com/gjrtimmer/ubuntu-rockchip/commit/22599573ab9252f3b434742d743b820ad5545a81))

### 🐛 Bug Fixes

- Fix rkaiq install #187 ([5203545](https://github.com/gjrtimmer/ubuntu-rockchip/commit/520354562ebe70adb95977ae992624cf815cd1c2))
- Fix opi5plus sound and network-config ethernet ([235a713](https://github.com/gjrtimmer/ubuntu-rockchip/commit/235a7133cfd515c00739a84819812fb95c7824eb))
- Fix rootfs text in image name ([23fdda2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/23fdda2baf6a0f215d7669e53b5acf80c20be351))

### 🗑️ Removed & Reverted

- Remove kernel packaging ([20b2c11](https://github.com/gjrtimmer/ubuntu-rockchip/commit/20b2c11d359089f8b5534a13242489f30df890e1))
- Remove linux libc dev pin ([3650ad8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3650ad8c8be4ad602fd749f29152924cb1984028))
- Remove sdmmc and sdhci alias ([4154435](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4154435a8d86cab71b9e9a91ec59640f402164a2))

### ❓ Other

- Don't rebuild kernel if deb exists ([fa05847](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fa0584723a8884d02b8706d58d4473f6977f3621))

### 🚜 Refactor & Cleanup

- Change git clone line ([6f613cc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6f613cc60d3ed1bf7d5942f2a48d00cf9ebda036))
- Refactor kernel repo ([bcaf101](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bcaf1016b4cd375fad8382a61ec848f46270075f))
- Rename config script ([63a9535](https://github.com/gjrtimmer/ubuntu-rockchip/commit/63a9535ee60a21bc1a9ba40b353a870daebc5116))
- Use a rootfs cache to speed up building for multiple boards ([b4152ed](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b4152eda97ca298c79edd3f3595409c833aa1cb0))
- Make ceph friendly ([fdb3cf3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fdb3cf394a98ffe8779b1b3aff1d7ec915e18ad3))

### ⬆️ Dependencies & Updates

- Update readme ([e089a97](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e089a97d4bc6108d14d1dd9acb64078e8f534e0a))
- Update board if statements ([c200adf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c200adf2cc4a3828103f9a26ca9d0a6311b93a63))
- Update readme ([1ce5488](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1ce548851b1e3e2766ea2126a729fd55380252af))
- Bump kernel commit and update changelog ([a6b20db](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a6b20db37d1deb89fccf8b42a4e503824b423f59))
- Update kernel config ([899c205](https://github.com/gjrtimmer/ubuntu-rockchip/commit/899c205d605f7b91abd2d3f5d86ad3e08ee250cb))

## [1.16] - 2023-05-29

### ⛰️ Features

- Add 9tripod support ([922b275](https://github.com/gjrtimmer/ubuntu-rockchip/commit/922b2755fb2dacd5ae8f36e6554567ba5d35a34f))
- Add initial 9tripod device tree patch ([f8fafb1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f8fafb1adc4024bd63ed197b0a50ddeee4bb8005))
- Enable zram module #161 ([26855b7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/26855b751d2ffe0a255e0f467d45f7ac6828f196))
- Add wifi drivers for rtl8811cu and rtl8821c ([85eff49](https://github.com/gjrtimmer/ubuntu-rockchip/commit/85eff49c9a2ea4a7a241cb55e5e2777422410e37))
- Add multimedia ppa to server image ([c87ab81](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c87ab819db23c16ff218ca4214369de3b2bae7e9))
- Add audio config for opi5 plus ([6b5bda8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b5bda8a0998c2fcc9053e80ca6fbd00129efedb))
- Add 9tripod u-boot ([a6ee072](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a6ee0721e1ef341a0dce10406b12008a6376609e))

### 🐛 Bug Fixes

- Fix 9tripod u-boot create orig tarball script ([ffb364e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ffb364e2311a6695d88a6a1fe35e4477078ac5ad))
- Fix rock5b cloud-init ethernet ([6dff139](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6dff139e75b51c55c4a6d19dd557d775ca247dee))
- Fix 9tripod wifi patch ([bd83703](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bd837034769c6caa3b1d55e6f0d325de9cd3e861))
- Fix compile warning ([f2373c6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f2373c6c73be2d8240031810d3e181f34beb5271))
- Fix ubuntu server ethernet for 9tripod ([48e80c5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/48e80c5682c47a843a2a92188629a1824331f0f8))
- Fix bluetooth firmware for 9tripod ([9ff5132](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9ff513261f77bbf3f594d57fd7773faafec9b2e1))
- Fix kernel build version ([e040107](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e0401070cc693ac5b053f5fb8e5b725d8c7fee8f))
- Fix rtl-bt initramfs hook ([c125e74](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c125e74e9b46bea8b0f1a00514514b8cd2eb9ebf))
- Fix rock5a audio config ([1d75fd7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1d75fd76b5753010cee66fca254974c0ada96cbd))
- Fix rock5a typo ([c709b6f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c709b6f914f6f2455bb62bb6265833fd3ea3ee91))
- Fix small typo ([91722f8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/91722f853fbf6eac931a3bc1e5b66682cf5b433a))
- Fix 9tripod u-boot ([57a25ae](https://github.com/gjrtimmer/ubuntu-rockchip/commit/57a25aeca7490fcfc799ae3769864dc6a6373207))

### 🗑️ Removed & Reverted

- Remove win-cursor for rock5a and rock5b ([114a7e0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/114a7e00c916b268c9c32db5c91f9cb630ccfdb8))
- Disable CLOCK_ALLOW_WRITE_DEBUGFS notice ([a52c7d9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a52c7d90999d25c9fc679559a7d73e9f5f679567))
- Remove opi5 plus patches for now ([4a1cac5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4a1cac5ae0f159d75257b3f8cc2f97ab4ad43b18))

### ❓ Other

- Kernel patch to for rtl8811cu and rtl8821c chipsets ([62d1bd0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/62d1bd07aec3911c366661b2f31a9c48913f1486))
- Upstream kernel update ([ef3e22e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ef3e22e2b0db02b224dde4ec32ed37f0af48de01))
- Another patch refresh and opi5 plus improvements ([9d1f950](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9d1f950c2e906b3941462551600f2b2da8fe6b0d))
- Refresh patches and add inital opi5 plus device tree ([2d8814e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2d8814ef8a50c9772aa579610013b651e10c5bf0))

### 🚜 Refactor & Cleanup

- Use flash-kernel to handle dtb and overlays ([2a77d35](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2a77d353755d693799bb8a970040652d3ce54e07))
- Set hdmi audio as default for indiedroid nova ([938db4d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/938db4d0aff2bd6723535e3451ad371c3286f9be))
- Change kernel branch ([f566207](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f566207d4012952f56daa03e04cfc228d71c6166))
- Improve ap6275p bluetooth script ([26a41c4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/26a41c40d2d5029b71a5e07fee5a4ead31eb1659))

### 📚 Documentation

- Readme update ([09c4cdd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/09c4cdd082c5c6e5f71f23b94a83c926f29e47f4))

### ⬆️ Dependencies & Updates

- Update kernel changelog ([e026ad9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e026ad90d27b62c88ca410a4906087deed7ce2c1))
- Update include binaries for 9tripod u-boot ([8a6d797](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8a6d7977d41ce67ae853a06f802de6eb8ceae483))
- Update 9tripod u-boot version ([e7f9862](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e7f986274fa9ca7e93076561c345813997e2d927))
- Update kernel package version string ([482b053](https://github.com/gjrtimmer/ubuntu-rockchip/commit/482b0534709b2a6f6e9f1ec0d1a0b728607fe03f))
- Update readme ([41ae432](https://github.com/gjrtimmer/ubuntu-rockchip/commit/41ae432b58d09c9d3bca6b181c2370f626033773))
- Bump orangepi u-boot ([a340074](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a3400744335e0f128057ea8eaa1e2f3950f74fdd))
- Update kernel to linux-5.10-gen-rkr4 ([d72f174](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d72f174fb75090b47a3e2b91957be72456de762d))
- Update build script usage ([a6b21a7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a6b21a74f08416a6fdae0f8da6980d46c5e9b300))
- Update kernel changelog ([7567f15](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7567f1562603417c64bb8aa0fccfe6f6ac40c558))
- Update defconfig ([6707e2e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6707e2e5489afeafe26b6bdf0dd00c4d41981384))
- Update defconfig ([e27a736](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e27a73656c932966573260af6abb63566d02f23d))

## [1.15] - 2023-05-19

### ⛰️ Features

- Add overlay prefix ([c83cc87](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c83cc87ee139361793162ad489505c631be2ea7a))
- Add rock5a audio rules ([63cede0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/63cede0b2b36c1ef26061302adba64c2def225a7))
- Add upstream info to rockchip kernel package ([f88cd38](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f88cd388b4745db6b4fe0482d6d0d9e5be981d39))
- Add audo udev rules ([5c055a5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5c055a5b2c09027c192d85a4922c4ca8ea82cf71))
- Add initial nanopi r6s / r6c support ([0e84952](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0e849526e17e0b9daa0ce2a58893d11e8df04082))
- Add initial kernel packaging for nanopi ([e00c5de](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e00c5de12eb535d8b5f2bdfc3655a1daadcf49a2))
- Add inital u-boot packaging for nanopi ([314c42a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/314c42a3f9963b3b369d8ee7fa4b8d44187fd778))
- Add clean command ([0dd712d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0dd712dc0284a27f9770576734c187d4c83df2df))

### 🐛 Bug Fixes

- Fix cursor flicker and hdmi issue for rock5b #145 ([7e3d9d2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7e3d9d22c974d94b4015eefa1fc8e54251571ea5))
- Fix opi5 and opi5b boot issue ([2b8eec1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2b8eec13aecd7b18203e240b1019807389e12126))
- Fix kernel ppa build ([15fd557](https://github.com/gjrtimmer/ubuntu-rockchip/commit/15fd557fdd6fc5f6119e8a5a13e97126e49b91bf))
- Fix radxa u-boot ([2d0b11d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2d0b11d967df1ad53c65b2df143f3a5386c0909f))
- Fix radxa u-boot and kernel package ([eac6fac](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eac6fac4e392ca331a3519437b3f96993a3b6bdd))
- Fix radxa u-boot ([0bc1b1a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0bc1b1a79c7eaf6b4a0b335789346f2dccdb9012))

### 🗑️ Removed & Reverted

- Remove chown ([a39c702](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a39c7026dbf1deddab223c0f43519e26c4584391))
- Remove pan mesa debug env var ([82047c0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/82047c0087747cfe742a1fdc4c2eae52c6699058))
- Remove kbase debug assert ([3d4b0bb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3d4b0bbf6f49cbcd9813932507d22bdbe617acdc))

### ◀️ Reverts

- Revert remove kbase debug assert ([395114c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/395114cf7956e1345430b5eede4d11a5950f0c5b))
- Revert orangepi defconfig ([5215030](https://github.com/gjrtimmer/ubuntu-rockchip/commit/52150305c142718a4197b2525690e16b134ce5ac))

### ❓ Other

- Re-work kernel fork ([a54d896](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a54d896c761b12d8e87566872d95bbc566ea5adb))

### 🚜 Refactor & Cleanup

- Cleanup kernel patches ([e84e8c7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e84e8c750581d0eb886b59fd60b77561ae67366a))
- Set kernel version from changelog ([7ba6a99](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7ba6a9921644b628912b14ca53e6b0f995644ac7))
- Set hdmi audio as default for orangepi5 and nanopir6 ([ae8c3db](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ae8c3db3ad4cf5f2cea0bb44bf0c7c54c01d88c3))
- Change default ppa ([6c7659b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6c7659bbf505f23be46f5ddafdcf41af4e7673fb))
- Use linux-5.10-gen-rkr3.6 kernel fork ([2a0d835](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2a0d8350dd602c06fa29365f80784ef68dddba91))
- Set device tree for rock5 ([9e65ac2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9e65ac2b84502b3be7b3fbe8be4e84f9e4ae30b4))

### ⬆️ Dependencies & Updates

- Update kernel changelog ([7142eb5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7142eb57983adbc0d4ce6dd11baa9d68d6332512))
- Update readme ([99c77cb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/99c77cb7999af659ed3d8c939878c9ac141add31))
- Update defconfig ([8c6eb8e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8c6eb8ed38b4e5822bd74e6ec52c13d6873dc61c))
- Update kernel patches ([712ebb6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/712ebb62ff3a660cf2638f89e16356257e9bc80d))
- Bump kernel commit ([08628fc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/08628fcc9ca52e4a31c8e7c6a63eb92d22a9f0fa))
- Update defconfig ([fb8aae2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fb8aae25ed201db03f73c2b95e02cc22017b4039))

## [1.14] - 2023-05-04

### ⛰️ Features

- Add rfkill package ([ce97bcb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ce97bcb643834f2475c7a6955254550039c1ac3e))
- Add kernel and u-boot packages for orangepi and radxa ([335a104](https://github.com/gjrtimmer/ubuntu-rockchip/commit/335a104b58dbad73317b1929cbe3084d5ca20bb8))
- Create debian repo for u-boot and kernel ([b9a8bc0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b9a8bc0c70204f0b5f1907b319381a12f23aea98))
- Add launchpad param to docker ([4c9e71f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4c9e71fe096b7609029ca64a7a37b6a6c68a3ecf))

### 🐛 Bug Fixes

- Fix kdeb pkgversion ([eb2ff8c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eb2ff8c5a1d8db8ce221ea9752adb0cb66081f5c))
- Fix cross compile build ([53f2290](https://github.com/gjrtimmer/ubuntu-rockchip/commit/53f22908a321c33b7b8a2c6e55123a3e8f83ef84))

### 🗑️ Removed & Reverted

- Remove rktoolkit ([02957ef](https://github.com/gjrtimmer/ubuntu-rockchip/commit/02957effef5e3f0c70a2ca6e522f045a12ebfed5))
- Remove rktoolkit ([511c9a1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/511c9a11fa86a1eae39df63d869ff9263b00676a))
- Remove pulseaudio systemd override ([9e86eaa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9e86eaab0415ae8c5f07b75c722422f567020be7))
- Remove bsp rockchip audio config and disable dmc by default ([b23394a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b23394a818e3270f5c54e5fc89add14b9f87e8e1))

### ❓ Other

- Small code cleanup ([75b2d66](https://github.com/gjrtimmer/ubuntu-rockchip/commit/75b2d66d0a9dfb976d3980b5d166b18c2dafa78b))
- More packaging improvements ([8c15da5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8c15da52f95b61eadb6ca2c49430f606f932dc46))
- Inital prep for rock5 support ([0d7a595](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0d7a5959fd235749f4e67324c4fa300a875b462a))
- Let systemd create machine id on first boot #123 ([d4fd5d2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d4fd5d28247013da26f427518d31e7d881dedf18))

### 🚜 Refactor & Cleanup

- Move debs to packages folder ([d73f7e6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d73f7e65f1e2cca8fb6f923a6cc3ad0f4a47e9d1))
- Increase cma size to 256MB ([3b496bf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3b496bf0a9deffacd60a3751f61de45242815873))
- Improve uboot makefile ([edd7599](https://github.com/gjrtimmer/ubuntu-rockchip/commit/edd7599d34ec4075ceb21558731021ea4fa8f96d))
- Use dpkg buildpackage to build kernel and u-boot ([27e0fa5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/27e0fa515e5e52b3a0849df9e4b65d006aa10b29))
- Use hardware mac address for bluetooth #112 ([3698c14](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3698c14c22989aac4a4c995cde85f553246d5735))
- Improve rock5 build and add uboot env ([5692606](https://github.com/gjrtimmer/ubuntu-rockchip/commit/569260634a94a29f0b2ec2435615ec7c820298df))
- Improve build system for more boards ([1384655](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1384655f4fbf3383e51d360f4f326ef53c76a3ee))
- Improve loopdev cleanup on early exit ([2ad51a2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2ad51a262f264f977e1a9c9d9dc62f733e4c0f65))

### ⬆️ Dependencies & Updates

- Update readme ([2bf9e26](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2bf9e266cb63731a662eee36a74bfea3b019af5a))
- Update jammy release info ([757563d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/757563d449520bb383ecdb773774a59cdd986f53))
- Update orangepi u-boot changelog ([5c15fda](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5c15fda6a80c666a49414c868255593f08493baf))
- Update default hostname and hosts config ([e84feb4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e84feb4dea2382d7e135fd2a2dea70ad9e8ac370))
- Bump u-boot commit ([73499ff](https://github.com/gjrtimmer/ubuntu-rockchip/commit/73499ff6f2b0bc327a30661cbf260d740e06b69a))
- Update u-boot package readme ([2165f70](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2165f70954490ddcf89aeffb0c09f470536e6cb4))

## [1.13] - 2023-04-21

### ⛰️ Features

- Add u-boot to launchpad ([568a9e0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/568a9e016735027a049478bb26c9e75a285d0c4e))
- Add wiringpi to launchpad and refactor ([b879b74](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b879b74b12a355936ca61ee76d088b3a6d7f157f))
- Add orangepi-firmware to launchpad ([d207586](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d207586af4f1911ba4eb397cc13ec20a7cd44bca))
- Add launchpad kernel ([d73f7a5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d73f7a5cb177da55420ac8b9e381256593ac044e))

### 🐛 Bug Fixes

- Fix u-boot script typo ([611ae70](https://github.com/gjrtimmer/ubuntu-rockchip/commit/611ae703db233d504bb270ed4bc5cf8d3e8685d8))

### 🗑️ Removed & Reverted

- Remove hold on alsa-ucm-conf ([7038008](https://github.com/gjrtimmer/ubuntu-rockchip/commit/703800850384faade378ee7e4df0c7fb8e517251))
- Remove vscode tasks.json ([b748074](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b74807460cfc3998f393e1bc91c7777343801cea))
- Disable rtc by default and use fake-hwclock ([153511a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/153511aa56dfb55214c911a4171fff56eb362799))
- Remove orangepi-firmware from local build ([12a2760](https://github.com/gjrtimmer/ubuntu-rockchip/commit/12a27604159ce65439b3802770d518efd244ae85))
- Remove extreme xz compression ([f370b15](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f370b1571851baab323a718a1f2f87a44da7e692))

### ❓ Other

- Slight refactor ([951b517](https://github.com/gjrtimmer/ubuntu-rockchip/commit/951b5170e10963f913d78f198e5cfb7f7e629a5a))
- Get rid of ridiculous compression ([cf0688e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cf0688eb21bfd332100702ba248767a216845072))

### 🚜 Refactor & Cleanup

- Increase boot partition size ([265ff21](https://github.com/gjrtimmer/ubuntu-rockchip/commit/265ff21d085db211eb1a8bb74871bf9985dbfec7))
- Refactor oem setup ([fcdac43](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fcdac433c7f5f6664cf44004512b3eb28379caf7))
- Use uuid instead of label ([5fb4fc1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5fb4fc13b66d940b2fc32641382bbf0162eb1aad))
- Move boot files to the system-boot partition ([0c0a8d4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0c0a8d4224b40f32c37fd8ae0a709b3cf4f3dd74))
- Use custom kernel repo ([c9661c1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9661c194b76c73002960144323db04d2c62fdc2))

### ⬆️ Dependencies & Updates

- Update readme ([faa046e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/faa046ea59c669b20561e29614903c457caeb592))
- Bump u-boot commit ([acf6da7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/acf6da716cb5e3babf3f293056bcd3e287212a71))
- Bump kernel commit ([810ffa0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/810ffa0fbd7f6a124276f282b8e86da94cca73cf))
- Bump kernel tag ([4daa8af](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4daa8af6e76f5484d883c7f4734e260a4f6636ca))

## [1.12] - 2023-04-11

### ⛰️ Features

- Add orangepi5b u-boot support ([3c32cb5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3c32cb57ee6e0153151343d0ceb0c2699284829a))
- Add funding yml ([a1defd6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a1defd62997026c445ee8ec4c01151188438b8d3))
- Add wiringpi for orangepi5b ([e448209](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e448209aae6c66cd1e15135c2710239286d76dd8))
- Add inital command line argument parsing ([96b2863](https://github.com/gjrtimmer/ubuntu-rockchip/commit/96b28634f57da4566eccb5b19ba882ece3ea3344))
- Add orangepi5b board target ([f8d206c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f8d206cb9839c8e75b3d2a4d6b90b48a9d01f232))
- Add preinstall script to remove dtb ([13256a0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/13256a0820b21fe3f4cd7f809c1384ef5d653b25))
- Add audo naming rules ([6b067ce](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6b067ce89577a2710bf907980c5972ba2d52b07f))
- Add wait for loopdev creation ([c0aacb3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c0aacb331b33e23d6b26f7f2540b4cba1fe2b3e3))

### 🐛 Bug Fixes

- Fix docker build ([ccac3d7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ccac3d742df53334e58e0b9eed857d7e38855f14))
- Fix for realteck 8811cu/8821cu usb wifi ([59b7dd3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/59b7dd35b0b8e5147d916cc795f763a6c8bae157))

### 🗑️ Removed & Reverted

- Remove dev volume from container ([9da861f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9da861f3f136b1acf0735cc0ecb8252fe534dee0))

### ◀️ Reverts

- Revert u-boot commit ([cb3cd8d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cb3cd8d0283979281176367007a9d0efc3d91a0f))
- Revert remove dev volume from docker ([635828b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/635828b057961c4843f219ddaa9999ccb492b921))

### ❓ Other

- Place alsa-ucm-conf package on hold ([d5224dc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d5224dc981f99bd2f57de2214fc73543f5de7184))
- Export board variable ([67e8a7c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/67e8a7cde16bf63b70f9e95283ff1a1b78c64787))
- Package orangepi-firmware ([160599a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/160599aee56bbae27135a6b2c65c065e3a4cbbae))

### 🚜 Refactor & Cleanup

- Move built bootloader files ([590a338](https://github.com/gjrtimmer/ubuntu-rockchip/commit/590a338079220dd109c76955a9abe7455a48a6c3))
- Change sha256sum file suffix ([559267e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/559267ebb04dc1f085c811f6bccc5ac5479420fd))
- Rename kernel patches ([149784e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/149784ef0663a086f1f8ec7516749edb2cefb05f))
- Change kernel version string and add dtb package ([fd4c7cd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fd4c7cd340c677fe140effba6a4b0a0b4c58b8dd))

### ⬆️ Dependencies & Updates

- Update readme ([c27c348](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c27c3489237bcef1f3fa28b9f93e8a044c66ff6d))
- Bump firmware commit ([fa54c4e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fa54c4eba1cca5d062eee9ddac5563922f2f7256))
- Bump kernel commit ([76f1a20](https://github.com/gjrtimmer/ubuntu-rockchip/commit/76f1a207ec0dd8bc926e2226815a287a5612f2f9))
- Update hdmi and dmc kernel paches for orangepi5b ([1a7807e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1a7807e34376f3f96c7d19009ed61d967a88da3a))
- Update ubuntu version string ([61bfe9a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/61bfe9a758bbdf0ccff777a0438a807450270553))
- Update readme ([e6fa203](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e6fa203a33ab482cd7ac33ddf5124af6964e917d))
- Update readme ([2a6ead6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2a6ead6a58926adb3b7071efcef6bbec07d4efc1))

## [1.11] - 2023-03-29

### ⛰️ Features

- Create sha256 hash of built image file ([5504c96](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5504c966d410c43ea321aa547b213c81d97b7c38))
- Add libwidevinecdm package ([e2c22df](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e2c22df35af7ec19ed1a86e5ccfdcbd34ad31a85))
- Add ubuntu oem installer ([dcb71c5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dcb71c54e2e442af18b8d8e33862f5c0efef8e60))

### 🐛 Bug Fixes

- Suppress unsupported format modifier ([aa9ac90](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aa9ac901ae8936c6d45762fd3fa2fbbadcfe0ab5))

### 🗑️ Removed & Reverted

- Remove custom mpv deb ([1f468e7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1f468e730f0a969e6c38590d4a6c555707a16b34))

### ◀️ Reverts

- Revert default locale change ([6209161](https://github.com/gjrtimmer/ubuntu-rockchip/commit/62091614406365bf13f5d7d1f1ebc573a8998ebf))

### ❓ Other

- Code cleanup ([f3e3622](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f3e3622b1ea9ef11cd64df88ba4b156dc7389f97))

### 🚜 Refactor & Cleanup

- Use drm hardware decoder ([f000c6f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f000c6f54ad390706f594846616c2e4088e03671))
- Use panfork mesa and rockchip multimedia mirror ([bf5265c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bf5265cb6bca3c80b8161994a102f56622d52a4c))
- Set default locale to C.UTF-8 ([6fec6f2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6fec6f211e456df960802618d220a526bd98d361))

### ⬆️ Dependencies & Updates

- Bump firmware commit ([517a995](https://github.com/gjrtimmer/ubuntu-rockchip/commit/517a995561ebd4aceb8e07382997be26c5a1c695))

## [1.10] - 2023-03-21

### ⛰️ Features

- Enable dmc ([84838ba](https://github.com/gjrtimmer/ubuntu-rockchip/commit/84838ba5fd35840127da0bd5b226f6435d65e077))
- Add wiringpi to server image ([b6bf425](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b6bf425acb393262cd2504eeec6c21ea6afc9137))
- Add rtl_bt firmware to initrd ([1ce88b6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1ce88b69f60dfd9354976f9006617647292c437d))
- Add xterm package ([89b6dc3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/89b6dc3f7f0bbc08ce8e92c8c7b76e8c7f74c39f))
- Add rockchip multimedia config package ([83382a6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/83382a6bf7e64c6640f5e1f54c2a65e4892e22b2))
- Add --rm to docker args ([44ae644](https://github.com/gjrtimmer/ubuntu-rockchip/commit/44ae644b1c5da512c4e87eabdc7c5007c58c74b8))
- Add fdisk to required packages ([fcb8030](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fcb8030e92e28658ea59815c4515c7eb0e9271ab))

### 🐛 Bug Fixes

- Fix cloud-init to use system-boot fs label ([268dbe3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/268dbe3746f4573d00019ead8dafffeafb99827d))
- Workaround for intel ax210 wifi ([2dd796e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2dd796e2b7c26d109290a3d099326af4eb645b4d))

### 🗑️ Removed & Reverted

- Remove --no-install-recommends ([7e2ddde](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7e2dddedf7560ddd8a28867c5c0587e068ef740b))
- Remove cryptsetup and add landscape-common ([2fe0e71](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2fe0e7132326c3e0e4d70b3b4f0d99fbe5e31cff))

### 🚜 Refactor & Cleanup

- Use partition type by uuid ([55a3b7d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/55a3b7d23a6f9507c6e0446d3144968c716968d5))
- Change root and boot partition names ([28c10ec](https://github.com/gjrtimmer/ubuntu-rockchip/commit/28c10ecdb9395e7bb01fee2f6e7a7df9ce302f81))
- Change default hostname to ubuntu ([a7e1a27](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a7e1a274ee33a955111ca8a2f07f9130ca718c59))
- Refactor dockerfile ([6c7a8d2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6c7a8d2619f8610241ffd928e9ebf04fd49eaa42))
- Set codecs for rk3588 ([474e8bd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/474e8bdacdfd1caa51f51a9ccccf576053c65205))
- Change kernel version string ([9589054](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9589054af1e54924871e7ff860152395f63e4950))

### ⬆️ Dependencies & Updates

- Update readme ([c3127e3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c3127e3022d5725c7565198142f8aca2afe06a40))
- Update readme ([34ff000](https://github.com/gjrtimmer/ubuntu-rockchip/commit/34ff0008d16e2e72986069f76613a5010d7d7287))
- Update uboot script ([6c17e98](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6c17e98d1b29151681f8cceaf5a83105f4469bcf))
- Update libv4l and support setting codecs ([7f16e7c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7f16e7cac4a85ad08be9d9a735a3c4d1a2a39d2f))
- Update readme ([c8c8a36](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c8c8a3692728efeed4bf3360950a30b4a85655a6))

## [1.9] - 2023-03-11

### ⛰️ Features

- Add vscode build task for docker ([9b21651](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9b216513932ea24159618c0f184e651c2187310e))
- Add mtd-tools ([997d7cd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/997d7cd9960a3db68f15db6d45cf15e6b161a988))
- Add comment in rc.local ([8d16cea](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8d16ceadf4daf35a1fc23daa82d068ad795a9e76))
- Add optimizations for docker and microk8s ([0d324bc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0d324bc44f88fbf7ec0e224b6df876b901bb7028))
- Add qtwayland optimizations ([bdc65af](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bdc65afbc4e79f9290acb99d831f8c2b1ea2717b))
- Add qtwayland5 package ([ab5d831](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ab5d83142f4c1b1967a8434bcc1e7dd2112e53c3))

### 🗑️ Removed & Reverted

- Remove libdrm and libdrm-cursor packages ([21b776b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/21b776babb932916a3a6511d6b8d50fad409daf5))
- Remove xserver package ([24d3cd3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/24d3cd3b0713b6274d324f52428db60a9aa9d88a))

### 🚜 Refactor & Cleanup

- Use device tree overlay prefix ([3eba7cf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3eba7cfd5e2f1ac1588fe3628432b49011f4f75a))
- Use chromium from amazingfate's ppa ([aa08cdc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aa08cdc96e128e41db66a7bf5facb915f49a4c1a))
- Use panfork mesa from amazingfate's ppa ([089fc32](https://github.com/gjrtimmer/ubuntu-rockchip/commit/089fc329a974dde6b7f90a5cc16733934c81564c))

### ⬆️ Dependencies & Updates

- Update readme ([b6e368b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b6e368b30867f6955ff45d0bcf8d5bef82243021))
- Update readme ([b2a7872](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b2a7872d9c2f42e1d1e9a550af21f9f2b9f99b27))
- Bump kernel commit ([76f0d4c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/76f0d4c413dc56c07c6ca56858097fdb69c46332))
- Update initial chromium preferences ([d596021](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d5960216b6a12534df79417fcc40af63b4bb1e06))
- Update readme highlights ([e2ef76b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e2ef76bbb5c4a6341f92685ef7e92c093e7ee49c))
- Bump kernel commit ([5f2526a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5f2526aa96f7c296212eae3c89f449da4880b1d7))

## [1.8] - 2023-03-05

### ⛰️ Features

- Add config prefix to module scmversion ([f69bc99](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f69bc99a13a72346e0e84f481939e84b57fcc31e))
- Add support for MediaTek usb dongles ([b5207a9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b5207a95e46d5f759bda489ac60028aabe99460b))
- Add cloud-init for server image ([aa8ff34](https://github.com/gjrtimmer/ubuntu-rockchip/commit/aa8ff344b2b6e7a154d8f6ed487ba7ed95edc85d))
- Enable msdos fs support ([6068e55](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6068e551a8be1d9e286ebae7ee91f51aa30eae5a))
- Add wiringpi ([a0cdbe3](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a0cdbe3d0cc933ef2ed982f3f80f1ed381ae9bd8))
- Add librist ([b3de35a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b3de35ada73ae4e05231c0af79bb58a43d3161f3))
- Add systemd service to sync system clock to rtc ([75bef68](https://github.com/gjrtimmer/ubuntu-rockchip/commit/75bef6810b7b40cddfa0f2c14ba776b545293949))
- Add script to build inside a docker container ([887997b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/887997b08002909dfdf02059fb11468472fd6c58))

### 🐛 Bug Fixes

- Fix local apt repo priority ([7ab57f4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7ab57f44e2d71dbd2548547b44266ea441668eef))
- Fix path for spi bootloader ([eded649](https://github.com/gjrtimmer/ubuntu-rockchip/commit/eded649018d522f177a7da884a317362ce09f5b8))
- Fix qemu-debootstrap deprecated warning ([13f4cca](https://github.com/gjrtimmer/ubuntu-rockchip/commit/13f4cca6c2c4fbd59d9cf1d7bb8db51f4f0e4da8))

### 🗑️ Removed & Reverted

- Remove default wifi device tree overlay ([d1948aa](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d1948aa4885f341d4ed6e2ef54ff5f58c5b400f1))
- Disable wifi powersave ([50a1047](https://github.com/gjrtimmer/ubuntu-rockchip/commit/50a1047e537420c8110a68c8a4ac9100f5144b01))

### ❓ Other

- Bring back vops change ([52542bc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/52542bc1ee7c6e1b03b7d53d468c7c8f340a370e))

### 🚜 Refactor & Cleanup

- Increase cma size to 64MB ([22b51a1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/22b51a1f04eaf72af8b6622745f19b49f9104b52))
- Use local networking for docker build ([1801e5c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1801e5c5986f6b9bca994287d3fd8b0744ea3d4c))
- Move docker build script ([cf554f9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cf554f956f8dbf989750d714941850f558be4714))
- Change default password to ubuntu ([2894948](https://github.com/gjrtimmer/ubuntu-rockchip/commit/28949481698ee9413793f4573b0bf8462954e7d7))

### ⬆️ Dependencies & Updates

- Update readme ([64c595f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/64c595fccc81e0b03e8c689e6120984ea79791f6))
- Update ffmpeg ([204b24a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/204b24a8c4c52fff6b1fb04e3820fd4c492c2c68))
- Update libv4l ([6959122](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6959122c314ab5495f971d29b8b79ce9efaeaf95))
- Update rga ([a921770](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a921770e91c3250894ff0be3dac7eecea335edcf))
- Update mpp ([ad15df0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ad15df0a32372a18c84007c447b39cac14e37231))

## [1.7] - 2023-02-25

### ⛰️ Features

- Add uboot spi images ([ba5989e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ba5989e80b070d2380fcecc684164f5a3e76ecf9))
- Add alsa config to expose audio out device ([bd9674e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/bd9674ecf10b583fe13ff309e9efe47f58762e50))
- Add brcm_patchram_plus for bluetooth ([b7a8c90](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b7a8c9071971dfd0ff598bebc51d08b72e1db2f3))
- Add lm-sensors package ([18a3f3b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/18a3f3b4b7d516f6fc621afb94064777d211e119))
- Add optimizations for mpv video playback ([9be8405](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9be84051f8a054a1997823c91cfcdc5b66ab1ec9))
- Add gstreamer good and bad for jammy ([455e280](https://github.com/gjrtimmer/ubuntu-rockchip/commit/455e2802b96fb2e07b404f19a984b68bcbc466d0))
- Add default user to input group ([8e484fe](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8e484fee051169c074e75737209aebec2ba8bbdb))
- Add quiet to kernel command line ([435a64c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/435a64cf68f246f30d95c56683a537053cbd86d6))

### 🐛 Bug Fixes

- Fix unreachable commit ([695f9c9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/695f9c997e0d540c455e09d2d675ffe6dbce1d31))

### 🗑️ Removed & Reverted

- Remove focal support ([98eebd1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/98eebd1a7d9447c2d52928a7ff46e44811a2af35))

### 🚜 Refactor & Cleanup

- Rename rockchip permissions rule ([b9d7430](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b9d7430ef4381bd93122a57857313c4d7c397754))

### 📚 Documentation

- Readme overview update ([a091ca0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a091ca05b296b984193fd2376bb0fb1fa6a37f56))

### ⬆️ Dependencies & Updates

- Update readme ([33b4204](https://github.com/gjrtimmer/ubuntu-rockchip/commit/33b4204d7bc85b13e933e4eb209abed49631b396))
- Bump kernel commit ([202fdd4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/202fdd4e57775c3d33f861fe98c5b961aaac82b9))
- Update cpu governor service and add gpu governor service ([ccc006a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ccc006a0a33ba3f77126409223feeb741f0e9e73))
- Update libv4l for jammy ([78972c2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/78972c2ea7f1b67a30a4c45fe9085c53f4137562))
- Update mpv for jammy ([e44b5c9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e44b5c93ab29998721bc7148b5d25152253f46d6))
- Update kernel config ([16b6baf](https://github.com/gjrtimmer/ubuntu-rockchip/commit/16b6baf3d629a124f171a3db047236b42a6923b8))

## [1.6] - 2023-02-19

### ⛰️ Features

- Add gdm hack ([324fcc9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/324fcc93ba5c1f98437d97612d4360b0ba3e3884))
- Add usb support ([26fb67b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/26fb67b6adf8f05f33535b1c579f64d215fc7755))
- Enable plymouth splash screen ([3e10d76](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3e10d76b8349b659c6c7b436dd816a59023e26a1))
- Add highlights to readme ([c9de671](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9de6713bceb6a6c4440a95ca629449ade5d9a07))

### 🐛 Bug Fixes

- Suppress wl_cfg80211_netdev_notifier_call ([fdd1e7f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fdd1e7fc2b531863e248732d7c52aa3916fb4a7d))
- Fix chromium as default browser ([2c71c7c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/2c71c7c8eaf2692f28df53d8865806e2e7339863))
- Suppress drm warning ([9c9030f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/9c9030fdbc46c5c8f628a5da6b3f1cd820774028))
- Fix dw dp warning ([3033f7b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3033f7bcfb30e95018d0c2cd5049857cb1092455))

### 🗑️ Removed & Reverted

- Remove unnecessary packages ([5726b8e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5726b8e7fad5a9686801623b16077ee11d10b46d))
- Remove rkwifibt package ([da33939](https://github.com/gjrtimmer/ubuntu-rockchip/commit/da33939a85d19f8113a2714dbd02230c0de54ddb))

### ◀️ Reverts

- Revert vops change and fix gdm hack ([881b843](https://github.com/gjrtimmer/ubuntu-rockchip/commit/881b843b42a98b3e47cf3d6c5f3a99477989def1))

### ❓ Other

- Shrink boot partition size ([c7ec2fd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c7ec2fdc8b73437e313827d262867b171bcba52c))

### 🚜 Refactor & Cleanup

- Rename kernel patches ([d8fe5bd](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d8fe5bde2fe2ebe1f18f82ac1f3199de8564aef5))
- Change vops ([f8d7aa2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f8d7aa249177c13351bcd6364c1d9e5b3468b891))
- Move resize filesystem to systemd service ([525a49c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/525a49c16e4d8db371bb3f3261feee4196481d9e))

### 📚 Documentation

- Readme update ([002b48c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/002b48cd454951e2f2516e1ac264122f94c56701))

### ⬆️ Dependencies & Updates

- Update readme ([3b9ecad](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3b9ecadd9e9eb0dba96cffae7e0b8dbb93173e21))
- Bump firmware commit ([a60fa7c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a60fa7cc6142f9746edeb8e197f08203291da716))
- Bump kernel commit ([fd2581c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fd2581c7c12c694afd646245977a1bd587779dfd))
- Update readme image ([88c5a94](https://github.com/gjrtimmer/ubuntu-rockchip/commit/88c5a948f8351f93671e3ace9478b15953b1b6f7))

## [1.5] - 2023-02-15

### ⛰️ Features

- Enable exfat filesystem support ([4e8599e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/4e8599e3e6f75dadea4e922fbae251108128fb17))

### 🐛 Bug Fixes

- Fix booting from nvme drives ([b989b94](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b989b94c7f3195dcc27d8701b44fd65713b3b94a))

### 🗑️ Removed & Reverted

- Remove --test-type chromium flag ([494136d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/494136d71e5767620a0a699f92f344f0ea08cf91))

### ❓ Other

- Hdmi audio improvements ([8228696](https://github.com/gjrtimmer/ubuntu-rockchip/commit/82286965fb84c2bf3b37aa5d29ed4b56235cd799))
- Config zram as kernel module ([b0ed822](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b0ed822e03ae8c7e7a62c592ff6a44a759183fa2))

### 📚 Documentation

- Readme update ([d37e6f9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d37e6f939f71b3c78aaa9eb0056d2da5f73a761c))

### ⬆️ Dependencies & Updates

- Update readme ([99de12e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/99de12e9cfe150ca278a1c4c12d78e6ee95b0648))
- Update hostname ([0d30953](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0d30953dc67216397d2178d9eedfe07cca1c5301))

## [1.4] - 2023-02-11

### ⛰️ Features

- Enable pressure stall information by default ([73f0a22](https://github.com/gjrtimmer/ubuntu-rockchip/commit/73f0a220c4ce8811e686cbffa0d28b5f9f58b55f))
- Allow device tree overlays to be used ([20e4259](https://github.com/gjrtimmer/ubuntu-rockchip/commit/20e425959974676feb34a756d66a1f86b574899b))
- Add pressure stall information to kernel config ([18e1b96](https://github.com/gjrtimmer/ubuntu-rockchip/commit/18e1b969c96777565dc959772bf899ec5664dedd))
- Add delay before starting bluetooth for the ap6275p ([7aaea2f](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7aaea2fa33513076c887cb2231c526bb58a45af8))

### 🐛 Bug Fixes

- Fix chromium desktop entry ([1904c68](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1904c689b4e90b67afa8f246f205c4e2307061db))
- Fix mouse cursor bug ([18f323e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/18f323e7aedbb7a19c178a7b17726a00a032884e))

### 🗑️ Removed & Reverted

- Disable --no-sandbox warning with chomium ([89fd868](https://github.com/gjrtimmer/ubuntu-rockchip/commit/89fd8686d5cc51751ec055330430e664d7757ee4))
- Remove grub ([833197a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/833197a0f919cbddb2fa5879850fd0e8aac2cffe))
- Disable clk writable debugfs ([0ba0fb5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0ba0fb5beab4efbf93ce2ec5426c9889dfa1a9bc))

### ◀️ Reverts

- Revert use git am to apply kernel patches ([70fc8e5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/70fc8e5a6d054cda6c3d3612ddc8a55a6630b6fa))

### ❓ Other

- Hold linux-libc-dev for jammy ([7bf23c4](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7bf23c47a860d93fbbdc641a203a95a978e81c6f))

### 🚜 Refactor & Cleanup

- Set cpu governors to performance ([22aa0c1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/22aa0c1f0968872bdc9f2def5fbd193ceaf884af))
- Move into kernel config ([c60c8ab](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c60c8abc9c22b8aa2b296ce8b46426c229837e2a))
- Use specific commit sha for sources ([534e2f8](https://github.com/gjrtimmer/ubuntu-rockchip/commit/534e2f8402a2150f62bdf9bc5c5244c4ec71e971))
- Use systemd service to enable the usb 2.0 port ([f90906b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f90906bcbf2721a7625694824a7adca7299d71da))
- Use git am to apply kernel patches ([fa72677](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fa7267711033713ace17b960367e5ff88bb350b6))
- Use gzip for compressed initrd ([265f80b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/265f80b9bedde14bab7135a6a5d339c73f1cc488))

### 📚 Documentation

- Readme update ([1db03a1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1db03a1dc2a16dc6e66d70b0fbb90d38ac5e9494))

### ⬆️ Dependencies & Updates

- Update readme ([48f3505](https://github.com/gjrtimmer/ubuntu-rockchip/commit/48f350596d77b5678f1398ef8e8ff73634576f17))
- Update readme ([3e6ef5d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3e6ef5d056c79f6f06258ca10e3fd4e9ac261b19))
- Update requirements ([a364e38](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a364e382d5a065330f75cdd7e0fe9fe6b30c18ca))

## [1.3] - 2023-02-08

### ⛰️ Features

- Enable bluetooth for broadcom ap6275p ([50ef358](https://github.com/gjrtimmer/ubuntu-rockchip/commit/50ef358b4ef809fb98b972416bf07f5a72387ae7))
- Add config file for xorg ([dc5b44b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/dc5b44b9b9e5b2162a792b2e6b0b72fb464a04a8))
- Add rootfs overlay ([fc3b23c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fc3b23c15a9e7810cb8cc08441af8e0177696440))
- Add gstreamer rockchip ([4254072](https://github.com/gjrtimmer/ubuntu-rockchip/commit/425407231a00e3b78dd7738cf466a043644f3beb))

### 🐛 Bug Fixes

- Fix broadcom ap6725p unable to find wifi networks ([99e7d46](https://github.com/gjrtimmer/ubuntu-rockchip/commit/99e7d462164b990ae6fdef6555ef96b97ddeb2cd))
- Fix unmanaged ethernet ([793d41d](https://github.com/gjrtimmer/ubuntu-rockchip/commit/793d41dc5b2f4a3e543f5cfac40ee72721badea8))
- Fix gstreamer rockchip filename ([c900821](https://github.com/gjrtimmer/ubuntu-rockchip/commit/c9008214d628238e83fdec9f2c1064390c4367a8))
- Fix hosts file ([fa89dd2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/fa89dd203bbd0d246d7c84a686aa06f4dadc3ab4))

### 🚜 Refactor & Cleanup

- Set cogl to use gles2 ([df197a2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/df197a2955d5632d9b81379dd0a9a0586de78123))
- Set gstreamer environment variables ([751c66e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/751c66e8e32f75dca63357de02da807e84424f38))
- Move rockchip multimedia rules to rootfs overlay ([b82812e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b82812ee2bbe425934f68afcdef5ff706ee87539))

### ⬆️ Dependencies & Updates

- Update readme overview ([a2ade77](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a2ade77c753b89b26d4af5a26bc6561b1f3fd772))

## [1.2] - 2023-02-04

### ⛰️ Features

- Add known limitations and bugs to readme ([0161877](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0161877c78cec454ab9a5dc78d09a051bd5c6f47))
- Add rockchip multimedia package ([3746b61](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3746b61d9aaed950f93921971803ec27438b44f0))
- Add mpv config file ([1e6016b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1e6016bc3242873e3f70f4915c7e957775eb9fb5))
- Create empty rc.local file ([b9c71df](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b9c71dff59e4dbad05f3a404a2f0be8a82764ed1))
- Enable the USB 2.0 port ([e29d6cb](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e29d6cb2c2ad0aa4817854ff32e0b07f720d7cd3))
- Add mesa panfork package ([8f599cc](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8f599cc542c32ae1779548488d89be5286c44457))

### 🐛 Bug Fixes

- Fix chromium desktop entry ([5a4ffe5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5a4ffe531c4c57376a5dcfa596329cb828c888f1))
- Fix libmali on jammy ([3d3f609](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3d3f60961aeb876f031f4075ec53c45737d371d4))

### 🚜 Refactor & Cleanup

- Set chromium password store to basic ([b602d3c](https://github.com/gjrtimmer/ubuntu-rockchip/commit/b602d3c1052b98c447848724f3d90a0893670f2d))
- Cleanup script to enable the USB 2.0 port ([72ad8d6](https://github.com/gjrtimmer/ubuntu-rockchip/commit/72ad8d602ba1bf321eb3f49322ab47aff9d0a7eb))
- Set chromium as default browser ([0820be5](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0820be52e7e9a81ac05af81308bbd7285236f857))
- Use a local apt repo to install deb packages ([e96cd20](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e96cd20e2a9e1d15070b602ac327fe2927919d74))

### ⬆️ Dependencies & Updates

- Update build tasks for jammy and focal ([cffe54a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/cffe54a785e51881109c889416246cee27b1d81b))
- Update kernel config ([ecaad1a](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ecaad1abf345e23280a4cbea6a83af057004f141))

## [1.1] - 2023-01-29

### ⛰️ Features

- Add chromium to favorites bar ([6cb1991](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6cb1991ed1c9dc6bfc67d360967d0ce25d2ffdc5))
- Add chromium to jammy release ([f0171c0](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f0171c00db3ebf2dde06f6cbae7b5ee90cded480))
- Add kernel patches for implicit sync ([e192c52](https://github.com/gjrtimmer/ubuntu-rockchip/commit/e192c526685a835bc410831c1b4982a92a4cb261))
- Add ubuntu jammy release ([5f920e2](https://github.com/gjrtimmer/ubuntu-rockchip/commit/5f920e2b9542639e9d3d53bdfa5c6f3acfb6c5f6))
- Enable mpp and rga hardware acceleration ([ba9553e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ba9553ecaf8bfee80c76ea06a4f421c382c8b3ef))
- Enable wifi device tree overlay ([555c4db](https://github.com/gjrtimmer/ubuntu-rockchip/commit/555c4dbcef954e69c23a3fb4080c3d567164cc8d))

### 🗑️ Removed & Reverted

- Remove qemu vm script ([f595986](https://github.com/gjrtimmer/ubuntu-rockchip/commit/f59598650e8dc3b028b78ce60ef689fb51eeec5a))

### ❓ Other

- Rework image build script ([a9907ff](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a9907ff4b31400c0cb13aedbbbf4fb2a8244e551))
- Impove mesa performance ([1717bf1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1717bf1c470c20f5b4a1842e2181cf8d4f584c79))

### ⬆️ Dependencies & Updates

- Update readme ([6f7350b](https://github.com/gjrtimmer/ubuntu-rockchip/commit/6f7350bba1dbbf2dad30315700f8ede99f8cd55d))

## [1.0] - 2023-01-24

### ⛰️ Features

- Add panfrost gpu driver ([32d31be](https://github.com/gjrtimmer/ubuntu-rockchip/commit/32d31bea6740cfa6062ad24eb68373fac6b3a466))
- Add hw accelerated packages ([7865ac9](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7865ac9487d676b49c8ef844e4e014503d529939))

### 🐛 Bug Fixes

- Fix kernel version string ([ffca180](https://github.com/gjrtimmer/ubuntu-rockchip/commit/ffca1801d4fc3c35808e268cca0a279016506620))
- Fix depmod on tc build ([402d1ce](https://github.com/gjrtimmer/ubuntu-rockchip/commit/402d1cec69a016531b2511245dec47194f33af40))
- Fix gdm crash ([d9cd6ca](https://github.com/gjrtimmer/ubuntu-rockchip/commit/d9cd6ca9e8a23e71470886557f0eb26ca26578d6))
- Fix kernel version string ([1fa2826](https://github.com/gjrtimmer/ubuntu-rockchip/commit/1fa28260c33f46384490fb4ee3199590d1e581ca))

### 🗑️ Removed & Reverted

- Remove sudo ([77ded59](https://github.com/gjrtimmer/ubuntu-rockchip/commit/77ded598f719d06715b44c4b5b81bdc48f72a0cf))

### ❓ Other

- Depmod fix ([a8de576](https://github.com/gjrtimmer/ubuntu-rockchip/commit/a8de576e9decd9082bfc9526258a1fea7f78b139))
- First commit ([3955292](https://github.com/gjrtimmer/ubuntu-rockchip/commit/3955292558b17cf2b8c6576506b69553557dadc1))

### 🚜 Refactor & Cleanup

- Install hw accelerated packages ([0a26ea7](https://github.com/gjrtimmer/ubuntu-rockchip/commit/0a26ea786c30346723de6e358eae76b810ca2612))

### ⬆️ Dependencies & Updates

- Update readme ([8f16ec1](https://github.com/gjrtimmer/ubuntu-rockchip/commit/8f16ec19bef34ba08fa16c605b9ec31372391d4a))
- Update serial console resize script ([7ca620e](https://github.com/gjrtimmer/ubuntu-rockchip/commit/7ca620e4bb1c33806c8cd2481b00a74e96d42d83))

<!-- generated by git-cliff -->
