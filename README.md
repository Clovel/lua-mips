# lua-mips

This repositry contains an implementation of the MIPS processor achitecture in MIPS, used tio simulate the processor's behavior for educational purposes. 
It takes as an input a MIPS assembly program, translates it & interprets it. 

## Contents
### Tests

This directory contains a test Lua script to get familiar with the language. 

### Sources

This directory contains the sources of the MIPS processor simulator. 

To use it : 
```bash
cd src
lua mips.lua ../translator/program.txt
```

### Translator

This directory contains the sources of the assembly to bitcode translator.

To use it : 
```bash
cd translator
lua translate.lua ../data/program.txt
```

This outputs a `program.dat` file containit the bitcode. 

### Data

This directory contains an example of MIPS assembly code. 

# References

1. Programming in Lua, Roberto Ierusalimschy, Lua.org, January 2013, ISBN 859037985X
2. MIPS Instruction Reference : http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html
3. MIPS Instruction Set : https://en.wikipedia.org/wiki/MIPS_instruction_set