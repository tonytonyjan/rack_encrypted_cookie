## `ActionDispatch::Session::CookieStore`

```
+-------------------- uri encode --------------------+
| +------------ base64 ------------+      +-- hex -+ |
| | +- base64 -+      +- base64 -+ |      |        | |
| | |   json   | "--" |    iv    | | "--" |  hmac  | |
| | +----------+      +----------+ |      |        | |
| +--------------------------------+      +--------+ |
+----------------------------------------------------+
```

## `Rack::Session::Cookie`

```
+--------- uri encode ----------+
| +-- base64 -+      +-- hex -+ |
| |  marshal  | "--" |  hmac  | |
| +-----------+      +--------+ |
+-------------------------------+
```
