import { NewConvert, convert as convertLib } from "./binding";

export class Convert {
	private converter;

	constructor() {
		this.converter = NewConvert();
	}

	convert(input: string) {
		if (typeof Bun !== "undefined") {
			const buffer = Buffer.from(input + "\x00");
			const result = convertLib(this.converter, buffer);
			return result.toString();
		} else {
			return convertLib(this.converter, input);
		}
	}
}
