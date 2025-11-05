import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));
const path = resolve(__dirname, "./libghostty-ansi-html-windows.node");

export default path;
