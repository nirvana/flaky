FLAKY
======

Flake implemented in Elixir.

Flaky is an OTP app that issues unique, ordered keys as a service.  
It is a re-implementation of boundary's flake designed to be more easily embedded in projects. 
Do note, however, that you should be running only one such service per machine. (or technically,
per network port MAC address since the MAC address is part of the key)

