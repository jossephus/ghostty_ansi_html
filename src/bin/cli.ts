#!/usr/bin/env bun
import { Convert } from "../index";

const converter = new Convert();
const input = process.argv[2] || "";

if (input) {
	console.log(converter.convert(input));
} else {
	process.stdin.setEncoding("utf8");
	let data = "";
	process.stdin.on("data", (chunk) => (data += chunk));
	process.stdin.on("end", () => {
		console.log(converter.convert(data));
	});
}
