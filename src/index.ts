import { NewConvert, convert as convertLib } from "./binding";

export class Convert {
	private converter;

	constructor() {
		this.converter = NewConvert();
	}

	convert(input: string) {
		const buffer = Buffer.from(input + "\0");
		return convertLib(this.converter, buffer);
	}
}
