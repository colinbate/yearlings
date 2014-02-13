# YEARLINGS

A port of a game I wrote in CorelScript (yes that existed) back in 1997. It was a clumsy RPG that I released under the "company" of RPGenius. :)

I've tried to recreate it in JavaScript.

It should be fairly faithful to the original, which is available in the `original/yearling.CSC` file.

Button text updates on the button itself instead of just having them labeled 1 to 6 and providing a key in the text. Otherwise, things should be pretty similar. I'm probably going to fork a version which is more playable.

To install from the repository you'll need `node.js`, `npm` and `grunt` installed. Just type `npm install` and when that is complete, you need to run `grunt install`. You can run a webserver with `grunt play`.

You should be able to play it at `http://localhost:8059`. If you want to play through without worrying about dying, then add an `?assist` to the end of the URL.

You can also play the game at http://colinbate.bitbucket.org/yearlings/