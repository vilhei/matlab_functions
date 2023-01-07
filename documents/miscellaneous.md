<!-- omit in toc -->
# Miscellaneous

This document consists of miscellaneous stuff related to matlab

- [Vscode](#vscode)
  - [Extensions](#extensions)
  - [Snippets](#snippets)

## Vscode

### Extensions

Extensions I use to code Matlab with Vscode.
Working Matlab license and installation is still needed.
Debugging not really there so I usually code with Vscode and then run the programs with Matlab editor.

- Matlab (Gimly81.matlab)
- Matlab Extension Pack (bat67.matlab-extension-pack)
- Matlab Interactive Terminal (apommel.matlab-interactive-terminal)
- matlab-formatter (AffenWiesel.matlab-formatter)
- Matlabsnippets (Slaier.matlab-complete)

### Snippets

Class snippet I like to use.

```Json
"class": {
		"prefix": [
			"cls",
			"class"
		],
		"body": [
			"classdef ${1:$TM_FILENAME_BASE} < handle",
			"\t%${1:$TM_FILENAME_BASE} Summary of this class goes here",
			"\t%   Detailed explanation goes here",
			"\t%",
			"\t% $TM_FILENAME_BASE Properties:",
			"\t%",
			"\t% $TM_FILENAME_BASE Methods:",
			"\t%",
			"\t%   $CURRENT_MONTH_NAME $CURRENT_YEAR",
			"\t%   FirstName LastName\n",
			"\tproperties (Access = public)",
			"\t\tProperty1",
			"\tend\n",
			"\tmethods (Access = public)",
			"\t\tfunction obj = ${1:$TM_FILENAME_BASE}(inputArg1, inputArg2)",
			"\t\t\t%${1:$TM_FILENAME_BASE} Construct an instance of this class",
			"\t\t\t%   Detailed explanation goes here\n",
			"\t\t\tobj.Property1 = inputArg1 + inputArg2;\n",
			"\t\tend\n",
			"\t\tfunction outputArg = method1(obj, inputArg)",
			"\t\t\t%METHOD1 Summary of this method goes here",
			"\t\t\t%   Detailed explanation goes here\n",
			"\t\t\toutputArg = obj.Property1 + inputArg;\n",
			"\t\tend",
			"\tend\n",
			"\tproperties (Access = private)\n",
			"\tend\n",
			"\tmethods (Access = private)\n",
			"\tend",
			"end\n"
		],
		"description": "Creates class template with date and signature"
	},
```
