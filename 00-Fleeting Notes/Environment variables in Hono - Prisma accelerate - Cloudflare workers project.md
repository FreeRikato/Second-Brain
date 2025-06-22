The basic template from [[Hono]] <> [[Cloudflare workers]] project contains `wrangler.toml`. Upon initializing [[Prisma]], we get `.env` file. 

Now, there arises a question of where to store the [[Prisma accelerate]]'s API token that is enabled for [[Connection pooling]] of the Cloudflare workers and Postgres (Cloud DB provider such as Aiven or Neon) environment variable

1. [[Prisma accelerate]] API Token
2. Postgres Environment variable

| Environment variable          | Stored in                                    | Reason                                                                                                                                                                             |
| ----------------------------- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Prisma Accelerate API Token   | wrangler.toml in DATABASE_URL under `[vars]` | For the cloudflare workers to use the Connection pooling since a number of workers trying to access the DB would result in overload                                                |
| Postgres Environment variable | .env in DATABASE_URL                         | To migrate the DB and generate prisma client from the terminal,  the DB can be accessed directly since this does not involve the cloudflare workers and happens only one at a time |
