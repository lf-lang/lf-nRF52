# lf-nRF52

This repository provides support for bare-metal programming of nRF52 boards from Nordic Semiconductor using [Lingua Franca](https://lf-lang.org) (LF).
Note that Nordic has shifted its focus to Zephyr, so you might consider using the Zephyr platform instead of the NRF52 platform in Lingua Franca.

Once you have followed the Setup instructions below, compile the [Simplest.lf](src/Simplest.lf) file as follows:

```
lfc-dev src/Simplest.lf
```
If your board is plugged in to a USB port, this should automatically flash the program onto the board and cause LED number 1 to start blinking.

Other sample programs are provided in the [src](src) directory.

## To Do

There is quie a bit of work to do before the nRF52 support is ready for prime time. Here is a working list:

- [ ] Merge the nrf52 branch into lingua-franca and update instructions below.
- [ ] Support soft device (in reactor-c, find "FIXME: If softdevice is enabled").
- [ ] Support nRF53 devices with threaded runtime to use both cores.
- [ ] Extend NRF52 target to support a `board` argument and handle switching boards.

## Setup

### This Repository

```
git clone git@github.com:lf-lang/lf-nRF52.git
git submodule update --init --recursive
```

### Lingua Franca Compiler

Until the NRF52 support is included in an LF release, you will need to use the git repository:

```
git clone git@github.com:lf-lang/lingua-franca.git
git switch nrf52
git submodule update --init --recursive
```

There is an executable program `lfc-dev` in `lingua-franca/bin` that you can use to compile `.lf` programs using this branch of the Lingua Franca compiler. We suggest putting the directory `lingua-franca/bin` in your path.

### Arm Compiler and Tools

1. Install the [gcc-arm-none-eabi toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads).

On Ubuntu:

```
        cd /tmp \
        && wget -c https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
        && tar xjf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
        && sudo mv gcc-arm-none-eabi-9-2020-q2-update /opt/gcc-arm-none-eabi-9-2020-q2-update \
        && rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
        && sudo ln -s /opt/gcc-arm-none-eabi-9-2020-q2-update/bin/* /usr/local/bin/.
```

On MacOS:

```
        brew tap ArmMbed/homebrew-formulae
        brew install arm-none-eabi-gcc
```

2. Install the JLink [software](https://www.segger.com/jlink-software.html)
for your platform. You want the "Software and documentation pack". As of April
2020, some of the more recent JLink software is unstable on Linux. Version
6.34b has been verified to work reliably on Linux and MacOS.

3. Acquire a [JLink JTAG programmer](https://www.segger.com/jlink-general-info.html).
The "EDU" edition works fine.

## Board Configuration

This repo is set up by default to target the nRF52840dk board without any soft device.
To change boards, copy the appropriate `Board.mk` file from `nrf52x-base/boards/...` into the `platforms` directory, overwriting the file that is there.

The file `platform/Makefile` pulls in the `platform/Board.mk` and Nordic's master makefile, `nrf52x-base/make/AppMakefile.mk`.  To customize, you can define makefile variables by editing `platform/Makefile` and setting the variables described in Nordic's README file, [`nrf52x-base/make/README.md`](nrf52x-base/make/README.md) (available after doing `git submodule update --init --recursive`).

Assuming `USE_APP_CONFIG` is set (as it is by default in `platform/Makefile`), Nordic's `AppMakefile.mk` will cause the `platform/app_config.h` to be included with your sources. That file is a copy of the `app_config.h` file in the `nrf52x-base/boards/nrf52840dk/` directory, modified by adding the following line:

```
    #define TIMER3_ENABLED 1
```

This line is needed because the Lingua Franca runtime uses timer 3 for its timer functionality.

## Troubleshooting

1. The LF compiler puts source files in directories called `src-gen` and `include` (and `fed-gen` for federated programs).  If you get compiler or linker errors that are unexpected, try deleting these directories.

## Resources

### From Nordic Semiconductor:

* [Main documentation page](https://docs.nordicsemi.com)
* [Getting started with nRF52](https://docs.nordicsemi.com/bundle/ncs-latest/page/nrf/gsg_guides/nrf52_gs.html) 
* [Developer home page](https://developer.nordicsemi.com)
* [SDK documentation](https://developer.nordicsemi.com/nRF5_SDK/doc/)