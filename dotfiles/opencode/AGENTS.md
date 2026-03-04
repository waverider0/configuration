# coding style (carmack, tinygrad, jblow)
* 2 space indents, max 200 chars per line
* do not be afraid of your code
* do not hide nastiness with abstraction "bandaids"
* comments frequently fall out of sync with the actual code as it changes, eventually becoming misleading or outright lies. write self-documenting code with clear naming and structure so that the "what" and "how" are obvious from the executable code itself
* prefer clear_descriptive_variable_names over short uninformative ones
* prefer specificity over generality
* prefer a small number of large inlined functions over a million tiny helpers
* prefer maintainable "always-correct/simple" code over brittle micro-optimizations
* minimize conceptual complexity, keep code hackable, avoid cleverness
* prioritize clarity, simplicity, and productivity
