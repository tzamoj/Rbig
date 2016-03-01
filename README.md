Scripts are written to be executed from the root directory of the project. That is, paths are relative to the root: e.g. to include the image, use 'data/imageFile' or './data/imageFile'

As the test directory mimicks the root directory, you can use the same relative paths in test/src scripts. 

The project directory structure is quite self-explanatory, and you can add some directories if you need:
- src : source-code files that are tested and are to be included in the project
- data: all data files that the project will work on or outputs (this could be separated in in and out subfolders)
- test: here is where we develop first, with data and src as subdirectories. Not all files will make it to the project, for example the testing scripts. 



