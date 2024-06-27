import { ValidateEnv } from '@julr/vite-plugin-validate-env';
import { TanStackRouterVite } from '@tanstack/router-plugin/vite';
import react from '@vitejs/plugin-react';
import million from 'million/compiler';
import { visualizer } from 'rollup-plugin-visualizer';
import TurboConsole from 'unplugin-turbo-console/vite';
import { defineConfig } from 'vite';
import autoAlias from 'vite-plugin-auto-alias';
import { chunkSplitPlugin } from 'vite-plugin-chunk-split';
import { nodePolyfills } from 'vite-plugin-node-polyfills';
import viteTsconfigPaths from 'vite-tsconfig-paths';

// https://vitejs.dev/config/
const _plugins = [
  million.vite({ auto: true }),
  TanStackRouterVite(),
  react(),
  viteTsconfigPaths(),
  ValidateEnv(),
  chunkSplitPlugin(),
  nodePolyfills(),
  TurboConsole(),
  autoAlias({
    mode: 'off',
  }),
  visualizer({
    template: 'treemap',
    open: true,
    gzipSize: true,
    brotliSize: true,
    filename: 'analyzer.html',
  }),
];

export default defineConfig({
  plugins: _plugins,
  build: {
    rollupOptions: {
      output: {
        sourcemap: false,
        manualChunks(id) {
          if (id.includes('node_modules')) {
            return id
              .toString()
              .split('node_modules/')[1]
              .split('/')[0]
              .toString();
          }
        },
      },
    },
  },
});
