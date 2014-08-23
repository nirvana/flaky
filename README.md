FLAKY
======

Flake implemented in Elixir.

Flaky is an OTP app that issues unique, ordered keys as a service.  
It is a re-implementation of boundary's flake designed to be more easily embedded in projects.
Do note, however, that you should be running only one such service per machine. (or technically,
per network port MAC address since the MAC address is part of the key)

## API
```
	# generate(base) => returns a flake in the given base
	Flaky.generate(16) => 1480497347FB8F6B1118F650000
	
	# numeric() and alpha() are conveniences for base 10 and 62.
	Flaky.numeric => 25725046379886392965847027351552
	Flaky.alpha => 8hcWWAPPrayb5DuwML
```

As an OTP app, it responds to gen_server calls, for either :generate or {:generate, Base}  
The former will return flakes in base 10, and the latter in whatever base you pass it,
between 2 and 62.

## Example

```
$ iex -S mix
Erlang/OTP 17 [erts-6.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (0.15.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Flaky.generate(5)
"424122044124414241030213141324120301211234042"
iex(2)> Flaky.generate(10)
"25988255635718314112604438855680"
iex(3)> Flaky.generate(16)
"1480495539AB8F6B1118F650000"
iex(4)> Flaky.generate(62)
"8n8q3r3d3LjEzMdEoa"
iex(5)> Flaky.alpha
"8n8q4QNhihaEXlIGSu"
iex(6)> Flaky.numeric
"25988256081889713023417363791872"
iex(7)>
```

## Further Reading

See the blog post: http://boundary.com/blog/2012/01/12/flake-a-decentralized-k-ordered-unique-id-generator-in-erlang/

... and the erlang version (which has more details):  https://github.com/boundary/flake
