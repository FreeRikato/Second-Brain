### Error 1:
```
> ChatRoom@0.0.1 start
> ts-node src/index.ts

Error: Cannot find module '/Users/aravinthan/Developer/work/ChatRoom/src/data-source' imported from /Users/aravinthan/Developer/work/ChatRoom/src/index.ts
    at finalizeResolution (node:internal/modules/esm/resolve:275:11)
    at moduleResolve (node:internal/modules/esm/resolve:860:10)
    at defaultResolve (node:internal/modules/esm/resolve:984:11)
    at ModuleLoader.defaultResolve (node:internal/modules/esm/loader:716:12)
    at ModuleLoader.#cachedDefaultResolve (node:internal/modules/esm/loader:640:25)
    at ModuleLoader.resolve (node:internal/modules/esm/loader:623:38)
    at ModuleLoader.getModuleJobForImport (node:internal/modules/esm/loader:276:38)
    at ModuleJob._link (node:internal/modules/esm/module_job:136:49) {
  code: 'ERR_MODULE_NOT_FOUND',
  url: 'file:///Users/aravinthan/Developer/work/ChatRoom/src/data-source'
}
```

Fixed it by reverting back from module to commonjs in package.json 

- [x] Node.js (TS) + Express
- [x] TypeORM
- [x] PostgreSQL
- [x] JWT for authentication
- [x] bcrypt for password hashing
- [x] USE Postman
- [x] YUP Validation
- [x] Class Transform
- [x] Common Error handling middleware
- [x] ENUMS for all error and success messages
- [x] Sockets - Chat Application / Kandbon board
- [x] Cluster moule
- [ ] Worker thread
- [ ] Mongo DB - Mongoose / Mongo client
- [ ] Session based auth
- [ ] Swagger
- [ ] Bull Mq
- [ ] Update folder structure
- [ ] Caching - may be user data with redis
- [ ] Background jobs with redis and bullmq
- [ ] Cron JOB
- [ ] loggers - (winston, Morgon)
- [ ] Test cases with Mock and without Mock
- [ ] Update Proper Readme
- [ ] Husky (pre commit/ pre push)
- [ ] Transaction (commit and rollback)
- [ ] Design Pattern (Builder, factory pattern)
- [ ] Nodemon
- [ ] External API from node APP -
- [ ] Jest or Supertest for test cases
- [ ] PM2

