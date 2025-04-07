zd
==

`xxd` clone without options.

Inspired by https://www.youtube.com/watch?v=pnnx1bkFXng.

### Build

Requires Zig 0.13.0.

```
zig buiild
```

### Usage

```
Usage: zd <file>
```

```
dd if=/dev/urandom of=/tmp/test.bin bs=8 count=5

./zig-out/bin/zd /tmp/test.bin
00000000: 0023 8a55 0f5a 89f5 36af 5990 e4b0 ae23  .#.U.Z..6.Y....#
00000010: 3de6 4ab3 71cf add7 a24f 2f78 d435 f282  =.J.q....O/x.5..
00000020: 8fcd 04c2 52f3 6a75                      ....R.ju

# Output from xxd
xxd /tmp/test.bin
00000000: 0023 8a55 0f5a 89f5 36af 5990 e4b0 ae23  .#.U.Z..6.Y....#
00000010: 3de6 4ab3 71cf add7 a24f 2f78 d435 f282  =.J.q....O/x.5..
00000020: 8fcd 04c2 52f3 6a75                      ....R.ju
```
