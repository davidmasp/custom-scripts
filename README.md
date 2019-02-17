# Custom Scripts :triangular_flag_on_post:


These are a set of custom scripts that make my life easier. 

## Installation

To install all scripts are once, c-p this chunk in a bash/zsh shell in your system. Note that the `$FOLDERINPATH` variable must be a folder in your `$PATH`.


```bash
DIRECTORY="$HOME/bin"

if [[ ":$PATH:" == *":$DIRECTORY:"* ]]; then
  echo "Your path is correctly set, moving files to $DIRECTORY"
  for i in $(ls *.sh); do
    ln -s $(realpath $i) $DIRECTORY
  done
  
else
  echo "Your path is missing $DIRECTORY, you might want to add it."
fi
```

To install just one script do the following

```bash
DIRECTORY="$HOME/bin"
ln -s $(realpath adsleeper.sh) $DIRECTORY
```

In order to use the scripts just run them as CLI

## Doc

* [archive.sh](archive.sh) - :lock: - Generates a `.tar.gz` archive from the selected folder. It also adds the last time a file was modified in that folder as prefix of the future archive file.
* [du_command.sh](du_command.sh) - :truck: - Generates a du table for all files in the target directory. Note: Sizes are in MB.
* [plotFiles.R](plotFiles.R) - :: - Generates a barplot (pdf) with the output of `du -sm *` in the current directory.
* [uselatex.sh](uselatex.sh) - :: - builds a standard current project of latex with bibliography
* [adsleeper.sh](adsleeper.sh) - :: - Compiles asciidoctor files in the current directory in a while loop.
 
