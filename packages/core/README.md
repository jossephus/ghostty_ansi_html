# ghostty-ansi-html

Terminal ansi to html convertor that uses libghostty-vt. 

libghostty recently added functionality to encode terminal contents to HTML [tweet](https://x.com/mitchellh/status/1983750133704749496). This npm package uses libghostty to encode terminal contents to HTML.

You can use it either as a library or as a binary to encode your terminal outputs in real time.

### Init

You can use your favorite package manager to install ghostty-ansi-html.

```sh
bun add ghostty-ansi-html
```

#### Usage 
The library is small and its designed to be similar to [ansi-to-html](https://www.npmjs.com/package/ansi-to-html). 

```
import { Convert } from "ghostty-ansi-html";

var convert = new Convert();

console.log(convert.convert("\x1b[30mblack\x1b[37mwhite'"));
```

### Use It as Binary
You can use it as bin using bunx/npx. You can see your terminal outputs using 
```
neofetch | bun x ghostty-ansi-html
```

### Sample

<p align="center">
  <img src="./assets/term.png" width="280" style="margin-right: 40px;"/>
  <img src="./assets/rendered.png" width="280"/>
</p>

