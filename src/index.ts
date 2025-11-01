import { NewConvert, convert as convertLib } from "./binding";

export class Convert {
	private converter;

	constructor() {
		this.converter = NewConvert();
	}

	convert(input: string) {
		if (typeof Bun !== "undefined") {
			const buffer = Buffer.from(input + "\x00");
			return convertLib(this.converter, buffer);
		} else {
			return convertLib(this.converter, input);
		}
	}
}
