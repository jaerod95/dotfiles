#! /usr/bin/env node

import fs from "fs"
import child_process from "child_process"

const fileContents = fs.readFileSync("/tmp/git-comment.md", "utf8")
const prNumber = fs.readFileSync("/tmp/git-comment-pr.txt", "utf8").trim()
const repo = fs.readFileSync("/tmp/git-comment-repo.txt", "utf8").trim()
const commitSha = fs.readFileSync("/tmp/git-comment-sha.txt", "utf8").trim()
const token = child_process.execSync("gh auth token").toString().trim()
const url = `https://api.github.com/repos/${repo}/issues/${prNumber}/comments`

const sections = fileContents.split("<!--- Github PR Comment -->").filter((s) => s.trim())

const comments = sections.map((section) => {
  const filePath = section.match(/File Path: (.*) -->/)?.[1]
  const lineNumber = section.match(/Line Number: (\d*) -->/)?.[1]
  const body = section.split("\n").slice(3).join("\n").trim()
  return {
    body,
    commit_id: commitSha,
    line: parseInt(lineNumber),
    path: filePath,
    side: "RIGHT",
  }
})

async function postComments() {
  for (const comment of comments) {
    const response = await fetch(url, {
      body: JSON.stringify(comment),
      headers: {
        "Content-Type": "application/json",
        Authorization: `token ${token}`,
      },
      method: "POST",
    })
    const data = await response.json()
    console.log(data)
  }
}

postComments().catch(console.error)
