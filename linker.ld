ENTRY(entry)
OUTPUT_FORMAT("binary")
phys = 0x00007e00;

SECTIONS
{
    . = phys;

    .text.entry         : { __text_entry_start = .; *(.text.entry)   }
    .text               : { __text_start = .;       *(.text)         }
    .data               : { __data_start = .;       *(.data)         }
    .rodata             : { __rodata_start = .;     *(.rodata)       }
    .bss                : { __bss_start = .;        *(.bss)          }
    
    __end = .;
}