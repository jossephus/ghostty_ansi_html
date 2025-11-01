let libPath = `./dist/libghostty-ansi-html.${
	typeof Bun !== "undefined" ? "" : "node"
}`;

let NewConvert;
let convert;

if (typeof Bun !== "undefined") {
	// use bun's ffi if we are running through bun
	const { suffix, dlopen, FFIType } = await import("bun:ffi");

	libPath = `${libPath}${suffix}`;
	const {
		symbols: { NewConvert: newConvert, convert: conv },
	} = dlopen(libPath, {
		NewConvert: { args: [], returns: "ptr" },
		convert: { args: ["ptr", FFIType.cstring], returns: FFIType.cstring },
	});

	NewConvert = newConvert;
	convert = conv;
} else {
	// use node's api if we are on node.
	const mod = { exports: { NewConvert: {}, convert: {} } };
	process.dlopen(mod, libPath);

	({ NewConvert, convert } = mod.exports);
}

export { NewConvert, convert };
