const path = require('path');
const fs = require('fs');

// Hvigor wrapper script
const HVIGOR_BOOT_JS_FILE_PATH = path.resolve(__dirname, 'hvigor-boot.js');
const HVIGOR_CACHE_HOME = process.env.HVIGOR_CACHE_HOME || path.resolve(process.env.HOME || process.env.USERPROFILE, '.hvigor');

function deleteFolder(folderPath) {
    if (fs.existsSync(folderPath)) {
        fs.readdirSync(folderPath).forEach((file) => {
            const curPath = path.join(folderPath, file);
            if (fs.lstatSync(curPath).isDirectory()) {
                deleteFolder(curPath);
            } else {
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(folderPath);
    }
}

function requireModule(modulePath) {
    if (!fs.existsSync(modulePath)) {
        console.error(`Error: Cannot find module '${modulePath}'`);
        console.error('Please run: npm install or ohpm install');
        process.exit(1);
    }
    return require(modulePath);
}

// Execute hvigor boot script
if (fs.existsSync(HVIGOR_BOOT_JS_FILE_PATH)) {
    requireModule(HVIGOR_BOOT_JS_FILE_PATH);
} else {
    // Try to load from node_modules
    const projectRoot = path.resolve(__dirname, '../..');
    const hvigorPath = path.resolve(projectRoot, 'node_modules/@ohos/hvigor/bin/hvigor.js');

    if (fs.existsSync(hvigorPath)) {
        requireModule(hvigorPath);
    } else {
        console.error('Error: Hvigor is not installed.');
        console.error('Please run: npm install or ohpm install');
        process.exit(1);
    }
}
