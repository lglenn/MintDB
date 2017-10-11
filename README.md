# MintDB

Do lightweight ad-hoc analysis of your personal finances with a  simple docker-based mysql database created from a mint.com transaction export.

## Prerequisites

You'll need docker, perl, and make.

## Usage

Export a bunch of transactions as CSV at mint.com, make sure they're in a file named `transactions.csv`.

Stick that file in the MintDB directory.

In the MintDB directory, run make. That will: 

* Transform the data in `transactions.csv` into SQL inserts in a file named `account.sql`
* Create a docker container running mysql
* Load `account.sql` into a table named `account` in the database `budget`. The database is stored in `./data`.
* Create a second docker container running a mysql client, connected to the mysql server.


