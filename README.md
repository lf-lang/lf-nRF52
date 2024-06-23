# lf-nRF52

This repository provides support for bare-metal programming of nRF52 boards from Nordic Semiconductor using [Lingua Franca](https://lf-lang.org) (LF).
Note that Nordic has shifted its focus to Zephyr, so you might consider using the Zephyr platform instead of bare metal programming.

## To Do

There is quie a bit of work remaining to do:

- [ ] Merge the nrf52 branch into lingua-franca and update instructions below.
- [ ] Support SDK versions 16 and 17 (currently only 15 works).
- [ ] Support turning off soft device (in reactor-c, find "FIXME: If softdevice is not enabled").
- [ ] Extend NRF52 target to support a `board` argument and handle switching boards.
- [ ] Support nRF53 devices with threaded runtime to use both cores.

## Setup

### This Repository

```
git clone git@github.com:lf-lang/lf-nRF52.git
cd lf-nRF52
git submodule update --init --recursive
```

### Lingua Franca Compiler

Until the NRF52 support is included in an LF release, you will need to use the lingua-franca git repository instead of a release of Lingua Franca:

```
git clone git@github.com:lf-lang/lingua-franca.git
cd lingua-franca
git switch nrf52
git submodule update --init --recursive
```

There is an executable program `lfc-dev` in `lingua-franca/bin` that you can use to compile `.lf` programs using this branch of the Lingua Franca compiler. We suggest putting the directory `lingua-franca/bin` in your path.

### Arm Compiler and Tools

Install the [gcc-arm-none-eabi toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain).

On MacOS:

```
        brew install --cask gcc-arm-embedded
```

On Ubuntu (the following is probably out of date):

```
        cd /tmp \
        && wget -c https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
        && tar xjf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
        && sudo mv gcc-arm-none-eabi-9-2020-q2-update /opt/gcc-arm-none-eabi-9-2020-q2-update \
        && rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
        && sudo ln -s /opt/gcc-arm-none-eabi-9-2020-q2-update/bin/* /usr/local/bin/.
```

### J-Link Software

Install the JLink [software](https://www.segger.com/jlink-software.html)
for your platform. You want the "Software and documentation pack". As of April
2020, some of the more recent JLink software is unstable on Linux. Version
6.34b has been verified to work reliably on Linux and MacOS.

## Testing and Demo Programs

Once you have followed the Setup instructions above, assuming you have an `nRF52840dk` board, compile the [Simplest.lf](src/Simplest.lf) file as follows:

```
cd lf-nRF52
lfc-dev src/Simplest.lf
```

If your board is plugged in to a USB port, this should automatically flash the program onto the board and cause LED number 1 to start blinking.

Other sample programs are provided in the [src](src) directory.

There are also some simple C programs that have no dependencies on Lingua Franca. If the above doesn't work, these can be useful to track down why.  Assuming you are in the `lf-nRF52` root directory, try the following:

```
cd nrf52x-base/apps/basic/blink
make flash
```

This simple C program flashes an LED. The `button` program in the same directory should also work.


## Board Configuration

The repository and demo programs are configured by default to assume that you are using the nRF52840dk board with soft device s140.  Specifically, the file `platform/Makefile` has the following lines:

```
# Configurations
NRF_IC = nrf52840
SDK_VERSION = 15
SOFTDEVICE_MODEL = s140
```

### Changing Boards

It may work to change the `NRF_IC` to, for example, `nrf52832`, but this has not been tested.  You will also need to change the `SOFTDEVICE_MODEL` to, for example, `s132`.  More likely, you will need to make more changes.

To change boards, copy the appropriate `Board.mk` file from `nrf52x-base/boards/...` into the `platforms` directory, overwriting the file that is there.

The file `platform/Makefile` pulls in the `platform/Board.mk` and Nordic's master makefile, `nrf52x-base/make/AppMakefile.mk`.  To customize, you can define makefile variables by editing `platform/Makefile` and setting the variables described in Nordic's README file, [`nrf52x-base/make/README.md`](nrf52x-base/make/README.md) (available after doing `git submodule update --init --recursive`).

Assuming `USE_APP_CONFIG` is set (as it is by default in `platform/Makefile`), Nordic's `AppMakefile.mk` will cause the `platform/app_config.h` to be included with your sources. That file is a copy of the `app_config.h` file in the `nrf52x-base/boards/nrf52840dk/` directory, modified by adding the following line:

```
    #define TIMER3_ENABLED 1
```

This line is needed because the Lingua Franca runtime uses timer 3 for its timer functionality.

### Soft Devices

A soft device is a Nordic concept that provides a layer of abstraction between your application and the underlying device drivers.  It is needed to enable bluetooth communication with the board.  If you wish to run your code on truly bare metal, with no soft device, you can change the `SOFTDEVICE_MODEL` to `blank`, but you will also have to make a small change in the `lfc-dev` compiler.  Specifically, the file `lf_nrf52_support.c` has the following lines:

```
  return sd_nvic_critical_region_exit(0);
  // FIXME: If softdevice is not enabled, do the following instead of above:
  // __enable_irq();
  // return 0;
...
  return sd_nvic_critical_region_enter(&success);
  // FIXME: If softdevice is not enabled, do the following instead of the above:
  // __disable_irq();
  // return 0;
```

In each of these two blocks, you will need to comment out the first line and uncomment the last two.

### Other Command-Line Tools

A suite of [nRF command-line tools](https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/) may prove useful.
This will install tools like `nrfjprog` and `mergehex`, as well as the optional python bindings for `nrfjprog`, `pynrfjprog`.
For example, you can use these tools to erase the device:

```
nrfjprog --eraseall
```

You can also flash a hex file:

```
cd nRF5_SDK_17.1.0_ddde560/examples/ble_peripheral/ble_app_hrs/hex
nrfjprog --reset --program ble_app_hrs_pca10056_s140.hex --verify
```

## Troubleshooting

1. The LF compiler puts source files in directories called `src-gen` and `include` (and `fed-gen` for federated programs).  If you get compiler or linker errors that are unexpected, try deleting these directories.

## Resources

### From Nordic Semiconductor:

* [Main documentation page](https://docs.nordicsemi.com)
* [Getting started with nRF52](https://docs.nordicsemi.com/bundle/ncs-latest/page/nrf/gsg_guides/nrf52_gs.html) 
* [Developer home page](https://developer.nordicsemi.com)
* [SDK documentation](https://developer.nordicsemi.com/nRF5_SDK/doc/)
* [Soft devices](https://infocenter.nordicsemi.com/pdf/getting_started_nRF5SDK_ses.pdf)
* [J-Link Commander](https://www.segger.com/products/debug-probes/j-link/tools/j-link-commander/)
