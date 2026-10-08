const http = require("http");

const server = http.createServer((req, res) => {
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("Hello from Docker on AWS EC2!\n");
});

server.listen(8080, "0.0.0.0", () => {
    console.log("Server running on port 8080");
});