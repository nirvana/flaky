FLAKY
======

Flake implemented in Elixir.

Flaky is an OTP app that issues unique, ordered keys as a service.  
It is a re-implementation of boundary's flake designed to be more easily embedded in projects. 
Do note, however, that you should be running only one such service per machine. (or technically,
per network port MAC address since the MAC address is part of the key)

```
**Note:** This configuration presumes you have an ethernet device named 'en0'
you will want to update this in mix.exs with your correct ethernet device name.

Feel free to add some config file parsing if you wish. Preferably in Elixir, maybe using exconfig?
I would be happy to recieve such a pull request!
```
## Status

Believed to be working correctly. Seems damn fast.
The original Flake is used in production and stable, but this re-implementation, while trying to follow their methods exactly may have errors. I would recommend testing this or at least reviewing the code before putting into production!

## API

```
	Flaky.numeric => 25725046379886392965847027351552
	Flaky.alpha => 8hcWWAPPrayb5DuwML
```

As an OTP app, it responds to gen_server calls, for either :get or {:get, Base}  The former will
return flakes in base 10, and the latter in whatever base you pass it, between 2 and 62.

## Example

```
iex(3)> Flaky.test
 Flake, base 10:25169134539683400779552431276032
 Flake, base 62:8VxXJXgBJFc4b9Ygd7
Time to generate 100000 flakes: 1074 milliseconds.
:ok
iex(4)> :gen_server.call(:flaky, :get)
"25169137199058260165889939996672"
iex(5)> :gen_server.call(:flaky, {:get, 62})
"8VxXXbGSmDATluESbg"
```

## Further Reading

See the blog post: http://boundary.com/blog/2012/01/12/flake-a-decentralized-k-ordered-unique-id-generator-in-erlang/

... and the erlang version (which has more details):  https://github.com/boundary/flake