import { dlopen, FFIType, suffix } from "bun:ffi";

const path = `./lib/zig-out/lib/libghostty-ansi-html.so`;
console.log(path);

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
