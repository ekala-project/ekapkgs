#!/usr/bin/env bun

// Bun.Archive.write stamps each tar header with the current time, making the
// embedded stats-dashboard archive non-reproducible. Zero every header mtime,
// fix the checksum, and re-gzip (gzip's own mtime is already zero).

import { gunzipSync, gzipSync } from "node:zlib";

const BLOCK = 512;
const SIZE_OFF = 124;
const MTIME_OFF = 136;
const CHKSUM_OFF = 148;

function parseOctal(buf: Buffer, off: number, len: number): number {
  const s = buf.toString("ascii", off, off + len).replace(/\0.*$/, "").trim();
  return s.length === 0 ? 0 : parseInt(s, 8);
}

function writeOctal(buf: Buffer, off: number, len: number, value: number): void {
  // GNU/ustar numeric fields: (len - 1) octal digits, NUL-terminated.
  const digits = value.toString(8).padStart(len - 1, "0");
  buf.write(digits, off, len - 1, "ascii");
  buf[off + len - 1] = 0;
}

function fixChecksum(header: Buffer): void {
  // Checksum is summed with its own field treated as 8 spaces.
  header.fill(0x20, CHKSUM_OFF, CHKSUM_OFF + 8);
  let sum = 0;
  for (let i = 0; i < BLOCK; i++) sum += header[i]!;
  header.write(sum.toString(8).padStart(6, "0"), CHKSUM_OFF, 6, "ascii");
  header[CHKSUM_OFF + 6] = 0;
  header[CHKSUM_OFF + 7] = 0x20;
}

function normalizeTar(tar: Buffer): Buffer {
  let off = 0;
  while (off + BLOCK <= tar.length) {
    const header = tar.subarray(off, off + BLOCK);
    // Two consecutive zero blocks mark the end of the archive.
    if (header.every(b => b === 0)) break;
    writeOctal(header, MTIME_OFF, 12, 0);
    fixChecksum(header);
    const size = parseOctal(header, SIZE_OFF, 12);
    off += BLOCK + Math.ceil(size / BLOCK) * BLOCK;
  }
  return tar;
}

const file = process.argv[2];
if (!file) {
  console.error("usage: normalize-embedded-client.ts <path>");
  process.exit(1);
}

const b64 = (await Bun.file(file).text()).trim();
if (b64.length === 0) process.exit(0); // empty placeholder

const tar = normalizeTar(Buffer.from(gunzipSync(Buffer.from(b64, "base64"))));
const gz = gzipSync(tar, { level: 9 });
await Bun.write(file, gz.toString("base64"));
console.log(`Normalized ${file}`);
