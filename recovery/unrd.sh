#!/bin/bash
set -euo pipefail

INPUT_FILE="ramdisk"
OUTPUT_DIR="unpacked"

mkdir -p "$OUTPUT_DIR"

echo "查找 gzip 压缩数据偏移..."
GZIP_OFFSET=$(binwalk "$INPUT_FILE" | grep -i gzip | head -n1 | awk '{print $1}')
if [ -z "$GZIP_OFFSET" ]; then
  echo "未找到 gzip 压缩数据偏移！退出"
  exit 1
fi
echo "gzip 数据偏移（字节）: $GZIP_OFFSET"

echo "提取 DTB 到 $OUTPUT_DIR/ramdisk.dtb ..."
dd if="$INPUT_FILE" bs=1 count="$GZIP_OFFSET" of="$OUTPUT_DIR/ramdisk.dtb" status=none

echo "提取 gzip 压缩的 ramdisk ..."
dd if="$INPUT_FILE" bs=1 skip="$GZIP_OFFSET" of="$OUTPUT_DIR/ramdisk.cpio.gz" status=none

HEAD_BYTES=$(head -c 3 "$OUTPUT_DIR/ramdisk.cpio.gz" | xxd -p)
if [ "$HEAD_BYTES" != "1f8b08" ]; then
  echo "错误：提取文件不是有效 gzip 格式，头部为 $HEAD_BYTES"
  exit 2
fi

echo "开始解压 ramdisk.cpio.gz ..."
gzip -d -c "$OUTPUT_DIR/ramdisk.cpio.gz" > "$OUTPUT_DIR/ramdisk.cpio"

echo "解包 cpio 到 $OUTPUT_DIR/rootfs/ ..."
mkdir -p "$OUTPUT_DIR/rootfs"
(cd "$OUTPUT_DIR/rootfs" && cpio -idmv < ../ramdisk.cpio)

echo "完成！"
