@echo off
rem Usage: Batch_zip.bat <source_directory> <archive_name.zip>

for %%f in (%1\*.txt) do 7z a %2 "%%f"