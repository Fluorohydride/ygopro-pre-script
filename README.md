# ygopro-pre-script

Repository intended to store all the relevant information for adding pre-release cards into YGOPro. The objective is to standarize the process of adding these cards among many YGOPro systems. Currently, each group develops their own pre-release cards independently, each with different IDs, scripts and often also different setcodes; they also tend to have different bugs and inaccuracies. Everyone who wishes may contribute to this repo by adding scripts, IDs, setcodes, SQL scripts to insert the cards and bugfixes. Cards that have been released and their scripts availible in the Fluorohydride git should be removed from this repo.


# Contributing
* For fairness, we'll use a modified version of the @YGOHack and Devpro placeholder ID setting. We will use the unique prefix "`100`" at the start of each ID. Followed by the 3-digit booster pack Order Number (can be found on wikia), followed by their 3-digit set numbers, as listed below the artwork. The resulting IDs will be 9 digits, easily grouped together and in proper order when sorted alphabetically. If the Order Number value isn't provided (like in structure decks), use any number between `100` and `500`, which should be consistent among all cards in the same set. **DO NOT CHANGE A CARD ID ONCE IT HAS BEEN ALREADY ADDED**. It is very troublesome when a card has to be renamed, this is more important than proper accuracy on the ID.

* `sets.md` will contain a list of the currently unreleased packs/sets next to the 6 digit ID prefix that the cards will use. Example for Breaker of Shadow: `100907XXX`.

* Scripts Folder contains all the `.lua` files for pre-release vards, following the typical YGOPro convention. If any bugs are found, you can make submit an Issue about it or commit the proper fixes. You may add credit for a card you made, if you wish.

* `strings.conf` file is used to register the setcodes of pre-release cards that require one that doesn't already exist (they are at the bottom). You may choose any legal value for the setcode, though a 2 digit one is preferable; if possible, try to pick the one that will be the final setcode on release (increases by 1 each new archetype, in order of release). Determining a setcode will be on a first-come first-sever basis, whoever makes the cards first gets to pick it and it will not change until release. Every contributor is responsible for making sure their scripts and SQL conform to the setcode indicated in this file.
**Remember the standard is to use the japanese archetype name**.

* The `inserts.sql` file is used to keep the SQL code used to quickly add all the current pre-release cards into a .cdb database. Each card should be 2 lines, one for the `DATAS` table and one for `TEXTS`. The cards should be grouped by their set/pack, with a proper comment indicating the name heading each section. ( `--` for comments in SQL) This file can also be used to find the ID of a card by searching the name, if you are unsure.


# Licence

Copyright (c) 2016-2023 Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

