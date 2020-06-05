# Cheatsheet

A reference document for me to use for commonly addressed settings and
configurations that I haven't quite memorized.

## VIM

Inserting comments to the end of a block of text:

```bash
C-v
Shift-}
Shift-i
#
Esc
```

To take comments out:

```bash
C-v
j # To where you want to uncomment
x
```

Copy and pasting a block of text:

```bash
# Move cursor to first line in block of text
y # To yank
} # To move to end of text block
# Move cursor to where you want to paste
p # To paste
```


