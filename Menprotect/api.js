require("dotenv").config();
const express = require("express");
const fs = require("fs");
const app = express();
app.use(express.json({limit: "1gb"}));
fs.readdirSync("./routes").forEach(function(name) {
    let Module = require(`./routes/${name.split(".")[0]}`);
    app.use(`/${Module.name}`, Module.router);
});


app.listen(process.env.PORT || 5012);