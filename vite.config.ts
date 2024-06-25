import { ValidateEnv } from '@julr/vite-plugin-validate-env';
import { TanStackRouterVite } from '@tanstack/router-plugin/vite';
import react from '@vitejs/plugin-react';
import million from 'million/compiler';
import { defineConfig } from 'vite';
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
];

export default defineConfig({
  plugins: _plugins,
});
