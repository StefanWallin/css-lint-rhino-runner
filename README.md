Description
===========
This project is bashscript intended to be run by a project Makefile to add CSS-linting of css-files during a build process. It's exit status is the number of errors found.

The script utilizes the Apache Rhino javascript engine to run the Rhino-version of the csslint.net-linter.

Goals
-----
* Errors(or warnings if in strict mode) should brake an ongoing build.
* Make routine usage of the linter super easy.

Todo
----
* Make the script accept directories as command line arguments.
* Make the script accept directories from stdin.
* Make the script go into strict mode and exit on number of warnings instead of errors.
* Create install-script that get your dependencies.
* Create an update-script that updates the version of your css-linter.

Usage
-----
Current usage is not ideal. 

1. Install a JDK, download and install Rhino, download the csslint-rhino.js-file.
1. Then you edit the script and change the folder to work on.
1. Make modifications to paths for the rhino.jar in the script if necessary.
1. Run the linter!

    ./lint.sh

