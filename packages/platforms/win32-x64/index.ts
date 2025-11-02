const module = await import("./ghostty-ansi-html.dll", {
	with: { type: "file" },
});
const path = module.default;
export default path;
