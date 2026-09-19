import { readFile } from 'node:fs/promises'

const composePath = new URL('../docker-compose.custom-node.yml', import.meta.url)
const compose = await readFile(composePath, 'utf8')

if (!/env_file:\s*\n\s*-\s*\.env\.node\b/.test(compose)) {
    throw new Error('docker-compose.custom-node.yml must load .env.node')
}

const environmentBlock = compose.match(/\n\s{4}environment:\s*\n((?:\s{6,}.*(?:\n|$))*)/)?.[1] ?? ''
if (/^\s+SECRET_KEY\s*:/m.test(environmentBlock)) {
    throw new Error('SECRET_KEY must not be declared in environment; use .env.node only')
}

for (const key of ['NODE_PORT', 'PORT_HOPPING_INGRESS']) {
    if (!new RegExp(`^\\s+${key}\\s*:`, 'm').test(environmentBlock)) {
        throw new Error(`${key} must remain explicitly configured`)
    }
}

console.log('custom node compose configuration is valid')
