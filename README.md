# lf-nRF52

This repository provides support for bare-metal programming of nRF52 boards from Nordic Semiconductor using [Lingua Franca](https://lf-lang.org) (LF).
Note that Nordic has shifted its focus to Zephyr, so you might consider using the Zephyr platform instead of the NRF52 platform in Lingua Franca.

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

## Resources

### From Nordic Semiconductor:

* [Main documentation page](https://docs.nordicsemi.com)
* [Getting started with nRF52](https://docs.nordicsemi.com/bundle/ncs-latest/page/nrf/gsg_guides/nrf52_gs.html) 
* [Developer home page](https://developer.nordicsemi.com)
* [SDK documentation](https://developer.nordicsemi.com/nRF5_SDK/doc/)