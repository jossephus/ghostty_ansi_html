import { dlopen, FFIType, suffix } from "bun:ffi";

const path = `dist/libghostty-ansi-html.${suffix}`;
console.log("Path:", path);

try {
  const lib = dlopen(path, {
    NewConvert: {
      args: [],
      returns: "usize",
    },
    convert: {
      args: ["usize", FFIType.cstring],
      returns: FFIType.cstring,
    },
  });
  console.log("Success:", lib);
} catch (e) {
  console.log("Error:", e);
}
