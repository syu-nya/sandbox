BEGIN {
	split(ENVIRON["SYMBOLS"], SYMBOLS);
}

{
	for (x in SYMBOLS) {
		sym_regex = "^" SYMBOLS[x] "(@|$)"
		if ($8 ~ sym_regex) {
			split($8, symbol_array, /@|@@/);

			# Handle non-versioned libc's like uClibc ...
			if (!symbol_array[2])
				symbol_array[2] = "";

			SYMBOL_LIST[symbol_array[2]] = SYMBOL_LIST[symbol_array[2]] " " symbol_array[1];
		}
	}
}

END {
	for (sym_version in SYMBOL_LIST) {
		if (sym_version)
			VERSIONS = VERSIONS " " sym_version;
	}

	# We need the symbol versions sorted alphabetically ...
	if (VERSIONS) {
		split(VERSIONS, VERSION_LIST);
		COUNT = asort(VERSION_LIST);
	} else {
		# Handle non-versioned libc's like uClibc ...
		COUNT = 1;
	}
	
	for (i = 1; i <= COUNT; i++) {
		if (VERSION_LIST[i]) {
			sym_version = VERSION_LIST[i];
			printf("%s {\n", sym_version);
		} else {
			# Handle non-versioned libc's like uClibc ...
			sym_version = "";
			printf("{\n");
		}
		
		printf("  global:\n");
		
		split(SYMBOL_LIST[sym_version], sym_names);
		
		for (x in sym_names)
			printf("    %s;\n", sym_names[x]);
		
		if (!old_sym_version) {
			printf("  local:\n");
			printf("    *;\n");
			printf("};\n");
		} else {
			printf("} %s;\n", old_sym_version);
		}
		
		old_sym_version = sym_version;
	}
}