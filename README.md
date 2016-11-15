'puter structions tools
=============

Tools used by 'puter structions devops groups

Hacking on the tools
--------------------

This project uses a standard GNU Autotools build system.  'nough said.

### Windows Environment Setup
Download the two files in `cygwin-install`
https://github.com/puterstructions/tools/tree/master/cygwin-install

Run (double-click works) the install.bat file.  
Add C:\cygwin64\bin to your PATH.  Now the rest of the setup below should now work from your Cygwin terminal.

### Mac Environment Setup
On mac use brew and package names are autoconf, automake, and jq

### Runbook tools setup

A major part of our workflow involves documentation, which we call runbooks.  You'll need to be able to create/use them.  Follow these steps:

Get pip, if you don't have it
```
$ sudo easy_install pip
```
For Windows cygwin environments to get pip
```
easy_install-2.7 pip
```
Checkout this repo and change to the `cygwin-install` directory, then
```
pip install --no-cache-dir -r requirements.txt
```
Now view it in your browser at `http://localhost:8000`.  You can also use the terminal to lauch it like so

### Bootstrapping the build
There are a lot of opinions on building with autotools, these are Sandman's.  Feel free to ignore them and build the project using your own autotools practices.

From the project root,
```
autoreconf --install
mkdir build
cd build
../configure --prefix=$PWD
```
`autoreconf` will generate all the scripts needed to configure the build.  The `--prefix` will cause all the Makefiles to use the specified *absolute* path for installation--handy for testing the build.

### Using the build
*Remember to run `make ...` from the same directory you ran `./configure`*

Once you have the build configured, run it is just the normal make stuff, e.g.
```
make install
```
### Distribution

There are a number of ways to distribute projects using Autotools, it's one of the perks.  The easiest is using `dist`
```
make dist
```
You should see some archives in the project root, usually a tarball and a zip.  This can be changed in `configure.ac`. Before you really release you should test the distribution.  Again, Autotools makes this really easy.
```
make distcheck
```
This will ensure that your distribution passes all the standard checks.  For example, in this project Autotools is configured to ensure all executables provide `--help` and `--version`.

*NOTE: currently `make distcheck` may fail, see [issue #3](https://github.com/puterstructions/tools/issues/3)*


Autotools to Docker
-------------------

There are lots of ways to build a Docker image from an Autotools build.  For convenience you can use the `distbin` script in this project

    $ distbin
    $ Docker build -t puterstructions-tools .

GitHub Project Management Tools
-------------------------------
This is a collection of third-party integrations for GitHub that *may* help us.

- https://github.com/integrations/overv-io
- https://github.com/integrations/planio
- https://github.com/integrations/roadmap
- https://github.com/integrations/zube
- https://github.com/integrations/huboard
- https://github.com/integrations/zenhub
- https://github.com/integrations/codetree
- https://github.com/integrations/blossom
- https://github.com/integrations/sprintly
- https://github.com/integrations/youtrack
- https://github.com/integrations/everhour

