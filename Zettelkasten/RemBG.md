### Database schema
- User uploads
- Image processing status
- URLs for original and processed images
- Timestamps for tracking
---
### **Tables**

#### 1. `users`

| Column Name | Data Type  | Constraints               | Description            |
| ----------- | ---------- | ------------------------- | ---------------------- |
| id          | UUID / INT | PK                        | Unique user identifier |
| email       | VARCHAR    | UNIQUE, NOT NULL          | User email             |
| created_at  | TIMESTAMP  | DEFAULT CURRENT_TIMESTAMP | Account creation time  |

---

#### 2. `images`

|Column Name|Data Type|Constraints|Description|
|---|---|---|---|
|id|UUID / INT|PK|Unique image identifier|
|user_id|UUID / INT|FK → users(id), nullable|Owner of the image (if user-based system)|
|original_url|TEXT|NOT NULL|S3 URL for uploaded original image|
|processed_url|TEXT|NULLABLE|S3 URL for processed (background removed) image|
|status|VARCHAR|DEFAULT 'pending'|Enum: 'pending', 'processing', 'done', 'failed'|
|error_message|TEXT|NULLABLE|Error info in case of failure|
|created_at|TIMESTAMP|DEFAULT CURRENT_TIMESTAMP|Upload time|
|processed_at|TIMESTAMP|NULLABLE|Time background removal completed|

---

### Notes:

- **Status field** helps your backend know whether the image is still being processed.
- **original_url** and **processed_url** are pointers to S3 objects (e.g., presigned URLs).
- If you have **no user accounts**, you can skip the `users` table.
- Index `status`, `created_at`, and `user_id` (if exists) for query performance.
- ---
### TypeORM configuration
```ts
export class User{
  @PrimaryGeneratedColumn()
  id: number
  @Column({unique: true})
  email: string
  @OneToMany
  
}
```
```ts
export class Image{
  @PrimaryGeneratedColumn()
  id: number
  @Column()
  original_url: string
  @Column()
  processed_url: string
  @Column()
  status: string
  @Column({nullable: true})
  error_message: string
  @ManyToOne(()=> User, (user)=> user.id)
  user: User
  
}
```