const module = await import("./libghostty-ansi-html.dylib", {
  with: { type: "file" },
});
const path = module.default;
export default path;

