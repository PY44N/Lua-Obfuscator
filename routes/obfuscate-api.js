const menprotect = require("../menprotect");
const express = require("express");
const obfuscator = new menprotect();
const router = new express.Router();
router.post("/", function(req, res) {
    if (req.body.key && req.body.key == "RmwIK1gL0ijEaSNC") {
        obfuscator.obfuscate({
            script: req.body.script || "do end",
            callback: function(data) {
                res.end(data.script);
            },
            log: function(info) {
                if (info.status == 4) {
                    res.status(400).end(info.body);
                };
            },
            options: {
                mutations: {
                    enabled: true,
                    max: {
                        enabled: true,
                        amount: 50,
                    },
                },
            }
        });
    } else {
        res.status(400).end("");
    };
});

module.exports = {
    name: "obfuscate",
    router: router
};