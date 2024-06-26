# rtrace.sh - HTTP redirection tracer

rtrace.sh is designed to trace HTTP redirects
of a given URL. It utilizes `curl CLI` to send
a series of `HEAD requests`, following redirects until
reaching the final destination.

## Usage

- Command: 
```bash
bash rtrace.sh -u https://targetURI/
```

- Output
```txt
Sending HEAD request to: http://targetURI

[301] http://targetURI
[301] https://targetURI/
[200] https://www.targetURI/

Done, Redirects: 2
```

## LICENSE
These scripts are published under the [MIT](https://github.com/fhAnso/rtrace/blob/main/LICENSE) license.