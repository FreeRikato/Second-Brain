# Differentiating Active Record vs Data Mapper

| Aspect      | Active Record     | Data Mapper              |
| ----------- | ----------------- | ------------------------ |
| DB logic    | Inside model      | In separate repositories |
| Model       | Smart             | Dumb                     |
| Testability | Harder            | Easier                   |
| Setup       | Easier            | More boilerplate         |
| Use case    | Small/simple apps | Large/complex apps       |
**Active Record**: The model (entity class) itself is responsible for both holding data and handling database operations.
> Key Characteristics:
- Your model _is aware_ of the database.
- All DB logic (like `save()`, `remove()`, `find()`) is _inside_ the model class.
- Easy to use; less boilerplate code.
 ✅ Pros:
- Simple and fast to set up.
- Great for **small projects** or **rapid prototyping**.
- No need to create separate repository files.
 ❌ Cons:
- Tight coupling between database logic and business logic.
- Harder to unit test (since DB operations are inside the model).
- Doesn’t scale well in complex domains.

**Data Mapper**: The model (entity class) is only a data container. All DB operations are handled by repositories (external to the model).
> Key Characteristics:

- Your model is _dumb_ — it knows nothing about the DB.
- You use `Repository` or `EntityManager` to interact with the DB.
- Separates concerns: business logic vs data access.
 ✅ Pros:
- More **maintainable** and **testable**.
- Scales better for **large applications** with complex business rules.
- Encourages **clean architecture** and **separation of concerns**.
 ❌ Cons:
- More boilerplate.
- Slightly steeper learning curve.
- Slower to write initially.

>Example Use Case:

1. Create and save a new user
2. Fetch users by name
3. Delete a user

## Active Record
```ts
import { BaseEntity, Entity, PrimaryGeneratedColumn, Column } from "typeorm"

@Entity()
export class User extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number

    @Column()
    firstName: string

    @Column()
    lastName: string

    static findByName(firstName: string, lastName: string) {
        return this.createQueryBuilder("user")
            .where("user.firstName = :firstName", { firstName })
            .andWhere("user.lastName = :lastName", { lastName })
            .getMany()
    }
}
```
```ts
// Create and save
const user = new User()
user.firstName = "Alice"
user.lastName = "Smith"
await user.save()

// Fetch users by name
const alices = await User.findByName("Alice", "Smith")

// Delete
await user.remove()
```
## Data Mapper
```ts
import { Entity, PrimaryGeneratedColumn, Column } from "typeorm"

@Entity()
export class User {
    @PrimaryGeneratedColumn()
    id: number

    @Column()
    firstName: string

    @Column()
    lastName: string
}
```
```ts
import { DataSource } from "typeorm"
import { User } from "./User"

export const userRepository = dataSource.getRepository(User).extend({
    async findByName(firstName: string, lastName: string) {
        return this.createQueryBuilder("user")
            .where("user.firstName = :firstName", { firstName })
            .andWhere("user.lastName = :lastName", { lastName })
            .getMany()
    }
})
```
```ts
// Create and save
const user = new User()
user.firstName = "Alice"
user.lastName = "Smith"
await userRepository.save(user)

// Fetch users by name
const alices = await userRepository.findByName("Alice", "Smith")

// Delete
await userRepository.remove(user)
```