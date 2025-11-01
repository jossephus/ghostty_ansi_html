import { NewConvert, convert as convertLib } from "./binding";

export class Convert {
	private converter;

	constructor() {
		this.converter = NewConvert();
	}

	convert(input: string) {
		const buffer = Buffer.from(input + "\0");
		const result = convertLib(this.converter, buffer);
		return result.toString();
	}
}
