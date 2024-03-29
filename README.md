# TCLHDL 
(Under development - No Release Available)

TCLHDL is a set of tcl scripts intended to aid FPGA Developers setting up projects
in an easy, reliable way, independent of vendor tools.

## Why Tcl
On the advent of python, many scripts, tools and programs are developed on python
because of what python actually can give (which is huge).

However on the Hardware World, specially on FPGA development the **de facto**
standard for building aid tools is the Tcl language. And the great majority of
Vendors supports Tcl script integration, not speaking on those who ship tcl engines
with their tools.

One other reason to choose Tcl lies on fact developers may prefer Linux or Windows
for their workflows, then supporting both bash (or other shell) and powershell
(maybe batch) scripts isn't suitable for the maintainability.

## Reasoning
As Fpga Vendor Tools, like Quartus II, Vivado, ISE, Diamond and other have already
a Tcl engine the underling idea is to provide a common interface for setting up
Fpga Projects. The ideal would be to use TclOO for that task, however besides
Quartus II supports that library that isn't true for the other tools.

We could think in the case to ship with this library TclOO but that isn't foreseen
for the time being, perhaps in the future!

## CMake Module
A CMake module is also provided.
CMake is an excellent tool for setting up build infrastructure. On that regard
the UseHdl.cmake module intend to generate the TclHdl project structure.

## Status
The project is under development and there is no release available.
It is already possible to use for Quartus II, Vivado, ISE, Diamond and Libero.
The development environment is being done on Linux (Arch Linux) and compatibility
tests are being carried out on Windows 10.
ModelSim support to Vivado is now available as well as the integration with VUnit
framework.
Microsemi Libero (tested on version 2022.3 and 2023.1) is now supported.
FlexLM handler on Linux hosts is now provided however it needs to be properly
supported inside of tclhdl.


- [x] Intel Quartus
- [x] Xilinx ISE
- [x] Xilinx Vivado
- [x] Lattice Diamond
- [x] Microsemi Libero
- [x] Vunit
- [x] ModelSim on Vivado
- [ ] FlexLM Handler on cross platforms

### Roadmap

* Provide documentation
* Refactoring and Clean Up
* First Release
* ...

## Project Documentation

* **Note:** The documention is still not available

## Related Projects

* [VLSI-EDA/PoC](https://github.com/VLSI-EDA/PoC)
* [FuseSoc](https://github.com/olofk/fusesoc)
* [pyIPCMI](https://github.com/Paebbels/pyIPCMI)
* [VUnit](https://github.com/VUnit/vunit)

