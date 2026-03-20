const express = require("express");

const app = express();
const PORT = 3000;

app.get("/", (req, res) => {
  res.send("App is running 🚀");
});

app.get("/health", (req, res) => {
  res.json({ status: "ok" });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});