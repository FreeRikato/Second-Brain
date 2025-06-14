We use ORM to address the Object-relational impedance mismatch. ORM stands for **Object relational mapping**. 

It is a layer that maps database tables to typescript classes and rows to instances translating object operations into sql queries.

## Why use TypeORM?
- Fully written in Typescript
- Supports PostgreSQL, MySQL, SQLite, SQL Server and MongoDB
- Provides decorators to define Models
- Comes with a CLI for running migrations and generating boilerplate

## Installing npm dependencies for TypeORM
```bash
npm install typeorm reflect-metadata
```

> 🚨 Important: Configure tsconfig.json with especially three settings
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true
  },
  "include": ["src/**/*"]
}
```

The CLI can help with:
- Running migrations
- Generating entities
- Creating database schema
- Synchronizing schema
Also, extend CLI settings in `data-source.ts`

TypeORM supports both Active Record and Data Mapper patterns -
[[Active Record vs Data Mapper]]

> An **entity** is a class that maps to a table in the database, Decorators (@Entity, @Column, etc.)  are used to describe how class properties map to database fields

=> Keep schema in sync with TypeScript types
=> Automatically creates tables or run migrations

## Postgres setup with data-source.ts
```bash
npm install pg
```
```ts
import { DataSource } from "typeorm";
import { User } from "./entity/User";
import { Post } from "./entity/Post";

export const AppDataSource = new DataSource({
  type: "postgres",
  host: "localhost",
  port: 5432,
  username: "your_pg_user",
  password: "your_pg_password",
  database: "your_pg_database",
  synchronize: true, // aut-generates schema (only use in development)
  logging: false,
  entities: [User, Post],
});
```

## Entity creation
```ts
// src/entity/User.ts
import { Entity, PrimaryGeneratedColumn, Column } from "typeorm";

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ unique: true })
  email: string;

  @Column({ default: true })
  isActive: boolean;
}
// src/entity/Post.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from "typeorm";
import { User } from "./User";

@Entity()
export class Post {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column("text")
  content: string;

  @ManyToOne(() => User, (user) => user.id)
  author: User;
}
```

## Basic CRUD with repository and data source
```ts
import "reflect-metadata";
import { AppDataSource } from "./data-source";
import { User } from "./entity/User";
import { Post } from "./entity/Post";

AppDataSource.initialize().then(async () => {
  console.log("Database connected");

  const userRepo = AppDataSource.getRepository(User);
  const postRepo = AppDataSource.getRepository(Post);

  // CREATE
  const user = userRepo.create({ name: "Alice", email: "alice@example.com" });
  await userRepo.save(user);

  const post = postRepo.create({
    title: "Hello TypeORM",
    content: "This is a post using TypeORM.",
    author: user,
  });
  await postRepo.save(post);

  // READ
  const users = await userRepo.find({ relations: ["posts"] });
  console.log("All users:", users);

  const posts = await postRepo.find({ relations: ["author"] });
  console.log("All posts:", posts);

  // UPDATE
  user.name = "Alice Updated";
  await userRepo.save(user);

  // DELETE
  // await userRepo.remove(user);

}).catch((error) => console.log(error));
```
## Seeding dummy data 
```ts
// seed.ts
import { AppDataSource } from "./data-source";
import { User } from "./entity/User";
import { Post } from "./entity/Post";

AppDataSource.initialize().then(async () => {
  const userRepo = AppDataSource.getRepository(User);
  const postRepo = AppDataSource.getRepository(Post);

  for (let i = 1; i <= 3; i++) {
    const user = userRepo.create({
      name: `User${i}`,
      email: `user${i}@example.com`,
    });
    await userRepo.save(user);

    for (let j = 1; j <= 2; j++) {
      const post = postRepo.create({
        title: `Post ${j} by User${i}`,
        content: `Content for post ${j}`,
        user,
      });
      await postRepo.save(post);
    }
  }

  console.log("Seeding done.");
});
```