### 1. Middleware return type error
```
Type '(req: Request, res: Response, next: NextFunction) => Promise<Response<any, Record<string, any>> | undefined>' is not assignable to type 'RequestHandler<ParamsDictionary, any, any, ParsedQs, Record<string, any>>'. Type 'Promise<Response<any, Record<string, any>> | undefined>' is not assignable to type 'void | Promise<void>'. Type 'Promise<Response<any, Record<string, any>> | undefined>' is not assignable to type 'Promise<void>'. Type 'Response<any, Record<string, any>> | undefined' is not assignable to type 'void'. Type 'Response<any, Record<string, any>>' is not assignable to type 'void'.
```

> Context

This error occurs when we use async function like this:

```ts
(req: Request, res: Response, next: NextFunction) => Promise<Response<any, Record<string, any>> | undefined>
```

as a middleware or route handler in Express, which expects the type: 

```ts
RequestHandler<ParamsDictionary, any, any, ParsedQs, Record<string, any>>
```

```
Type '(req: Request, res: Response, next: NextFunction) => Promise<Response<any, Record<string, any>> | undefined>' is not assignable to type 'RequestHandler<ParamsDictionary, any, any, ParsedQs, Record<string, any>>'.
```

> Root Cause 

Express expects middleware functions to either:
- return nothing (`void`), or
- return a `Promise<void>` if asynchronous

```
Type 'Promise<Response<any, Record<string, any>> | undefined>' is not assignable to type 'void | Promise<void>'. 

Type 'Promise<Response<any, Record<string, any>> | undefined>' is not assignable to type 'Promise<void>'. 

Type 'Response<any, Record<string, any>> | undefined' is not assignable to type 'void'. 

Type 'Response<any, Record<string, any>>' is not assignable to type 'void'
```

From the above, we can infer that my function returns a `Promise<Response>` or
`undefined`, not `Promise<void>`.

Even though i might be calling `res.send()` or `res.json()` - which returns a
Response - I am not supposed to return it from the middleware

I am only supposed to call it and return `void` (or `undefined` implicitly)
