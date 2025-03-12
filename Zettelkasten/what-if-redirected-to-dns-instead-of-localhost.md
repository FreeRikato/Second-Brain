I was developing this project called turso and had it linked with my static ip. Going to this website will hit the static ip at ports 3000 and 8000 of Next js and FastAPI respectively. After I assigned DNS to this server and setted up next auth with redirection and callbacks for google authentication. I fell into this problem where if I want to do local testing in my Mac it goes to the DNS even when the server is not running. In such a situation, clearing the browser cache and changing the 

```env
NEXT_AUTH_URL=http:localhost:3000
```

will fix the issue. There will be a lag with all this DNS, Callback, localhost and cookies change.

