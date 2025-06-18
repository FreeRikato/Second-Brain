In a relational database, relationships are the connections between different tables that are established using **foreign keys**, where a column in one table references the primary key of another

> This is done in TypeORM with special decorators, the abstraction is said to simplify (NOT!!!) database interactions and helps maintain a clear structure in the data layer.

## Primary types of relationships
1. **One to One (1:1)**: Single record in one entity is related to a single record in another entity => `User` has one `Profile`
2. **One to Many (1:N)**: Single record in one entity can be related to multiple records in another entity => `User` as multiple `Posts`
3. **Many to One (N:1)**: Multiple records in one entity can be related to a single record in another => Many `Posts` belong to one `User`
4. **Many to Many (N:M)**: Multiple records in one entity can be related to multiple records in another => `Student` can enroll in many `Courses` and `Course` has multiple `Students`

## Uni-directional vs Bi-directional

Both entities should have a property to access the other. If we only had a
property from one entity to link other entity it would be a uni-directional
relationship. For most cases, bi-directional relationships are more flexible.

## One-to-One (1:1) Relationships
- Entity A is linked to exactly one instance of Entity B and vice-versa

> Considering a `User` and a `Profile`. A user has only one profile, and a profile belongs to only one user. 

### The Logic (Who needs the foreign key?):
This one is kind of tricky since both could hold the other's id. The choice has to be made on who is the "owner" of the relationship? A good rule of thumb is to ask: "Which entity is less meaningful on its own?"

A `Profile` (with gender, photo, etc.) is pretty useless without a `User`. A
`User` could exist without a `Profile`. So, let's make Profile hold the User's
id. In Conclusion, Profile entity gets the foreign key.

```ts
// src/entity/User.ts

import {Entity, PrimaryGeneratedColumn, Column, OneToOne} from "typeorm"
import {Profile} from "./Profile"

@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    // "I have a one-to-one link with a Profile"
    // "To find it, look at the 'user' property on the Profile entity"
    // NO column is created here. This is a virtual helper.
    @OneToOne(() => Profile, profile => profile.user)
    // Specify inverse as a second parameter
    profile: Profile;
}

```
```ts
// src/entity/Profile.ts

import {Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn} from "typeorm"
import {User} from "./User"

@Entity()
export class Profile {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    gender: string;

    @Column()
    photo: string;

    // "I am linked one-to-one with a User"
    @OneToOne(() => User, user => user.profile)
    // AND... "I will be the one to hold the foreign key. 
    // Create a 'userId' column in my table."
    @JoinColumn()
    // Marks this side of the relation as the owner
    user: User;
}
```

- @OneToOne Decorator: The decorator i used on both sides of the relationship to define it.
- @JoinColumn Decorator: This is a crucial decorator that must be placed on only one side of the relationship. The entity that has the @JoinColumn will be the "owning" side and its table in the database will contain the foreign key. In above example, the `profile` table will have a `userId` column.

## One-to-Many (1:N) and Many-to-One (N:1) Relationships
> A single record in one table can be associated with multiple records in
> another.

> - A `User` can have many `Posts`.
> - A `Post` can only belong to one `User`

- The `User` need not know the specific ID of every single post they've ever
written, stored directly in their own `user` table row.
- The `Post` need to know who its `User` is, The `Post` is meaningless without
its author.
- In Conclusion, The `Post` entity gets the foreign key

> 🚨 The entity that gets the foreign key is the one with the @ManyToOne
> decorator.

Considering the example of a `User` who can publish many `Posts`

```ts
// src/entity/User.ts
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from "typeorm"
import { Post } from "./Post"

@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    // "I am ONE User who has a relationship with MANY Posts."
    // "To find them, look at the 'user' property on the Post entity."
    @OneToMany(() => Posts, post => post.user)
    posts: Posts[]
}
```
```ts
// src/entity/Post.ts
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from "typeorm"
import { User } from "./User"

@Entity()
export class Post {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    title: string;

    @Column("text")
    content: string

    // "I need to know who my User is. Create a 'userId' column
    // The @OneToMany is just a virtual helper for TypeORM (user.posts)
    // The @ManyToOne does the real database work 
    @ManyToOne(() => User, user => user.posts)
    user: User
}
```

- @OneToMany: The decorator defines the "one" side of the relationship. It
signifies that a `User` can have an array of `Posts`.
- @ManyToOne: The decorator is on the "many" side. Many `Posts` can belong to a single `User`. The table for the entity with the @ManyToOne decorator will store the foreign key.
- Inverse Relationship: @OneToMany cannot exist without a @ManyToOne on the
other side. The second argument to the decorator function is crucial for TypeORM to understand how the two entities are linked
