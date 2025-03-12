const crypto = require("crypto");
const fs = require("fs");

function getFileSha1(filePath) {
    return new Promise((resolve, reject) => {
        const hash = crypto.createHash("sha1");
        const stream = fs.createReadStream(filePath);

        stream.on("data", (chunk) => {
            hash.update(chunk);
        });

        stream.on("end", () => {
            resolve(hash.digest("hex"));
        });

        stream.on("error", (err) => {
            reject(err);
        });
    });
}

const filePath = "Bamboo2-Resources.zip";
getFileSha1(filePath)
    .then((sha1) => console.log(`SHA1: ${sha1}`))
    .catch((err) => console.error(`Error: ${err.message}`));
