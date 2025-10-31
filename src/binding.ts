import { dlopen, FFIType, suffix } from "bun:ffi";

const path = `${import.meta.dir}/../dist/libghostty-ansi-html.${suffix}`;

export const {
	symbols: { NewConvert, convert },
} = dlopen(path, {
	NewConvert: {
		args: [],
		returns: "usize",
	},
	convert: {
		args: ["usize", FFIType.cstring],
		returns: FFIType.cstring,
	},
});
