const module = await import("./libghostty-ansi-html.so", {
	with: { type: "file" },
});
const path = module.default;
export default path;
