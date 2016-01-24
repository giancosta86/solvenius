# Solvenius

*Functional reactive HTML 5 logic game*


## Introduction

Long ago, in 2001, I created the very first version of Solvenius: it was a simple videogame, written in Visual Basic 6, but still contained most of the game dynamics - in particular, the user had to deduce sequences of digits, à la Mastermind.

About fifteen years later, I discovered [Elm](http://elm-lang.org/), a functional reactive programming language: after the initial difficulties due to the new paradigm, I was definitely excited about the actual simplicity and the well-structured nature of the Elm architecture, so I wanted to try it on a project I knew very well - why not Solvenius?

This new version of Solvenius employs not only Elm, but also CSS 3 (especially the brilliant *flex* layout and *media queries*), to further decouple model and view and dramatically increase portability.

I hope you will enjoy this latest version of Solvenius! ^\_\_^


## Running the game

Solvenius is an HTML 5 game - which makes it compatible with a wide range of devices.

You can run it just by pointing your web browser to:

[http://giancosta86.github.io/solvenius](http://giancosta86.github.io/solvenius)


## Online help

The game is fairly straightforward - but you can find detailed instructions in the online help, accessible from the title screen.


## Frequently asked questions

* **What's new in this major version?**

  * Solvenius is now an HTML 5 game, running on several operating systems and devices! ^\_\_^

  * The formulas underlying score and time gains are totally new, to make the game more interesting

  * People that cannot distinguish some colors can play comfortably, as feedback sequences also employ text styles, not only colors

  * Last but not least, Solvenius 3 is based on a radically new development paradigm: functional programming! ^\_\_^


* **What about the top score ladder?**

  Solvenius is now open source and cannot store secret credentials to cloud services - therefore, for simplicity, the online top score ladder has been replaced by your current top score on the browser - which is backed by HTML 5 storage.


## Music credits

  * "Winner Winner!" Kevin MacLeod (incompetech.com) Licensed under Creative Commons: By Attribution 3.0 License http://creativecommons.org/licenses/by/3.0/

**NOTE**: the original MP3 has been compressed when creating the game.



## Special thanks

The author would like to thank - in order by surname:

* *Alberto La Mantia*: for suggesting that game clues on sequence attempts should employ not only colors but also other visual elements

* *Kevin MacLeod* (incompetech.com) for the excellent soundtrack

* *Paolo Tagliapietra*: for his suggestions on the previous version (Solvenius 2), for which he also created the Windows Phone version and hosted the on-cloud top score ladder



## Further references

* [Elm programming language](http://elm-lang.org/)

* [HTML 5](https://www.w3.org/TR/html5/)

* [CSS 3](http://www.css3.info/)

* [Media queries](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries)

* [Solvenius - Facebook page](https://www.facebook.com/solvenius)
