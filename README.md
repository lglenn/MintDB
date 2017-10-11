# MintDB

Do lightweight ad-hoc analysis of your personal finances with a  simple docker-based mysql database created from a mint.com transaction export.

This is not intended to be a place to store your accounts long-term; each import will overwrite everything that's in the database. It's good for figuring out how the heck you spent every last penny that came in the door last month.

## Prerequisites

You'll need docker, perl, and make, and of course some familiarity with SQL.

## Usage

Export a bunch of transactions as CSV at mint.com, make sure they're in a file named `transactions.csv`.

Stick that file in the MintDB directory.

In the MintDB directory, run make. That will: 

* Transform the data in `transactions.csv` into SQL inserts in a file named `account.sql`.
* Create a docker container running a mysql server.
* Load `account.sql` into a table named `account` in the database `budget`. The database is stored in `./data`.
* Create a second docker container running a mysql client, connected to the mysql server.

You'll have a mysql shell running. Query away.
