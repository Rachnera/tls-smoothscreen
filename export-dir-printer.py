#!/usr/bin/env python3

# This script requires pefile to be installed: https://github.com/erocarrera/pefile

import sys
import pefile

def print_export_directory_content(dir):
    print("RVA".ljust(12), "Name".ljust(48), "Dword")
    for exp in dir.symbols:            
        print(hex(exp.address).ljust(12), exp.name.decode('utf-8').ljust(48), pe.get_dword_at_rva(exp.address))

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python patcher.py 'path_to_exe'")
        print("Example: python patcher.py Game.exe")
        exit(1)

    exe_path = sys.argv[1]

    pe = pefile.PE(exe_path)

    if not hasattr(pe, 'DIRECTORY_ENTRY_EXPORT'):
        print("No export directory found.")
        exit(0)

    print_export_directory_content(pe.DIRECTORY_ENTRY_EXPORT)
