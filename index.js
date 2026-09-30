// Local development entrypoint: npm install && node index.js
// Vercel uses api/[...path].js. Never commit .env.
import { createServer } from "node:http";
import handler from "./api/[...path].js";
const server=createServer((req,res)=>handler(req,res));
server.listen(process.env.PORT||3000,()=>console.log("PayX API listening on port",process.env.PORT||3000));
