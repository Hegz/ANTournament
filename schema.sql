create table if not exists identities (
  id integer primary key,
  title string not null,
  faction string not null,
  side string not null
);
