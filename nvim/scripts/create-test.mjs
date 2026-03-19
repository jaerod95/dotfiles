#! /usr/bin/env node
import buildPrompt from "<REDACTED>/build-prompt/index.js"
import { spawnSync } from "child_process"
import { randomUUID } from "crypto"
import fs from "fs"

const uuid = randomUUID().slice(0, 8)
const targetFilePath = process.argv[2]
const prompt = buildPrompt({
  extensionCtx: { extensionPath: "<REDACTED>" },
  targetFilePath,
})
const currentTmuxSession = spawnSync("tmux", ["display-message", "-p", "#S"]).stdout.toString().trim()
const claudeCommand = `claude "read and execute /tmp/create-test-prompt-${uuid}.txt" --dangerously-skip-permissions`

fs.writeFileSync(`/tmp/create-test-prompt-${uuid}.txt`, prompt)
spawnSync("tmux", ["new-window", "-t", currentTmuxSession, "-n", uuid])
spawnSync("tmux", ["send-keys", "-t", `${currentTmuxSession}:${uuid}`, claudeCommand, "C-m"])
spawnSync("atuin", ["search", "dangerously-skip-permissions", "--delete"])
