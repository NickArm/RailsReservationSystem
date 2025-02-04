const esbuild = require("esbuild");

esbuild.build({
    entryPoints: {
        "application": "app/javascript/application.js",
        "admin/application": "app/javascript/admin/application.js",
    },
    bundle: true,
    outdir: "app/assets/builds",
    sourcemap: true,
    loader: { ".js": "jsx" },
    publicPath: "/assets",
    watch: process.argv.includes("--watch"),
}).catch(() => process.exit(1));
