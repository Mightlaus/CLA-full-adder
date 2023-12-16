# CLA-full-adder
A high-performance and versatile carry-lookahead (CLA) full adder designed for rapid addition of arbitrary x^y bit inputs.

## Module Hierarchy
The project follows a modular structure, as illustrated below:
```
Hierarchy
( 1) └── fadd_tb.v
( 2)     └── fadd.v
( 3)         ├── Sum.v
( 4)         ├── CLA.v
( 5)         │   ├── CLA*.v
( 6)         │   ├── CarryGen.v
( 7)         │   └── PGxGen.v
( 8)         └── PGGen.v

* denotes a recursive implementation
```
- **fadd_tb.v**: The testbench for the full adder module.
- **fadd.v**: The full adder module that orchestrates the addition process.
- **Sum.v**: Module responsible for calculating the sum of the inputs.
- **CLA.v**: Core carry-lookahead module.
- **PGxGen.v**: Module responsible for generating propagate (P) and generate (G) signals across recursive levels.
- **PGGen.v**: Module for generating propagate (P) and generate (G) signals of inputs.
- **CarryGen.v**: Module for generating carry bits based on propagate (P) and generate (G) signals.


